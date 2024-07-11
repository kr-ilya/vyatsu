from xmlrpc.server import SimpleXMLRPCServer
import prime
import sys

def main():

    server = SimpleXMLRPCServer(("localhost", 8000))
    print("Listening on port 8000...")

    server.register_function(prime.isPrime, "isPrime")
    server.register_function(prime.factorize, "factorize")
    server.register_function(prime.getNext, "getNext")
    server.register_function(prime.getRandomPrime, "getRandomPrime")

    server.serve_forever()

if __name__ == "__main__":
    main()