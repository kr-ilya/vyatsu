#include "flightscbmodel.h"
#include <QModelIndex>

FlightsCBModel::FlightsCBModel(QObject *parent)
    :QAbstractListModel(parent)
{
    values = new QList<QPair<int,QString>>();
}

int FlightsCBModel::rowCount(const QModelIndex &) const
{
    return values->count();
}

QVariant FlightsCBModel::data( const QModelIndex &index, int role ) const
{

    QVariant value;

        switch ( role )
        {
            case Qt::DisplayRole: //string
            {
                value = this->values->value(index.row()).second;
            }
            break;

            case Qt::UserRole: //data
            {
            value = this->values->value(index.row()).first;
            }
            break;

            default:
                break;
        }

    return value;
}

void FlightsCBModel::populate(QList<QPair<int,QString>> *newValues)
{
    int idx = this->values->count();
    this->beginInsertRows(QModelIndex(), 1, idx);
        this->values = newValues;
    endInsertRows();
 }

void FlightsCBModel::append(int index, QString value)
{
    int newRow = this->values->count()+1;

    this->beginInsertRows(QModelIndex(), newRow, newRow);
        values->append(QPair<int,QString>(index,value));
    endInsertRows();
}

void FlightsCBModel::update(int idx, QString value)
{
    (*this->values)[idx].second = value;

    QModelIndex item_idx = this->index(idx,0);

    emit this->dataChanged(item_idx ,item_idx );
}

void FlightsCBModel::deleteRow(int idx)
{
    int rowIdx = this->values->count()+1;

    this->beginRemoveRows(QModelIndex(), idx,idx);

        (*this->values).removeAt(idx);

    this->endRemoveRows();
}

void FlightsCBModel::insertAt(int idx, int data_idx, QString value)
{

    int newRow = idx;

    this->beginInsertRows(QModelIndex(), newRow, newRow);

        values->insert(newRow,QPair<int,QString>(data_idx, value));

    endInsertRows();
}

int FlightsCBModel::getRowCount()
{
    return this->rowCount(QModelIndex());
}
