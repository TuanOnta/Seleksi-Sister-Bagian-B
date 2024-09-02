#include <stdio.h>
#include <stdlib.h>

void read_matrix(const char *file_name, double ***matrix, int *n) {
    FILE *file = fopen(file_name, "r");
    if (!file) {
        perror("Error opening file");
        exit(EXIT_FAILURE);
    }

    fscanf(file, "%d", n);

    *matrix = (double **)malloc(*n * sizeof(double *));
    for (int i = 0; i < *n; i++) {
        (*matrix)[i] = (double *)malloc(*n * sizeof(double));
        for (int j = 0; j < *n; j++) {
            fscanf(file, "%lf", &(*matrix)[i][j]);
        }
    }
    fclose(file);
}

void write_matrix(const char *file_name, double **matrix, int n) {
    FILE *file = fopen(file_name, "w");
    if (!file) {
        perror("Error opening file");
        exit(EXIT_FAILURE);
    }

    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            fprintf(file, "%.6lf ", matrix[i][j]);
        }
        fprintf(file, "\n");
    }
    fclose(file);
}

void gauss_jordan(double **matrix, double **identity, int n) {
    // Membuat matriks identitas
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            identity[i][j] = (i == j) ? 1.0 : 0.0;
        }
    }

    for (int i = 0; i < n; i++) {
        // Pivoting
        if (matrix[i][i] == 0.0) {
            for (int j = i + 1; j < n; j++) {
                if (matrix[j][i] != 0.0) {
                    double *temp = matrix[i];
                    matrix[i] = matrix[j];
                    matrix[j] = temp;

                    temp = identity[i];
                    identity[i] = identity[j];
                    identity[j] = temp;
                    break;
                }
            }
        }

        // Normalisasi baris pivot
        double pivot = matrix[i][i];
        for (int j = 0; j < n; j++) {
            matrix[i][j] /= pivot;
            identity[i][j] /= pivot;
        }

        // Eliminasi kolom lainnya
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
}

void invert_matrix(const char *input_file, const char *output_file) {
    double **matrix, **identity;
    int n;

    read_matrix(input_file, &matrix, &n);

    // Alokasi memori untuk matriks identitas
    identity = (double **)malloc(n * sizeof(double *));
    for (int i = 0; i < n; i++) {
        identity[i] = (double *)malloc(n * sizeof(double));
    }

    gauss_jordan(matrix, identity, n);

    write_matrix(output_file, identity, n);

    // Membebaskan memori yang dialokasikan
    for (int i = 0; i < n; i++) {
        free(matrix[i]);
        free(identity[i]);
    }
    free(matrix);
    free(identity);
}

int main() {
    invert_matrix("input.txt", "output.txt");
    return 0;
}
