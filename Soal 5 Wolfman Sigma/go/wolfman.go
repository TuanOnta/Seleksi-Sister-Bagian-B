package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
	"sync"
	"time"
)

// Fungsi utama
func main() {
	var filename string

	fmt.Print("Masukkan panjang baris atau kolom (32/64/128/256/1024/2048): ")
	fmt.Scanln(&filename)

	mat1, mat2, err := readMatrix(filename)
	if err != nil {
		fmt.Println("Error membaca matriks:", err)
		return
	}

	n := len(mat1)
	m := len(mat2[0])

	// Perkalian matriks paralel
	sharedMat := make([][]float64, n)
	for i := range sharedMat {
		sharedMat[i] = make([]float64, m)
	}
	start := time.Now()
	resultParallel := runParallelMatrixMultiplication(mat1, mat2)
	timePar := time.Since(start)
	fmt.Println("Lama waktu eksekusi paralel:", timePar)

	// Perkalian matriks sekuensial
	start = time.Now()
	resultSequential := runSeqMatrixMultiplication(mat1, mat2)
	timeSeq := time.Since(start)
	fmt.Println("Lama waktu eksekusi sekuensial:", timeSeq)

	// Perbandingan hasil
	if areMatricesEqual(resultParallel, resultSequential) {
		fmt.Println("Hasil perkalian matriks sama")
	} else {
		fmt.Println("Hasil perkalian matriks berbeda, ada yang salah dengan kodenya")
	}

	// Perbandingan waktu eksekusi
	fmt.Println("Perbandingan waktu eksekusi:", timeSeq.Seconds()/timePar.Seconds())

}

// runParallelMatrixMultiplication melakukan perkalian matriks secara paralel
func runParallelMatrixMultiplication(mat1, mat2 [][]float64) [][]float64 {
	size := len(mat1)
	matrixC := make([][]float64, size)
	for i := 0; i < size; i++ {
		matrixC[i] = make([]float64, len(mat2[0]))
	}

	var wg sync.WaitGroup
	wg.Add(size * len(mat2[0]))

	for i := 0; i < size; i++ {
		for j := 0; j < len(mat2[0]); j++ {
			go func(i, j int) {
				defer wg.Done()
				matrixC[i][j] = pmultiply(mat1, mat2, i, j)
			}(i, j)
		}
	}

	wg.Wait()
	return matrixC
}

// runSeqMatrixMultiplication melakukan perkalian matriks secara sekuensial
func runSeqMatrixMultiplication(mat1, mat2 [][]float64) [][]float64 {
	return multiplySequential(mat1, mat2)
}

// areMatricesEqual membandingkan dua matriks
func areMatricesEqual(mat1, mat2 [][]float64) bool {
	for i := range mat1 {
		for j := range mat1[i] {
			if mat1[i][j] != mat2[i][j] {
				return false
			}
		}
	}
	return true
}

// multiplySequential performs sequential matrix multiplication
func multiplySequential(matrixA, matrixB [][]float64) [][]float64 {
	size := len(matrixA)
	matrixC := make([][]float64, size)
	for i := 0; i < size; i++ {
		matrixC[i] = make([]float64, size)
		for j := 0; j < size; j++ {
			matrixC[i][j] = pmultiply(matrixA, matrixB, i, j)
		}
	}
	return matrixC
}

// pmultiply calculates the dot product of a row from matrixA and a column from matrixB
func pmultiply(matrixA, matrixB [][]float64, row, col int) float64 {
	sum := 0.0
	for z := 0; z < len(matrixA[0]); z++ {
		sum += matrixA[row][z] * matrixB[z][col]
	}
	return sum
}

// printMatrix prints the matrix in a formatted way
func printMatrix(matrix [][]float64) {
	for _, row := range matrix {
		fmt.Println(row)
	}
}

// readMatrix reads two matrices from a file
func readMatrix(filename string) ([][]float64, [][]float64, error) {
	filePath := "c:\\coding\\Seleksi Sister\\Seleksi_Bagian_B_Sister\\Soal 5 Wolfman Sigma\\tcmatmul\\" + filename + ".txt"
	file, err := os.Open(filePath)
	if err != nil {
		return nil, nil, err
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)

	// Read the size of the matrices
	scanner.Scan()
	n, err := strconv.Atoi(scanner.Text())
	if err != nil {
		return nil, nil, err
	}

	matrix1 := make([][]float64, n)
	matrix2 := make([][]float64, n)

	// Read the first matrix
	for i := 0; i < n; i++ {
		scanner.Scan()
		line := scanner.Text()
		values := strings.Fields(line)
		matrix1[i] = make([]float64, n)
		for j := 0; j < n; j++ {
			matrix1[i][j], err = strconv.ParseFloat(values[j], 64)
			if err != nil {
				return nil, nil, err
			}
		}
	}

	// Skip the empty line between matrices
	scanner.Scan()

	// Read the second matrix
	for i := 0; i < n; i++ {
		scanner.Scan()
		line := scanner.Text()
		values := strings.Fields(line)
		matrix2[i] = make([]float64, n)
		for j := 0; j < n; j++ {
			matrix2[i][j], err = strconv.ParseFloat(values[j], 64)
			if err != nil {
				return nil, nil, err
			}
		}
	}

	return matrix1, matrix2, nil
}
