import prime

def inputInt():
    try: 
        n = int(input())

        if n < 0:
            return None

        return n
    except ValueError:
        return None

if __name__ == '__main__':
    while True:
        print()
        print("Выберте действие:")
        print("1. Генерация случайного просто числа")
        print("2. Проверка числа на простоту")
        print("3. Факторизация числа")
        print("4. Выход")


        x = inputInt()
    
        if (x == None) or (4 < x < 1):
            continue

        
        if x == 1:
            print(prime.getRandomPrime())
        elif x == 2:
            while True:
                print("Введите неотрицательное целое число")
                t = inputInt()

                if t == None:
                    continue
                
                if t == 1 or t == 0:
                    print("Число не является ни простым ни составным")
                else:
                    print("Число простое" if prime.isPrime(t) else "Число составное")

                break

        elif x == 3:
            while True:
                print("Введите неотрицательное целое число")
                t = inputInt()

                if t == None:
                    continue

                if t == 1 or t == 0:
                    print("Число не является ни простым ни составным")
                else:
                    r = prime.factorize(t)
                    print(f"Простые множители: {*r,}" if len(r) > 0 else "Это простое число")

                break

        elif x == 4:
            break