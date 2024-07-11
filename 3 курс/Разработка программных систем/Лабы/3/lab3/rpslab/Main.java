package rpslab;

import java.io.FileNotFoundException;
import java.util.InputMismatchException;

public class Main{
    private static Decomposition dn;

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


        GUI app = new GUI(dn);
        app.setVisible(true);
    }

}