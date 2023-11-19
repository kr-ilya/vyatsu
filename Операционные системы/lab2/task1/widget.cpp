#include "widget.h"
#include "ui_widget.h"
#include <QScrollBar>
#include <QTimer>


Widget::Widget(QWidget *parent)
    : QWidget(parent), ui(new Ui::Widget)
{
    ui->setupUi(this);


    connect(ui->slider1, &QSlider::valueChanged, this, [this](int value) {
        auto v = static_cast<unsigned int>(value);
        unsigned int delay = 6000 * v / 100;
        t.setTimeout(1, delay);
    });

    connect(ui->slider2, &QSlider::valueChanged, this, [this](int value) {
        auto v = static_cast<unsigned int>(value);
        unsigned int delay = 6000 * v / 100;
        t.setTimeout(2, delay);
    });

    t.setLogThread([this](uint pid, std::string s){
        appendThreadLog(pid, s);
    });

    t.setStopThreadsCb([this](){
        onStopThreads();
    });
}

Widget::~Widget()
{
    delete ui;
    t.stop();
}

// close
void Widget::on_pushButton_3_clicked()
{
    this->close();
}

//start
void Widget::on_pushButton_clicked()
{
    qDebug() << "Started";
    this->ui->pushButton->setEnabled(false);
    this->ui->pushButton_2->setEnabled(true);
    t.start();
    this->ui->pushButton_4->setEnabled(false);
}

//stop
void Widget::on_pushButton_2_clicked()
{
    qDebug() << "Stop";
    t.stop();
    this->ui->pushButton->setEnabled(true);
    this->ui->pushButton_2->setEnabled(false);
    this->ui->pushButton_4->setEnabled(true);
}

void Widget::appendThreadLog(uint tid, std::string mes) {
    switch (tid) {
    case 1: {
        this->ui->textEdit->append(QString::fromStdString(mes));
        QTimer::singleShot(0, this, [this](){
            // Получаем вертикальный ползунок QTextEdit
            QScrollBar* verticalScrollBar = this->ui->textEdit->verticalScrollBar();
            // Устанавливаем значение ползунка в максимальное положение
            verticalScrollBar->setValue(verticalScrollBar->maximum());
        });
        break;
    }
    case 2: {
        this->ui->textEdit_2->append(QString::fromStdString(mes));
        QTimer::singleShot(0, this,  [this](){
            // Получаем вертикальный ползунок QTextEdit
            QScrollBar* verticalScrollBar = this->ui->textEdit_2->verticalScrollBar();
            // Устанавливаем значение ползунка в максимальное положение
            verticalScrollBar->setValue(verticalScrollBar->maximum());
        });
        break;
    }
    }
}

void Widget::onStopThreads() {
    this->ui->pushButton->setEnabled(true);
    this->ui->pushButton_2->setEnabled(false);
}

// reset
void Widget::on_pushButton_4_clicked()
{
    qDebug() << "reset clicked";
    t.reset();
    this->ui->textEdit->clear();
    this->ui->textEdit_2->clear();
    this->ui->slider1->setValue(55);
    this->ui->slider2->setValue(55);
}

