package rpslab1;
import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;
import java.util.InputMismatchException;
import java.util.ArrayList;
import java.util.Locale;

public class Decomposition {

    private ArrayList<Number> data;
    private int n;
    private final int MAX_DATA_SIZE = 1000;
    private final long MAX_VALUE = 10_000_000_000L;
    private ArrayList<Number> blocks;
    private int rt;

    public Decomposition(String filename) throws FileNotFoundException, DecompositionException, InputMismatchException {
        readData(filename);

        calcBlocks();
    }
    
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


    public void updateValues(int a, int b, Number x) throws DecompositionException {
        if (a < 0 || a > b || a >= n || b < 0 || b >= n) {
            throw new DecompositionException("Интервал некорректный");
        }

        for(int i = a; i <= b; ++i) {
            updateValue(i, x);
        }
    }

    public int getLen() {
        return n;
    }

    public long getMaxValue() {
        return MAX_VALUE;
    }
}