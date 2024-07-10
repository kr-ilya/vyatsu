#ifndef QCOMBOBOXMODEL_H
#define QCOMBOBOXMODEL_H

#include <QModelIndex>

class QComboBoxModel : public QAbstractListModel
{
public:
    QComboBoxModel(QObject *parent=nullptr);
    int rowCount(const QModelIndex &) const;
    QVariant data(const QModelIndex &index, int role) const;
    void populate(QList<QPair<int, QString> > *newValues);
    void append(int index, QString value);
    void update(int idx, QString value);
    void deleteRow(int idx);
    void insertAt(int idx, int data_idx, QString value);
    int getRowCount();
private:
    QList<QPair<int,QString>> *values;
};

#endif // QCOMBOBOXMODEL_H
