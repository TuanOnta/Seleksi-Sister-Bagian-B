package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func readMatrix(fileName string) ([][]float64, int) {
	file, err := os.Open(fileName)
	if err != nil {
		fmt.Println("Error opening file:", err)
		os.Exit(1)
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	scanner.Scan()
	n, _ := strconv.Atoi(scanner.Text())
	matrix := make([][]float64, n)
	for i := 0; i < n; i++ {
		matrix[i] = make([]float64, n)
		scanner.Scan()
		line := strings.Fields(scanner.Text())
		for j := 0; j < n; j++ {
			matrix[i][j], _ = strconv.ParseFloat(line[j], 64)
		}
	}

	return matrix, n
}

func writeMatrix(fileName string, matrix [][]float64) {
	file, err := os.Create(fileName)
	if err != nil {
		fmt.Println("Error creating file:", err)
		os.Exit(1)
	}
	defer file.Close()

	for _, row := range matrix {
		for _, value := range row {
			fmt.Fprintf(file, "%.6f ", value)
		}
		fmt.Fprintln(file)
	}
}

func gaussJordan(matrix [][]float64, n int) [][]float64 {
	identity := make([][]float64, n)
	for i := 0; i < n; i++ {
		identity[i] = make([]float64, n)
		identity[i][i] = 1.0
	}

	for i := 0; i < n; i++ {
		if matrix[i][i] == 0.0 {
			for j := i + 1; j < n; j++ {
				if matrix[j][i] != 0 {
					matrix[i], matrix[j] = matrix[j], matrix[i]
					identity[i], identity[j] = identity[j], identity[i]
					break
				}
			}
		}

		pivot := matrix[i][i]
		for j := 0; j < n; j++ {
			matrix[i][j] /= pivot
			identity[i][j] /= pivot
		}

		for k := 0; k < n; k++ {
			if k != i {
				factor := matrix[k][i]
				for j := 0; j < n; j++ {
					matrix[k][j] -= factor * matrix[i][j]
					identity[k][j] -= factor * identity[i][j]
				}
			}
		}
	}

	return identity
}

func main() {
	matrix, n := readMatrix("input.txt")
	inverseMatrix := gaussJordan(matrix, n)
	writeMatrix("output.txt", inverseMatrix)
}
