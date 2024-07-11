package rpslab1;
import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;
import java.util.InputMismatchException;
import java.util.ArrayList;
import java.util.Locale;

/**
 * Execution of interval operations by means of sqrt decomposition
 * 
 * @author Ilya Kryuchkov
*/
public class Decomposition {

    /** Array of elements */
    private ArrayList<Number> data;

    /** Number of elements */
    private int n;

    /** Maximum number of elements */
    private final int MAX_DATA_SIZE = 1000;

    /** Maximum value of the element */
    private final long MAX_VALUE = 10_000_000_000L;

    /** Array of blocks */
    private ArrayList<Number> blocks;

    /** Root Value */
    private int rt;

    /**
    * Constructs new sqrt decomposition class
    * @param filename Name input file
    * @throws DecompositionException Decomposition error
    * @throws FileNotFoundException File not found
    * @throws InputMismatchException File has an incorrect format
    */
    public Decomposition(String filename) throws FileNotFoundException, DecompositionException, InputMismatchException {
        readData(filename);

        calcBlocks();
    }
    
    /**
    * Reading data from a file
    * @param filename Name input file
    * @throws DecompositionException Decomposition error
    * @throws FileNotFoundException File not found
    * @throws InputMismatchException File has an incorrect format
    */
    private void readData(String filename) throws FileNotFoundException, DecompositionException, InputMismatchException {
        Scanner in = new Scanner(new File(filename)).useLocale(Locale.US);

        n = in.nextInt();
        
        if (n > MAX_DATA_SIZE) {
            throw new DecompositionException(String.format("Максимальное количество элементов - %s", MAX_DATA_SIZE));
        }

        data = new ArrayList<Number>(n);

        int i  = 0;
        while ( (in.hasNextLong() || in.hasNextDouble()) && i < n) {
            if (in.hasNextLong()) {
                long t = in.nextLong();

                if (t > MAX_VALUE) {
                    throw new DecompositionException(String.format("Максимальное значение элемента - %s", MAX_VALUE));
                }

                if (t < -MAX_VALUE) {
                    throw new DecompositionException(String.format("Минимальное значение элемента - %s", -MAX_VALUE));
                }

                data.add(t);
            } else {
                double t = in.nextDouble();

                if (t > MAX_VALUE) {
                    throw new DecompositionException(String.format("Максимальное значение элемента - %s", MAX_VALUE));
                }

                if (t < -MAX_VALUE) {
                    throw new DecompositionException(String.format("Минимальное значение элемента - %s", -MAX_VALUE));
                }

                data.add(t);
            }

            i++;
        }

        if (i == 0) {
            throw new InputMismatchException();
        }

        data.trimToSize();
        n = data.size();
    }

    /**
    * Splitting into intervals and calculating the sum on each interval
    */
    private void calcBlocks() {
        rt = (int) Math.ceil(Math.sqrt(n));
        blocks = new ArrayList<Number>(rt);

        for (int i = 0; i < rt - 1; ++i) {
            blocks.add(0);

            final int idx = i * rt;
            int j = 0;
            while (j < rt && idx + j < n){
                Number v = blocks.get(i);
                v = v.doubleValue() + data.get(idx + j).doubleValue();
                
                blocks.set(i, v);
                ++j;
            }
        }
    }

    /**
    * Calculating the sum at a given interval
    * @param a Starting point of the interval
    * @param b The end point of the interval
    * @return The sum of the values in the interval from a to b
    * @throws DecompositionException Decomposition error
    */
    public double getSum(int a, int b) throws DecompositionException {
        if (a < 0 || a > b || a >= n || b < 0 || b >= n) {
            throw new DecompositionException("Интервал некорректный");
        }

        double sum = 0;
        final int startBlock = a/rt;
        final int endBlock = b/rt;

        if (startBlock == endBlock) {
            for (int i = a; i <= b; ++i) {
                sum += data.get(i).doubleValue();
            }
        } else {
            for (int i = startBlock+1; i < endBlock; ++i) {
                sum += blocks.get(i).doubleValue();
            }
    
            final int aIdx = a % rt;
            for (int i = aIdx; i < rt; ++i) {
                sum += data.get(startBlock*rt + i).doubleValue();
            }
            
            final int bIdx = b % rt;
            for (int i = 0; i <= bIdx; ++i) {
                sum += data.get(endBlock * rt + i).doubleValue();
            }
        }

        return sum;
    }

    /**
    * Changing the value at a given point
    * @param id Index of the item to change
    * @param x New value
    * @throws DecompositionException Decomposition error
    */
    public void updateValue(int id, Number x) throws DecompositionException {
        if (id < 0 || id >= n) {
            throw new DecompositionException("Индекс некорректный");
        }

        int bid = id / rt;

        double v = data.get(id).doubleValue();
        double bv = blocks.get(bid).doubleValue();

        data.set(id, x);
        blocks.set(bid, x.doubleValue() - v + bv);
    }

    /**
    * Changing values at a given interval
    * @param a Starting point of the interval
    * @param b The end point of the interval
    * @param x New value
    * @throws DecompositionException Decomposition error
    */
    public void updateValues(int a, int b, Number x) throws DecompositionException {
        if (a < 0 || a > b || a >= n || b < 0 || b >= n) {
            throw new DecompositionException("Интервал некорректный");
        }

        for(int i = a; i <= b; ++i) {
            updateValue(i, x);
        }
    }
    
    /**
    * Getting the number of elements
    * @return Number of elements
    */
    public int getLen() {
        return n;
    }

    /**
    * Getting the maximum value of an element
    * @return Maximum value of the element
    */
    public long getMaxValue() {
        return MAX_VALUE;
    }
}