#include "mainwindow.h"

#include <QApplication>
#include "db_connection.h"

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    MainWindow w;

    if (!createConnection())
    {
        return 1;
    }

    w.fillTable();
    w.fillPassengers();
    w.fillFlights();

    w.show();
    return a.exec();
}
