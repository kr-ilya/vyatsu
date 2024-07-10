#ifndef TICKETINFO_H
#define TICKETINFO_H

#include <QString>

class TicketInfo
{
public:
    TicketInfo();
    TicketInfo(int id, int flightId, int price, QString passenger);

    int getId() const;
    QString getPassenger() const;
    int getFlightId() const;
    int getPrice() const;

private:
    int id;
    QString passenger;
    int flightId;
    int price;
};

#endif // TICKETINFO_H
