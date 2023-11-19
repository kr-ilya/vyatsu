#ifndef WIDGET_H
#define WIDGET_H

#include <QWidget>
#include "task.h"

QT_BEGIN_NAMESPACE
namespace Ui { class Widget; }
QT_END_NAMESPACE

class Widget : public QWidget
{
    Q_OBJECT

public:
    Widget(QWidget *parent = nullptr);
    ~Widget();

    void appendThreadLog(uint tid, std::string mes);
    void onStopThreads();
    void onReset();

private slots:
    void on_pushButton_3_clicked();

    void on_pushButton_clicked();

    void on_pushButton_2_clicked();

    void on_pushButton_4_clicked();

private:
    Ui::Widget *ui;
    Task t;
//    QFuture<void> t1;
//    QFuture<void> t2;

};
#endif // WIDGET_H
