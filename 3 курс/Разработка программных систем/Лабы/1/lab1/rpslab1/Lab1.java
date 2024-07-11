package rpslab1;

import java.util.Scanner;
import java.util.Locale;
import java.io.FileNotFoundException;
import java.util.InputMismatchException;

public class Lab1{
    private static Decomposition dn;
    private static Scanner reader;

    public static void main(String args[]) {

        try {
            dn = new Decomposition("input.txt");
        } catch (DecompositionException e) {
            System.out.println(e.getMessage());
            return;
        } catch (FileNotFoundException e) {
            System.out.println("input.txt не найден");
            return;
        } catch (InputMismatchException e) {
            System.out.println("input.txt имеет неверный формат");
            return;
        }

        reader = new Scanner(System.in).useLocale(Locale.US);

        while(true) {
            System.out.println("Выберите действие\n" +
                                "1. Изменить значение в точке\n" +
                                "2. Изменить значения на интервале\n" +
                                "3. Сумма значений на интервале\n" +
                                "4. Выход");

            int c;

            if (reader.hasNextInt()) {
                c = reader.nextInt();
            } else {
                System.out.println("Неизвестная команда");
                reader.next();
                System.out.println();
				continue;
            }

            if (c == 1) {
                updValue();
            } else if (c == 2) {
                updValues();
            } else if (c == 3) {
                System.out.println(getSum());
            } else if (c == 4) {
                break;
            } else {
                System.out.println("Неизвестная команда");
            }
            System.out.println();
        }

        reader.close();
    }


    private static void updValue() {
        int n = dn.getLen();
        long maxValue = dn.getMaxValue();
        int a;
        Number x;

        System.out.printf("Введите точку [0-%s]\n", n-1);
        a = inputInt(0, n-1);

        System.out.println("Введите новое значение");
        x = inputElement(maxValue);

        try {
            dn.updateValue(a, x);
            System.out.println("Значение обновлено");
        } catch (DecompositionException e) {
            System.out.println(e.getMessage());
        }
    }
    

    private static void updValues() {
        int n = dn.getLen();
        long maxValue = dn.getMaxValue();
        int a, b;
        Number x;

        System.out.printf("Введите начальную точку [0-%s]\n", n-1);
        a = inputInt(0, n-1);
        
        System.out.printf("Введите конечную точку [%s-%s]\n", a, n-1);
        b = inputInt(a, n-1);
        
        System.out.println("Введите новое значение");
        x = inputElement(maxValue);

        try {
            dn.updateValues(a, b, x);
            System.out.println("Значения обновлены");
        } catch (DecompositionException e) {
            System.out.println(e.getMessage());
        }

    }


    private static double getSum() {
        int n = dn.getLen();
        int a, b;
        double s = 0.0;

        System.out.printf("Введите начальную точку [0-%s]\n", n-1);
        a = inputInt(0, n-1);
        
        System.out.printf("Введите конечную точку [%s-%s]\n", a, n-1);
        b = inputInt(a, n-1);

        try {
            s = dn.getSum(a, b);
        } catch (DecompositionException e) {
            System.out.println(e.getMessage());
        }
        return s;
    }


    private static int inputInt(int minVal, int maxVal) {
        int a;
        while (true) {
            if (reader.hasNextInt()) {
                a = reader.nextInt();
            } else {
                System.out.println("Введите целое положительное число");
                reader.next();
                continue;
            }

            if (a < minVal || a > maxVal) {
                System.out.printf("Введите значение из интервала [%s-%s]\n", minVal, maxVal);
                continue;
            }

            return a;
        }        
    }

    private static Number inputElement(long maxValue) {
        Number x;
        while (true) {
            if (reader.hasNextLong() || reader.hasNextDouble()) {
                if (reader.hasNextLong()) { 
                    long t = reader.nextLong();

                    if (t > maxValue) {
                        System.out.printf("Максимальное значение элемента - %s\n", maxValue);
                        continue;
                    }

                    if (t < -maxValue) {
                        System.out.printf("Минимальное значение элемента - %s\n", -maxValue);
                        continue;
                    }

                    x = t;
                } else {
                    double t = reader.nextDouble();

                    if (t > maxValue) {
                        System.out.printf("Максимальное значение элемента - %s\n", maxValue);
                        continue;
                    }

                    if (t < -maxValue) {
                        System.out.printf("Минимальное значение элемента - %s\n", -maxValue);
                        continue;
                    }
                    
                    x = t;
                }
            } else {
                System.out.println("Введите числовое значение");
                reader.next();
                continue;
            }

            return x;
        }
    }
}