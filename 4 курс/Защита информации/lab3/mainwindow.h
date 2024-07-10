#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include "algorithms/rsa/RSA.h"

QT_BEGIN_NAMESPACE
namespace Ui { class MainWindow; }
QT_END_NAMESPACE

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

private slots:
    void on_pushButton_clicked();

    void on_radioButton_clicked();

    void on_radioButton_2_clicked();

    void on_radioButton_3_clicked();

    void on_radioButton_4_clicked();

    void on_radioButton_5_clicked();

    void on_pushButton_2_clicked();

    void on_radioButton_6_clicked();

    void on_radioButton_7_clicked();

    void on_lineEditPval_textChanged(const QString &arg1);

    void on_lineEditQval_textChanged(const QString &arg1);

    void on_pushButton_3_clicked();

    void on_lineEditKeyN_textChanged(const QString &arg1);

private:
    Ui::MainWindow *ui;
    int taskSelected = 1;
    ULL rsa_p, rsa_q, rsa_e, rsa_d, rsa_n;
    bool hasRSAopenKey = false;
    bool hasRSAprivateKey = false;
    bool hasRSAnVal = false;

//    0 - P Q
//    1 - Ключи
    bool rsa_mode = false;

    RSA rsa;

    void selectTask(int task);
};
#endif // MAINWINDOW_H
