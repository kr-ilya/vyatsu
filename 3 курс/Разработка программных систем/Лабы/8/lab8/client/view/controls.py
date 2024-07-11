from tkinter import *
from tkinter import ttk
from view.view import View
import tkinter.messagebox as mb

class Controls(View):
    def __init__(self, parent):
        super().__init__(parent)

        self.controller = None

        self.number_input = None

        self.grid_columnconfigure(0, weight=1)

    def set_controller(self, c):
        self.controller = c

    def create_controls(self):
        
        l_input = Label(self, text="Число")
        l_input.grid(row=0, column=0, padx=10, sticky="w")

        self.number_input = Entry(self)
        self.number_input.grid(row=1, column=0, padx=10, pady=(0, 10), sticky="we")

        check_btn = ttk.Button(self, text='Проверить на простоту', command=self.check)
        check_btn.grid(row=2, column=0, padx=10, pady=2, sticky="we")
        
        
        factorize_btn = ttk.Button(self, text='Факторизация', command=self.factorize)
        factorize_btn.grid(row=3, column=0, padx=10, pady=2, sticky="we")
        
        rnd_btn = ttk.Button(self, text='Случайное простое число', command=self.rnd)
        rnd_btn.grid(row=4, column=0, padx=10, pady=2, sticky="we")
        
        next_prime_btn = ttk.Button(self, text='Следующее простое число', command=self.next_prime)
        next_prime_btn.grid(row=5, column=0, padx=10, pady=2, sticky="we")

        self.grid(row=0, column=0, pady=10, padx=10,  sticky="we")
        
    def check(self):
        if self.controller:
            if self.number_input.get():
                self.controller.check(self.number_input.get())

    def factorize(self):
        if self.controller:
            if self.number_input.get():
                self.controller.factorize(self.number_input.get())
    
    def rnd(self):
        if self.controller:
            self.controller.getRandomPrime()

    def next_prime(self):
        if self.controller:
            if self.number_input.get():
                self.controller.next_prime(self.number_input.get())

    def showModal(self, mtype, msg):
        if mtype == 0:
            mb.showinfo("Результат", msg)
        elif mtype == 1: 
            mb.showerror("Ошибка", msg)

    def setInputValue(self, v):
        self.number_input.delete(0, END)
        self.number_input.insert(0, v)
