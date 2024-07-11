import xmlrpc.client
import socket

class Prime:
    def __init__(self):
        self.proxy = None

    def connect(self):
        connected, self.proxy = self._get_rpc()
        return connected

    def _get_rpc(self):
        a = xmlrpc.client.ServerProxy("http://localhost:8000/")
        try:
            a._()   # Call a fictive method.
        except xmlrpc.client.Fault:
            # connected to the server and the method doesn't exist which is expected.
            pass
        except ConnectionRefusedError:
            return False, None
        else:
            return False, None
        return True, a


    isPrime = lambda self, x: self.proxy.isPrime(str(x))
    factorize = lambda self, n: self.proxy.factorize(str(n))
    getNext = lambda self, i: self.proxy.getNext(str(i))
    getRandomPrime = lambda self: self.proxy.getRandomPrime()