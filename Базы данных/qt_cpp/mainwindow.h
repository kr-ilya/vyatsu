#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include "qtableviewmodel.h"
#include "qcomboboxmodel.h"
#include "flightscbmodel.h"
#include <QMainWindow>

QT_BEGIN_NAMESPACE
namespace Ui { class MainWindow; }
QT_END_NAMESPACE

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

    void fillTable();
    void fillPassengers();
    void fillFlights();

private slots:
    void on_addRowBtn_clicked();

    void on_pushButton_2_clicked();

    void on_pushButton_clicked();

private:
    Ui::MainWindow *ui;

    QTableViewModel *model;

    QComboBoxModel *comboboxModel;
    FlightsCBModel *flightsModel;

};
#endif // MAINWINDOW_H
