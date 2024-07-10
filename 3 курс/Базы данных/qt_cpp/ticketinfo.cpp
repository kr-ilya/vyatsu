#include "ticketinfo.h"


TicketInfo::TicketInfo()
{

}


TicketInfo::TicketInfo(int id, int flightId, int price, QString passenger)
{
    this->id = id;
    this->passenger = passenger;
    this->flightId = flightId;
    this->price = price;
}

int TicketInfo::getId() const
{
    return id;
}

QString TicketInfo::getPassenger() const
{
    return passenger;
}
int TicketInfo::getFlightId() const
{
    return flightId;
}

int TicketInfo::getPrice() const
{
    return price;
}
