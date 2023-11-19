#ifndef WIDGET_H
#define WIDGET_H

#include <QWidget>
#include <QPixmap>
#include <QGraphicsItem>
#include <QGraphicsItemAnimation>
#include "task.h"

#define PH_IMG_SIZE 64
#define LAPSHA_IMG_SIZE 64
#define FORK_IMG_WIDTH 15
#define FORK_IMG_HEIGHT 45

QT_BEGIN_NAMESPACE
namespace Ui { class Widget; }
QT_END_NAMESPACE

class Widget : public QWidget
{
    Q_OBJECT

public:
    Widget(QWidget *parent = nullptr);
    ~Widget();

    void grabFork(int, int);
    void resetFork(int);
    void setPhLabel(int, std::string);

private slots:
    void on_pushButton_clicked();

    void on_pushButton_2_clicked();

    void on_pushButton_3_clicked();

    void onAnimationFinished(int);

private:
    Ui::Widget *ui;
    Task t;

    QPixmap phImg[NUM_PHILOSOPHERS]{
         QPixmap(":/r/img/1.png").scaled(PH_IMG_SIZE, PH_IMG_SIZE),
         QPixmap(":/r/img/2.png").scaled(PH_IMG_SIZE, PH_IMG_SIZE),
         QPixmap(":/r/img/3.png").scaled(PH_IMG_SIZE, PH_IMG_SIZE),
         QPixmap(":/r/img/4.png").scaled(PH_IMG_SIZE, PH_IMG_SIZE),
         QPixmap(":/r/img/5.png").scaled(PH_IMG_SIZE, PH_IMG_SIZE)
    };

    QPixmap lapshaImg = QPixmap(":/r/img/lapsha.png").scaled(LAPSHA_IMG_SIZE, LAPSHA_IMG_SIZE);
    QPixmap forkImg = QPixmap(":/r/img/fork.png").scaled(FORK_IMG_WIDTH, FORK_IMG_HEIGHT);

    QGraphicsItem* forksImgItems[NUM_PHILOSOPHERS];
    QGraphicsTextItem* phLabels[NUM_PHILOSOPHERS];

    QTimeLine* animTimer[NUM_PHILOSOPHERS];
    
    void setupScene();
    void render();
};
#endif // WIDGET_H
