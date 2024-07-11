import java.io.*;
import java.util.*;

public class solver {
	
	public static void main(String[] args) {
		Scanner in = new Scanner(System.in);
		PrintWriter out = new PrintWriter(System.out);
		int n = in.nextInt();
		int[] a = new int[n];
		for(int i = 0; i < n; i++)
			a[i] = in.nextInt();

		Arrays.sort(a);

		for(int i = 0; i < n / 2; i++) {
			int tmp = a[i];
			a[i] = a[n -i - 1];
			a[n - i - 1] = tmp;
		}

		for(int i = 0; i < n; i++)
			out.print(a[i] + " ");
		out.flush();	
	}
}