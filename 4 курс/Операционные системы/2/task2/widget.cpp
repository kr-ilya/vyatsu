#include "widget.h"
#include "./ui_widget.h"
#include <QGraphicsPixmapItem>
#include <QGraphicsTextItem>
#include <QObject>
#include <QGraphicsItemAnimation>
#include <cmath>
#include <iostream>

#define PH_IMG_RADIUS 170
#define FORK_IMG_RADIUS 80
#define SCENE_WIDTH 450
#define SCENE_HEIGHT 400
#define GRABBED_FORK_X_OFFSET 16
#define GRABBED_FORK_Y_OFFSET 16
#define MAX_THINKING_DURATION_MS 10000
#define ANIMATION_DURATION_MS 100

const double pi = 3.14159265358979323846;
const double angle_step = 2 * pi / NUM_PHILOSOPHERS;
const double fork_angle_offset = -angle_step * 0.5;

Widget::Widget(QWidget *parent)
    : QWidget(parent)
    , ui(new Ui::Widget)
{
    ui->setupUi(this);

    QObject::connect(&t, &Task::grabForkSignal, this, &Widget::grabFork, Qt::UniqueConnection);
    QObject::connect(&t, &Task::resetForkSignal, this, &Widget::resetFork, Qt::UniqueConnection);
    QObject::connect(&t, &Task::changePhLabelSignal, this, &Widget::setPhLabel, Qt::UniqueConnection);

    connect(ui->slider1, &QSlider::valueChanged, this, [this](int value) {
        auto v = static_cast<unsigned int>(value);
        unsigned int delay = MAX_THINKING_DURATION_MS * v / 100;
        t.setThinkingDuration(0, delay);
    });

    connect(ui->slider2, &QSlider::valueChanged, this, [this](int value) {
        auto v = static_cast<unsigned int>(value);
        unsigned int delay = MAX_THINKING_DURATION_MS * v / 100;
        t.setThinkingDuration(1, delay);
    });
    
    connect(ui->slider3, &QSlider::valueChanged, this, [this](int value) {
        auto v = static_cast<unsigned int>(value);
        unsigned int delay = MAX_THINKING_DURATION_MS * v / 100;
        t.setThinkingDuration(2, delay);
    });
    
    connect(ui->slider4, &QSlider::valueChanged, this, [this](int value) {
        auto v = static_cast<unsigned int>(value);
        unsigned int delay = MAX_THINKING_DURATION_MS * v / 100;
        t.setThinkingDuration(3, delay);
    });
    
    connect(ui->slider5, &QSlider::valueChanged, this, [this](int value) {
        auto v = static_cast<unsigned int>(value);
        unsigned int delay = MAX_THINKING_DURATION_MS * v / 100;
        t.setThinkingDuration(4, delay);
    });

    t.setGrabForkFn();
    t.setResetForkFn();
    t.setChangePhLabelFn();

    setupScene();
    render();
}

Widget::~Widget()
{
    delete ui;
    t.stop();
}

//закрыть
void Widget::on_pushButton_clicked()
{
    this->close();
}

//start
void Widget::on_pushButton_2_clicked()
{
    qDebug() << "Start clicked";
    this->ui->pushButton_2->setEnabled(false);
    this->ui->pushButton_3->setEnabled(true);
    t.start();
}

// stop
void Widget::on_pushButton_3_clicked()
{
    qDebug() << "Stop clicked";
    t.stop();
    this->ui->pushButton_2->setEnabled(true);
    this->ui->pushButton_3->setEnabled(false);
}

void Widget::setupScene() {
    auto *view = this->ui->graphicsView;
    auto *scene = new QGraphicsScene();
    view->setScene(scene);
    scene->setSceneRect(0, 0, SCENE_WIDTH, SCENE_HEIGHT);
}

