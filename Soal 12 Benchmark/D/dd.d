import std.stdio;
import std.file;
import std.string;
import std.conv;
import std.algorithm;
import std.array;
import std.math;

double[][] loadMatrixFromFile(string fileName) {
    string[] lines = readText(fileName).splitLines();
    int size = to!int(lines[0]);
    double[][] matrix = new double[][](size, size);
    
    foreach (i, line; lines[1..$]) {
        matrix[i] = line.split().map!(to!double).array();
    }
    
    return matrix;
}

double[][] computeInverse(double[][] matrix, int size) {
    double[][] inverse = new double[][](size, size);
    
    foreach (i; 0..size) {
        inverse[i] = new double[](size);
        inverse[i][i] = 1.0;
    }

    foreach (i; 0..size) {
        double pivot = matrix[i][i];
        if (abs(pivot) < 1e-12) throw new Exception("Matrix is singular or nearly singular");
        
        // Normalize the pivot row
        foreach (j; 0..size) {
            matrix[i][j] /= pivot;
            inverse[i][j] /= pivot;
        }
        
        // Eliminate the column
        foreach (k; 0..size) {
            if (k == i) continue;
            double factor = matrix[k][i];
            foreach (j; 0..size) {
                matrix[k][j] -= factor * matrix[i][j];
                inverse[k][j] -= factor * inverse[i][j];
            }
        }
    }
    
    return inverse;
}

void saveMatrixToFile(string fileName, double[][] matrix) {
    auto file = File(fileName, "w");
    foreach (row; matrix) {
        file.writeln(row.map!(to!string).join(" "));
    }
}

void main() {
    double[][] matrix = loadMatrixFromFile("input.txt");
    int size = cast(int) matrix.length;
    
    try {
        double[][] inverseMatrix = computeInverse(matrix, size);
        saveMatrixToFile("output.txt", inverseMatrix);
    } catch (Exception e) {
        writeln("Error: ", e.msg);
    }
}
