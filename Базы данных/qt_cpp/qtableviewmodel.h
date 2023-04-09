#ifndef QTABLEVIEWMODEL_H
#define QTABLEVIEWMODEL_H

#include <QAbstractListModel>
#include <QModelIndex>
#include "ticketinfo.h"

class QTableViewModel : public QAbstractListModel
{
public:
    QTableViewModel(QObject *parent = nullptr);

   int rowCount(const QModelIndex &) const;
   int columnCount(const QModelIndex &) const;
   QVariant data(const QModelIndex &index, int role) const;
   void populate(QList<TicketInfo> *newValues);
   QVariant headerData(int section, Qt::Orientation orientation, int role) const;
   void append(TicketInfo value);
   void deleteRow(int idx);
   void clear();


private:
   QList<TicketInfo> *values;

};

#endif // QTABLEVIEWMODEL_H