void Widget::render() {
    auto *view = this->ui->graphicsView;
    auto *scene = ui->graphicsView->scene();

    for (int i = 0; i < NUM_PHILOSOPHERS; ++i) {
        // philosophers
        QGraphicsItem* philosopherItem = new QGraphicsPixmapItem(phImg[i]);
        scene->addItem(philosopherItem);
        double phX = scene->width()/2 + PH_IMG_RADIUS * std::sin(angle_step * i) - PH_IMG_SIZE / 2;
        double phY = scene->height()/2 + PH_IMG_RADIUS * std::cos(angle_step * i) - PH_IMG_SIZE / 2;
        QPointF phPos{phX, phY};
        philosopherItem->setPos(phPos);

        // ids
        phLabels[i] = new QGraphicsTextItem(QString("%1: Думаю").arg(i + 1));
        scene->addItem(phLabels[i]);
        QPointF pos{phX + PH_IMG_SIZE / 2 - 4, phY - 20};
        phLabels[i]->setPos(pos);

        // forks
        forksImgItems[i] = new QGraphicsPixmapItem(forkImg);
        scene->addItem(forksImgItems[i]);
        double fX = scene->width()/2 + FORK_IMG_RADIUS * std::sin(angle_step * i + fork_angle_offset) - FORK_IMG_WIDTH / 2;
        double fY = scene->height()/2 + FORK_IMG_RADIUS * std::cos(angle_step * i + fork_angle_offset) - FORK_IMG_HEIGHT / 2;
        QPointF fPos{fX, fY};
        forksImgItems[i]->setPos(fPos);
    }

    // lapsha
    QGraphicsItem* philosopherItem = new QGraphicsPixmapItem(lapshaImg);
    scene->addItem(philosopherItem);
    double x = scene->width()/2 - LAPSHA_IMG_SIZE / 2;
    double y = scene->height()/2 - LAPSHA_IMG_SIZE / 2;
    QPointF pos{x, y};
    philosopherItem->setPos(pos);

}

void Widget::grabFork(int ph_id, int fork_id) {
    double fork_x_offset;
    double fork_y_offset = -PH_IMG_SIZE / 2 + GRABBED_FORK_Y_OFFSET;
    if (ph_id == fork_id) {
        fork_x_offset = -PH_IMG_SIZE / 2 - GRABBED_FORK_X_OFFSET;
    } else {
        fork_x_offset = PH_IMG_SIZE / 2 + GRABBED_FORK_X_OFFSET;
    }

    auto *scene = ui->graphicsView->scene();
    double x = scene->width()/2 + PH_IMG_RADIUS * std::sin(angle_step * ph_id) + fork_x_offset;
    double y = scene->height()/2 + PH_IMG_RADIUS * std::cos(angle_step * ph_id) + fork_y_offset;
    // forksImgItems[fork_id]->setPos({x, y});

    animTimer[fork_id] = new QTimeLine(ANIMATION_DURATION_MS, this);
    QGraphicsItemAnimation *animation = new QGraphicsItemAnimation(animTimer[fork_id]);
    connect(animTimer[fork_id], QTimeLine::finished, this, [=](){onAnimationFinished(fork_id);}, Qt::AutoConnection);
    animation->setItem(forksImgItems[fork_id]);
    animation->setTimeLine(animTimer[fork_id]);
    animation->setPosAt(1.0, {x, y});
    animTimer[fork_id]->start();
}

void Widget::onAnimationFinished(int fid) {
    sender()->deleteLater();
    animTimer[fid] = nullptr;
}

void Widget::resetFork(int fork_id) {
    if(animTimer[fork_id] != nullptr) {
        animTimer[fork_id]->stop();
        delete(animTimer[fork_id]);
        animTimer[fork_id] = nullptr;
    }

    auto *scene = ui->graphicsView->scene();
    double x = scene->width()/2 + FORK_IMG_RADIUS * std::sin(angle_step * fork_id + fork_angle_offset) - FORK_IMG_WIDTH / 2;
    double y = scene->height()/2 + FORK_IMG_RADIUS * std::cos(angle_step * fork_id + fork_angle_offset) - FORK_IMG_HEIGHT / 2;
    forksImgItems[fork_id]->setPos({x, y});
}

void Widget::setPhLabel(int id, std::string t) {
    phLabels[id]->setPlainText(QString("%1: %2").arg(id + 1).arg(QString::fromStdString(t)));
}