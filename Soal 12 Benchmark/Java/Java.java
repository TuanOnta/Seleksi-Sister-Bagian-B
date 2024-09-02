import java.io.*;
import java.util.*;

public class Java {
    public static void main(String[] args) throws IOException {
        Scanner scanner = new Scanner(new File("input.txt"));
        int n = scanner.nextInt();
        double[][] matrix = new double[n][n];
        double[][] identity = new double[n][n];

        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                matrix[i][j] = scanner.nextDouble();
                identity[i][j] = (i == j) ? 1 : 0;
            }
        }
        scanner.close();

        for (int i = 0; i < n; i++) {
            if (matrix[i][i] == 0) {
                for (int j = i + 1; j < n; j++) {
                    if (matrix[j][i] != 0) {
                        double[] temp = matrix[i];
                        matrix[i] = matrix[j];
                        matrix[j] = temp;

                        temp = identity[i];
                        identity[i] = identity[j];
                        identity[j] = temp;
                        break;
                    }
                }
            }

            double pivot = matrix[i][i];
            for (int j = 0; j < n; j++) {
                matrix[i][j] /= pivot;
                identity[i][j] /= pivot;
            }

            for (int k = 0; k < n; k++) {
                if (k != i) {
                    double factor = matrix[k][i];
                    for (int j = 0; j < n; j++) {
                        matrix[k][j] -= factor * matrix[i][j];
                        identity[k][j] -= factor * identity[i][j];
                    }
                }
            }
        }

        PrintWriter writer = new PrintWriter(new File("output.txt"));
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                writer.printf("%.6f ", identity[i][j]);
            }
            writer.println();
        }
        writer.close();
    }
}
