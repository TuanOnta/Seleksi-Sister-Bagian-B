using System;
using System.IO;

class MatrixInversion
{
    static void Main()
    {
        var matrix = ReadMatrix("input.txt", out int n);
        var identity = GaussJordan(matrix, n);
        WriteMatrix("output.txt", identity, n);
    }

    static double[,] ReadMatrix(string fileName, out int n)
    {
        var lines = File.ReadAllLines(fileName);
        n = int.Parse(lines[0]);
        var matrix = new double[n, n];

        for (int i = 0; i < n; i++)
        {
            var elements = lines[i + 1].Split(' ');
            for (int j = 0; j < n; j++)
            {
                matrix[i, j] = double.Parse(elements[j]);
            }
        }

        return matrix;
    }

    static void WriteMatrix(string fileName, double[,] matrix, int n)
    {
        using (var writer = new StreamWriter(fileName))
        {
            for (int i = 0; i < n; i++)
            {
                for (int j = 0; j < n; j++)
                {
                    writer.Write($"{matrix[i, j]:F6} ");
                }
                writer.WriteLine();
            }
        }
    }

    static double[,] GaussJordan(double[,] matrix, int n)
    {
        var identity = new double[n, n];
        for (int i = 0; i < n; i++)
        {
            identity[i, i] = 1.0;
        }

        for (int i = 0; i < n; i++)
        {
            if (matrix[i, i] == 0.0)
            {
                for (int j = i + 1; j < n; j++)
                {
                    if (matrix[j, i] != 0.0)
                    {
                        SwapRows(matrix, identity, i, j, n);
                        break;
                    }
                }
            }

            double pivot = matrix[i, i];
            for (int j = 0; j < n; j++)
            {
                matrix[i, j] /= pivot;
                identity[i, j] /= pivot;
            }

            for (int k = 0; k < n; k++)
            {
                if (k != i)
                {
                    double factor = matrix[k, i];
                    for (int j = 0; j < n; j++)
                    {
                        matrix[k, j] -= factor * matrix[i, j];
                        identity[k, j] -= factor * identity[i, j];
                    }
                }
            }
        }

        return identity;
    }

    static void SwapRows(double[,] matrix, double[,] identity, int i, int j, int n)
    {
        for (int k = 0; k < n; k++)
        {
            double tempMatrix = matrix[i, k];
            matrix[i, k] = matrix[j, k];
            matrix[j, k] = tempMatrix;

            double tempIdentity = identity[i, k];
            identity[i, k] = identity[j, k];
            identity[j, k] = tempIdentity;
        }
    }
}
