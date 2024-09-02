import java.util.Arrays;
import java.io.IOException;
import java.io.BufferedReader;
import java.io.FileReader;
import java.util.stream.IntStream;

// Driver Class
public class MatrixMultiplication {

    public static void main(String[] args) {
        try {
            BufferedReader reader = new BufferedReader(new java.io.InputStreamReader(System.in));
            
            System.out.print("Masukkan panjang baris atau kolom (32/64/128/256/512/1024/2048):" );
            String filename = reader.readLine().trim();

            float[][][] matrices = readMatrix(filename);
            float[][] matrix1 = matrices[0];
            float[][] matrix2 = matrices[1];

            // Sequential execution
            long startSeq = System.nanoTime();
            float[][] resultSequential = multiply(matrix1, matrix2);
            long timeSeq = System.nanoTime() - startSeq;
            System.out.println("Lama waktu eksekusi sekuensial: " + timeSeq / 1e6 + " ms");

            // Parallel execution
            long startPar = System.nanoTime();
            float[][] resultParallel = multiply_parallel(matrix1, matrix2);
            long timePar = System.nanoTime() - startPar;
            System.out.println("Lama waktu eksekusi paralel: " + timePar / 1e6 + " ms");

            // Compare the results
            if (areMatricesEqual(resultSequential, resultParallel)) {
                System.out.println("Hasil perkalian matriks sama");
            } else {
                System.out.println("Hasil perkalian matriks berbeda, ada yang salah dengan kodenya");
            }

            // Compare the execution time
            System.out.println("Perbandingan waktu eksekusi: " + (double) timeSeq / timePar);
            
        } catch (IOException e) {
            System.out.println("Terjadi kesalahan: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public static float[][] multiply(float[][] matrix1, float[][] matrix2) {
        int numRow1 = matrix1.length;
        int numCol1 = matrix1[0].length;
        int numCol2 = matrix2[0].length;

        float[][] result = new float[numRow1][numCol2];

        for (int i = 0; i < numRow1; i++) {
            for (int j = 0; j < numCol2; j++) {
                for (int k = 0; k < numCol1; k++) {
                    result[i][j] += matrix1[i][k] * matrix2[k][j];
                }
            }
        }

        return result;
    }

    public static float[][] multiply_parallel(float[][] matrix1, float[][] matrix2) {
        int numRow1 = matrix1.length;
        int numCol2 = matrix2[0].length;

        float[][] result = new float[numRow1][numCol2];

        // Parallel processing each row
        IntStream.range(0, numRow1).parallel().forEach(i -> {
            result[i] = multiplyRow(matrix1, matrix2, i);
        });

        return result;
    }

    private static float[] multiplyRow(float[][] matrix1, float[][] matrix2, int row) {
        int numCol1 = matrix1[0].length;
        int numCol2 = matrix2[0].length;
        float[] resultRow = new float[numCol2];

        for (int j = 0; j < numCol2; j++) {
            for (int k = 0; k < numCol1; k++) {
                resultRow[j] += matrix1[row][k] * matrix2[k][j];
            }
        }

        return resultRow;
    }

    public static float[][][] readMatrix(String filename) throws IOException {
        String filePath = "c:\\coding\\Seleksi Sister\\Seleksi_Bagian_B_Sister\\Soal 5 Wolfman Sigma\\tcmatmul\\" + filename + ".txt";
        BufferedReader reader = new BufferedReader(new FileReader(filePath));

        int n = Integer.parseInt(reader.readLine().trim());
        float[][] matrix1 = new float[n][n];
        float[][] matrix2 = new float[n][n];

        // Read the first matrix
        for (int i = 0; i < n; i++) {
            String[] line = reader.readLine().trim().split("\\s+");
            for (int j = 0; j < n; j++) {
                matrix1[i][j] = Float.parseFloat(line[j]);
            }
        }

        reader.readLine(); // Skip the empty line between matrices

        // Read the second matrix
        for (int i = 0; i < n; i++) {
            String[] line = reader.readLine().trim().split("\\s+");
            for (int j = 0; j < n; j++) {
                matrix2[i][j] = Float.parseFloat(line[j]);
            }
        }

        reader.close();
        return new float[][][] {matrix1, matrix2};
    }

    public static boolean areMatricesEqual(float[][] matrix1, float[][] matrix2) {
        return Arrays.deepEquals(matrix1, matrix2);
    }
}
