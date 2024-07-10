import psycopg2
from psycopg2 import Error

class Database():
    def __init__(self):
        self.connection = None

    def open_connection(self, host, user, password, base, port):
        try:
            self.connection = psycopg2.connect(user=user,
                                                password=password,
                                                host=host,
                                                port=port,
                                                database=base)

        except (Exception, Error) as error:
            print("Error while connecting to PostgreSQL", error)
    
    def close_connection(self):
        if self.connection:
            self.connection.close()


    def get_tickets(self):        
        return self.fetchAll("SELECT * FROM ticket;")

    def insert_row(self, passenger_id, flight_id, price):
        return self.fetchOne("INSERT INTO ticket (passenger_id, flight_id, price) VALUES (%s, %s, %s) RETURNING id", (passenger_id, flight_id, price))

    def delete_rows(self, row_ids):
        self.query_exec("SELECT delete_tickets(%s)", (row_ids,))

    def get_flight_ids(self):
        return self.fetchAll("SELECT id FROM flight;")
    
    def get_passenger_ids(self):       
        return self.fetchAll("SELECT id FROM passenger;")

    
    def get_filtered_data(self, value):
        return self.fetchAll("SELECT * FROM ticket WHERE price >= %s;", (value, ))


    def fetchAll(self, query, values=None):
        try:
            with self.connection:
                with self.connection.cursor() as cursor:
                    cursor.execute(query, values)
                    return cursor.fetchall()

        except (Exception, Error) as error:
            print(f"Error database.fetchAll [{query}]", error)

    def query_exec(self, query, values):
        try:
            with self.connection:
                with self.connection.cursor() as cursor:
                    cursor.execute(query, values)

        except (Exception, Error) as error:
            print(f"Error database.query_exec [{query}]", error)

    def fetchOne(self, query, values=None):
        try:
            with self.connection:
                with self.connection.cursor() as cursor:
                    cursor.execute(query, values)
                    return cursor.fetchone()[0]  

        except (Exception, Error) as error:
            print(f"Error database.fetchOne [{query}]", error)