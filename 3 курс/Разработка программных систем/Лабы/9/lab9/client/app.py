from tkinter import *
from tkinter import ttk

from view.controls import Controls

from controller.controller import Controller
from model.prime import Prime


class App(Tk):
    def __init__(self):
        super().__init__()

        prime = Prime()
        connected = prime.connect()

        if not connected:
            print("Server is not connected")
            self.destroy()
            return
            
        self.title('Lab')
        self.geometry('250x200')
        self.resizable(False, False)
        self.protocol("WM_DELETE_WINDOW", self.on_closing)

        controls = Controls(self)
    
        views = {
            'controls': controls
            }

        self.controller = Controller(prime, views)

        controls.set_controller(self.controller)

        controls.create_controls()

        self.grid_columnconfigure(0, weight=1)


    def on_closing(self):
        self.destroy()


if __name__ == '__main__':
    app = App()
    app.mainloop()

