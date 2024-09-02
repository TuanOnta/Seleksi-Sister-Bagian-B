#include <iostream>
#include <fstream>
#include <vector>

using namespace std;

void read_matrix(const char *file_name, vector<vector<double>> &matrix, int &n) {
    ifstream file(file_name);
    if (!file.is_open()) {
        cerr << "Error opening file" << endl;
        exit(EXIT_FAILURE);
    }

    file >> n;
    matrix.resize(n, vector<double>(n));
    for (int i = 0; i < n; i++)
        for (int j = 0; j < n; j++)
            file >> matrix[i][j];
}

void write_matrix(const char *file_name, const vector<vector<double>> &matrix, int n) {
    ofstream file(file_name);
    if (!file.is_open()) {
        cerr << "Error opening file" << endl;
        exit(EXIT_FAILURE);
    }

    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            file << matrix[i][j] << " ";
        }
        file << endl;
    }
}

void gauss_jordan(vector<vector<double>> &matrix, vector<vector<double>> &identity, int n) {
    identity.resize(n, vector<double>(n, 0.0));
    for (int i = 0; i < n; i++) {
        identity[i][i] = 1.0;
    }

    for (int i = 0; i < n; i++) {
        if (matrix[i][i] == 0.0) {
            for (int j = i + 1; j < n; j++) {
                if (matrix[j][i] != 0.0) {
                    swap(matrix[i], matrix[j]);
                    swap(identity[i], identity[j]);
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
}

int main() {
    vector<vector<double>> matrix, identity;
    int n;

    read_matrix("input.txt", matrix, n);
    gauss_jordan(matrix, identity, n);
    write_matrix("output.txt", identity, n);

    return 0;
}
