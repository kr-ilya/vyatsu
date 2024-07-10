#include "qtableviewmodel.h"
#include <QModelIndex>
#include <iostream>
QTableViewModel::QTableViewModel(QObject *parent)
    :QAbstractListModel(parent)
{
    values = new QList<TicketInfo>();
}

int QTableViewModel::rowCount(const QModelIndex &) const
{
    return values->count();
}

int QTableViewModel::columnCount(const QModelIndex &) const
{
    return 3;
}

QVariant QTableViewModel::data(const QModelIndex &index, int role) const
{
    QVariant value;

        switch ( role )
        {
            case Qt::DisplayRole: //string
            {
                switch (index.column()) {
                    case 0: {
                        value = this->values->at(index.row()).getPassenger();
                        break;
                    }
                    case 1: {
                        value = "Рейс №" + QString::number(this->values->at(index.row()).getFlightId());
                        break;
                    }
                    case 2: {
                        value = this->values->at(index.row()).getPrice();
                        break;
                    }
                }
            }
            break;

            case Qt::UserRole: //data
            {
                value = this->values->at(index.row()).getId();
            }
            break;

            default:
                break;
        }

    return value;
}



void QTableViewModel::populate(QList<TicketInfo> *newValues)
{
    clear();
    int idx = values->count();
    this->beginInsertRows(QModelIndex(), 1, idx);
        values = newValues;
    endInsertRows();
}


QVariant QTableViewModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    if (role == Qt::DisplayRole && orientation == Qt::Horizontal) {
        switch (section) {
        case 0:
            return QString("Пассажир");
        case 1:
            return QString("Номер рейса");
        case 2:
            return QString("Цена");
        }
    }
    return QVariant();
}

void QTableViewModel::append(TicketInfo value)
{
    int newRow = this->values->count()+1;

    this->beginInsertRows(QModelIndex(), newRow, newRow);
        values->append(value);
    endInsertRows();
}

void QTableViewModel::deleteRow(int idx)
{
    this->beginRemoveRows(QModelIndex(), idx,idx);

        (*this->values).removeAt(idx);

    this->endRemoveRows();
}

void QTableViewModel::clear(){
   this->beginResetModel();
   values->clear();
   this->endResetModel();
}
