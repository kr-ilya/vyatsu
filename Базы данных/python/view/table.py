from tkinter import *
from tkinter import ttk
from view.view import View

class Table(View):
    def __init__(self, parent):
        super().__init__(parent)
        self.table = None      

    def create_table(self):
        columns = ('id', 'passenger_id', 'flight_id', 'price')

        self.table = ttk.Treeview(columns=columns, show="headings", height=10)
        self.table.grid(row=0, column=0, sticky="nsew", pady=10, padx=10)

        self.table.heading("id", text="id", anchor='w')
        self.table.heading("passenger_id", text="id пассажира", anchor='w')
        self.table.heading("flight_id", text="id рейса", anchor='w')
        self.table.heading("price", text="Цена", anchor='w')

        self.table.column("#1", stretch=NO, width=50)
        self.table.column("#2", stretch=NO, width=100)
        self.table.column("#3", stretch=NO, width=100)
        self.table.column("#4", stretch=NO, width=100)

        scrollbar = ttk.Scrollbar(orient=VERTICAL, command=self.table.yview)
        self.table.configure(yscroll=scrollbar.set)
        scrollbar.grid(row=0, column=1, sticky="ns")

        self.grid(row=0, column=0, padx=10, pady=10)

    def set_controller(self, c):
        self.controller = c

    def insert_data(self, data):
        self.clear()

        if not data:
            return 
            
        for row in data:
            self.insert_row(row)

    def insert_row(self, values):
        self.table.insert("", END, values=values)

    def get_selected_rows(self):
        selected = self.table.selection()
        row_ids = list(map(lambda x: self.table.item(x)['values'][0], selected))
        return (row_ids, selected)
    
    def delete_rows(self, rows):
        self.table.delete(*rows)

    def clear(self):
        self.table.delete(*self.table.get_children())