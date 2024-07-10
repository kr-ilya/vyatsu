from tkinter import *
from tkinter import ttk

from view.table import Table
from view.controls import Controls

from controller.controller import Controller
from model.model import Model


class App(Tk):
    def __init__(self):
        super().__init__()

        self.title('Database lab')
        self.geometry('420x500')
        self.resizable(False, False)

        table = Table(self)
        controls = Controls(self)

        views = {
            'table': table,
            'controls': controls
            }

        model = Model()
        self.controller = Controller(model, views)

        table.set_controller(self.controller)
        controls.set_controller(self.controller)

        table.create_table()
        controls.create_controls()

        self.controller.fill_table()

        self.protocol("WM_DELETE_WINDOW", self.on_closing)

    def on_closing(self):
        self.controller.on_closing()
        self.destroy()


if __name__ == '__main__':
    app = App()
    app.mainloop()

