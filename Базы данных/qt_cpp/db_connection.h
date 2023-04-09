#ifndef DB_CONNECTION_H
#define DB_CONNECTION_H

#include <QSqlDatabase>
#include <QSqlError>
#include <QSqlQuery>
#include <iostream>
#include "ticketinfo.h"
#include <QList>

static bool createConnection()
{
    QSqlDatabase db = QSqlDatabase::addDatabase("QPSQL");
    db.setDatabaseName("lab_airport");
    db.setHostName("127.0.0.1");
    db.setUserName("lab_air_user");
    db.setPassword("lab_air_user");

    if (!db.open()) {
        std::cout << "Open Error" << std::endl;
        return false;
    }

    return true;
}

static QList<TicketInfo>* getTickets()
{
    QList<TicketInfo> *values = new QList<TicketInfo>;

    QSqlQuery query("SELECT t.id, t.flight_id, t.price, p.surname, p.name FROM ticket t LEFT JOIN passenger p ON t.passenger_id = p.id");
    while (query.next())
    {
        values->append(TicketInfo(query.value(0).toInt(), query.value(1).toInt(), query.value(2).toInt(), query.value(3).toString() + " " + query.value(4).toString()));
    }

    return values;

}

static QList<QPair<int, QString>>* getPassengers()
{
    QList<QPair<int, QString>> *values = new QList<QPair<int, QString>>;
    QSqlQuery query("SELECT id, surname, name FROM passenger");
    while (query.next())
    {
        values->append(QPair<int, QString>(query.value(0).toInt(), query.value(1).toString() + " " + query.value(2).toString()));
    }
    return values;
}

static QList<QPair<int, QString>>* getFlights()
{
    QList<QPair<int, QString>> *values = new QList<QPair<int, QString>>;
    QSqlQuery query("SELECT id FROM flight");
    while (query.next())
    {
        values->append(QPair<int, QString>(query.value(0).toInt(), "Рейс №" + query.value(0).toString()));
    }
    return values;
}


static int insertRow(int passenger_id, int flight_id, int price)
{
   QSqlQuery query;
   query.prepare("INSERT INTO ticket (passenger_id, flight_id, price) VALUES (:passenger_id, :flight_id, :price)");
   query.bindValue(":passenger_id", passenger_id);
   query.bindValue(":flight_id", flight_id);
   query.bindValue(":price", price);
   query.exec();

   return query.lastInsertId().toInt();
}

static void deleteRows(QList<int> rows)
{
    QString sql = QString("SELECT delete_tickets(ARRAY[")+QString::number(rows[0]);

    for (int i = 1; i < rows.size(); ++i)
    {
        sql += ", " + QString::number(rows[i]);
    }
    sql += "])";

    QSqlQuery query(sql);
}

static QList<TicketInfo>* getFilteredTickets(int price)
{
    QList<TicketInfo> *values = new QList<TicketInfo>;

    QSqlQuery query;
    query.prepare("SELECT t.id, t.flight_id, t.price, p.surname, p.name FROM ticket t LEFT JOIN passenger p ON t.passenger_id = p.id WHERE t.price >= :price");
    query.bindValue(":price", price);
    query.exec();

    while (query.next())
    {
        values->append(TicketInfo(query.value(0).toInt(), query.value(1).toInt(), query.value(2).toInt(), query.value(3).toString() + " " + query.value(4).toString()));
    }

    return values;

}

#endif // DB_CONNECTION_H
