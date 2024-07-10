#include "mainwindow.h"
#include "./ui_mainwindow.h"
#include "db_connection.h"
#include <QMessageBox>

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);


    model = new QTableViewModel();


    this->ui->tableView->setModel(model);

    comboboxModel = new QComboBoxModel();
    this->ui->comboBox->setModel(comboboxModel);

    flightsModel = new FlightsCBModel();
    this->ui->comboBox_2->setModel(flightsModel);
}

MainWindow::~MainWindow()
{
    delete ui;
}


void MainWindow::fillTable()
{
    QList<TicketInfo> *data = getTickets();
    model->populate(data);
}


void MainWindow::fillPassengers()
{
    QList<QPair<int, QString>> *data = getPassengers();

    comboboxModel->populate(data);
}

void MainWindow::fillFlights()
{
    QList<QPair<int, QString>> *data = getFlights();

    flightsModel->populate(data);
}

void MainWindow::on_addRowBtn_clicked()
{

     int pasId = this->ui->comboBox->itemData(this->ui->comboBox->currentIndex()).toInt();
     QString passenger = this->ui->comboBox->itemData(this->ui->comboBox->currentIndex(), Qt::DisplayRole).toString();
     int flight = this->ui->comboBox_2->itemData(this->ui->comboBox_2->currentIndex()).toInt();
     int price = this->ui->lineEdit->text().toInt();


     if (pasId == 0 || flight == 0 || price <= 0) {
         return;
     }

     int lid = insertRow(pasId, flight, price);

     model->append(TicketInfo(lid, flight, price, passenger));
}


struct greater
{
    template<class T>
    bool operator()(T const &a, T const &b) const { return a > b; }
};

void MainWindow::on_pushButton_2_clicked()
{

    QItemSelectionModel *select = this->ui->tableView->selectionModel();
    QModelIndexList selection = select->selectedRows();
    QList<int> rowsIds;
    std::vector<int> ui_ids;

    for(int i=0; i < selection.count(); i++)
    {
        QModelIndex index = selection.at(i);

        rowsIds.push_back(index.model()->data(index, Qt::UserRole).toInt());

        ui_ids.push_back(index.row());

    }

    if (rowsIds.size() == 0)
    {
        return;
    }

    if (QMessageBox::Yes == QMessageBox(QMessageBox::Information, "Удаление", "Удалить?", QMessageBox::Yes|QMessageBox::No).exec())
    {
        std::sort(ui_ids.begin(), ui_ids.end(), greater());
        for (auto &id: ui_ids)
        {
            model->deleteRow(id);
        }

        deleteRows(rowsIds);
    }


}

void MainWindow::on_pushButton_clicked()
{
    int price = this->ui->lineEdit_2->text().toInt();
    if (price < 0) {
        return;
    }
    QList<TicketInfo> *data = getFilteredTickets(price);
    model->populate(data);
}

