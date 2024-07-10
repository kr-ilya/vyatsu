from decimal import Decimal

class Controller:
    def __init__(self, model, views):
        self.model = model
        self.views = views      

    def fill_table(self):
        data = self.model.get_data()
        self.views['table'].insert_data(data)

        passenger_ids = self.model.get_passenger_ids()
        self.views['controls'].insert_passengers(passenger_ids)

        flight_ids = self.model.get_flight_ids()
        self.views['controls'].insert_flights(flight_ids)

    def add_row(self, passenger_id, flight_id, price):
        price = Decimal(price).quantize(Decimal("1.00"))

        new_id = self.model.insert_row(passenger_id, flight_id, price)
        self.views['table'].insert_row((new_id, passenger_id, flight_id, price))

    def delete_row(self):
        selected = self.views['table'].get_selected_rows()
        self.model.delete_rows_by_id(selected[0])
        self.views['table'].delete_rows(selected[1])

    def filter_data(self, value):
        price = Decimal(value).quantize(Decimal("1.00"))
        data = self.model.filter_data(price)
        self.views['table'].insert_data(data)

    def on_closing(self):
        self.model.close_db()