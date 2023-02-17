from tkinter import *
from tkinter import ttk
from view.view import View

class Controls(View):
    def __init__(self, parent):
        super().__init__(parent)

        self.controller = None

        self.passenger_id_box = None
        self.flight_id_box = None
        self.price_box = None

    def set_controller(self, c):
        self.controller = c

    def create_controls(self):
        l_passenger_id = Label(self, text="id пассажира")
        l_passenger_id.grid(row=0, column=0, sticky="ew")

        l_flight_id = Label(self, text="id рейса")
        l_flight_id.grid(row=0, column=1, sticky="ew")

        l_price = Label(self, text="Цена")
        l_price.grid(row=0, column=2, sticky="ew")

        self.passenger_id_box = ttk.Combobox(self, values=[], width=13)
        self.passenger_id_box.grid(row=1, column=0, padx=10)
        
        self.flight_id_box = ttk.Combobox(self, values=[], width=13)
        self.flight_id_box.grid(row=1, column=1, padx=10)

        self.price_box = Entry(self)
        self.price_box.grid(row=1, column=2, padx=10)

        add_row_btn = ttk.Button(self, text='Добавить запись', command=self.add_row)
        add_row_btn.grid(row=2, column=1, pady=5)

        delete_row_btn = ttk.Button(self, text='Удалить выделенные', command=self.delete_row)
        delete_row_btn.grid(row=3, column=1, pady=5)

        l_price_from = Label(self, text="Цена от")
        l_price_from.grid(row=4, column=0, sticky="e")

        self.price_from_box = Entry(self)
        self.price_from_box.grid(row=4, column=1, padx=10, pady=5)

        add_row_btn = ttk.Button(self, text='Отфильтровать', command=self.filter_init)
        add_row_btn.grid(row=4, column=2, pady=5, sticky="w")

        self.grid(row=1, column=0, sticky="w", pady=20, padx=10)

    def add_row(self):
        if self.controller:
            if self.passenger_id_box.get() and self.flight_id_box.get() and self.price_box.get():
                self.controller.add_row(self.passenger_id_box.get(), self.flight_id_box.get(), self.price_box.get())

    def delete_row(self):
        if self.controller:
            self.controller.delete_row()

    def insert_passengers(self, values):
        self.passenger_id_box['values'] = (*self.passenger_id_box['values'], *values)
    
    def insert_flights(self, values):
        self.flight_id_box['values'] = (*self.flight_id_box['values'], *values)

    def filter_init(self):
        if self.controller:
            if self.price_from_box.get():
                self.controller.filter_data(self.price_from_box.get())
