from core.database import Database
import core.config as config

class Model:
    def __init__(self):
        self.db = Database()
        self.db.open_connection(config.db_host, config.db_user, config.db_pass, config.db_base, config.db_port)


    def insert_row(self, passenger_id, flight_id, price):
        return self.db.insert_row(passenger_id, flight_id, price)

    def get_data(self):
        return self.db.get_tickets()

    def close_db(self):
        self.db.close_connection()

    def delete_rows_by_id(self, rows):
        if rows:
            self.db.delete_rows(rows)

    def get_flight_ids(self):
        return self.db.get_flight_ids()
    
    def get_passenger_ids(self):
        return self.db.get_passenger_ids()

    def filter_data(self, value):
        return self.db.get_filtered_data(value)