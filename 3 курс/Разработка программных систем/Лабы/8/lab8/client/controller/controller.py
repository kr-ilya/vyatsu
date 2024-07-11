from decimal import Decimal

class Controller:
    def __init__(self, model, views):
        self.prime = model
        self.views = views      

    def _checkInput(self, value):
        try:
            v = int(value)

            if v < 0:
                return None

            return v
        except ValueError:
            return None

    def check(self, value):
       
        v = self._checkInput(value)

        if v is None:
            self.views['controls'].showModal(1, "Введите неотрицательное целое число")
            return
        
        if v == 1 or v == 0:
            self.views['controls'].showModal(0, "Число не является ни простым ни составным")
        else:
            self.views['controls'].showModal(0, "Число простое" if self.prime.isPrime(v) else "Число составное")

    def factorize(self, value):
        v = self._checkInput(value)

        if v is None:
            self.views['controls'].showModal(1, "Введите неотрицательное целое число")
            return
        
        if v == 1 or v == 0:
            self.views['controls'].showModal(0, "Число не является ни простым ни составным")
        else:
            q = self.prime.factorize(v)
            r = list(int(x) for x in q.split())
            self.views['controls'].showModal(0, f"Простые множители: {*r,}" if len(r) > 0 else "Это простое число")

    def getRandomPrime(self):
        self.views['controls'].setInputValue(self.prime.getRandomPrime())

    def next_prime(self, value):
        v = self._checkInput(value)

        if v is None:
            self.views['controls'].showModal(1, "Введите неотрицательное целое число")
            return

        self.views['controls'].setInputValue(self.prime.getNext(v))