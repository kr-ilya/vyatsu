from tkinter import *
from tkinter import ttk

from view.controls import Controls

from controller.controller import Controller
import model.prime as prime


class App(Tk):
    def __init__(self):
        super().__init__()

        self.title('Lab')
        self.geometry('250x185')
        self.resizable(False, False)

        controls = Controls(self)
    
        views = {
            'controls': controls
            }

        self.controller = Controller(prime, views)

        controls.set_controller(self.controller)

        controls.create_controls()

        self.grid_columnconfigure(0, weight=1)

        self.protocol("WM_DELETE_WINDOW", self.on_closing)

    def on_closing(self):
        self.destroy()


if __name__ == '__main__':
    app = App()
    app.mainloop()

