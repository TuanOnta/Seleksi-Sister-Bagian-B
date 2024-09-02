import multiprocessing
import time


def check_dimension(mat1, mat2):
    """
    Checks if the number of columns in the first matrix (mat1) is equal to the number of rows in the second matrix (mat2).

    Args:
        mat1 (list of list of int/float): The first matrix.
        mat2 (list of list of int/float): The second matrix.

    Returns:
        bool: True if the number of columns in mat1 is equal to the number of rows in mat2, False otherwise.
    """
    if len(mat1[0]) != len(mat2):
        return False
    return True

def create_matrix(n, m):
    """
    Creates a 2D matrix (list of lists) with dimensions n x m, initialized with 0.0.

    Args:
        n (int): The number of rows in the matrix.
        m (int): The number of columns in the matrix.

    Returns:
        list: A 2D list (matrix) of dimensions n x m, filled with 0.0.
    """
    return [[0.0 for i in range(m)] for j in range(n)]

def print_errorMat(mat1, mat2):
    """
    Prints an error message indicating that the dimensions of the two matrices are not compatible.

    Parameters:
    mat1 (list of lists): The first matrix.
    mat2 (list of lists): The second matrix.
    """
    print("Error: Matrix dimension is not compatible")

def multiply_matrix(mat1, mat2):
    """
    Multiplies two matrices if their dimensions are compatible.

    Args:
        mat1 (list of list of int/float): The first matrix to be multiplied.
        mat2 (list of list of int/float): The second matrix to be multiplied.

    Returns:
        list of list of int/float: The resulting matrix after multiplication.
        None: If the dimensions of the matrices are not compatible for multiplication.

    Raises:
        ValueError: If the dimensions of the matrices are not compatible for multiplication.
    """
    if check_dimension(mat1, mat2):
        n = len(mat1)
        m = len(mat1[0])
        r = len(mat2[0])

        result = create_matrix(n, r)

        for i in range(n):
            for j in range(r):
                for k in range(m):
                    result[i][j] += mat1[i][k] * mat2[k][j]

        return result
    else:
        print_errorMat(mat1, mat2)
        return None
    
def multiply_matrix_paralel(mat1, mat2, sharedMem, offI):
    """
    Multiplies two matrices in parallel and stores the result in shared memory.

    Args:
        mat1 (list of list of float): The first matrix to be multiplied.
        mat2 (list of list of float): The second matrix to be multiplied.
        sharedMem (list of float): The shared memory array where the result will be stored.
        offI (int): The offset index in the shared memory array.

    Returns:
        None: The result is stored in the shared memory array.
    
    Notes:
        - The function assumes that the dimensions of the matrices are compatible for multiplication.
        - The result of the multiplication is stored in the shared memory array starting at the index `offI * r`.
        - If the dimensions of the matrices are not compatible, an error message is printed and the function returns None.
    """
    if not check_dimension(mat1, mat2):
        print_errorMat(mat1, mat2)
        return None
    
    n = len(mat1)
    m = len(mat1[0])
    r = len(mat2[0])

    for i in range(n):
        for j in range(r):
            temp = 0.0
            for k in range(m):
                temp += mat1[i][k] * mat2[k][j]
            sharedMem[offI * r + i * r + j] = temp
            
def print_matrix(mat):
    """
    Prints each row of a given matrix.

    Args:
        mat (list of list of any): The matrix to be printed, where each element is a row of the matrix.
    """
    for row in mat:
        print(row)

def change_dimension_from_1D_to_2D(arr, m, n):
    """
    Converts a 1D array into a 2D matrix with specified dimensions.

    Args:
        arr (list): The 1D array to be converted.
        m (int): The number of rows for the 2D matrix.
        n (int): The number of columns for the 2D matrix.

    Returns:
        list: A 2D matrix with dimensions m x n filled with elements from the 1D array.
    """
    result = create_matrix(m, n)
    
    k = 0
    for i in range(m):
        for j in range(n):
            result[i][j] = arr[k]
            k += 1
    
    return result
def run_seq_matrix_multiplication(mat1, mat2):
    """
    Perform sequential matrix multiplication and measure execution time.

    Args:
        mat1 (list of list of int/float): The first matrix to be multiplied.
        mat2 (list of list of int/float): The second matrix to be multiplied.

    Returns:
        tuple: A tuple containing:
            - exec_time (float): The time taken to perform the matrix multiplication.
            - result (list of list of int/float): The resulting matrix after multiplication.
    """
    startTime = time.time()
    result = multiply_matrix(mat1, mat2)
    endTime = time.time()
    exec_time = endTime - startTime
    return exec_time, result

def divide_matrix(total_rows, numProcessors):
    """
    Divides the total number of rows into chunks for each processor.

    Args:
        total_rows (int): The total number of rows to be divided.
        numProcessors (int): The number of processors available for processing.

    Returns:
        list: A list containing the indices where each processor's chunk starts and ends.
    """
    division = []
    resLast, res = 0, 0
    division.append(res)
    if total_rows < numProcessors:
        numProcessors = total_rows
    while numProcessors != 0:
        resLast = resLast + res
        res = total_rows // numProcessors
        
        division.append(resLast + res)
        total_rows = total_rows - res
        numProcessors = numProcessors - 1

    return division

def run_parallel_matrix_multiplication(mat1, mat2, sharedMat, numProcessors):
    """
    Perform matrix multiplication in parallel using multiple processors.

    Args:
    mat1 (list): The first matrix to be multiplied.
    mat2 (list): The second matrix to be multiplied.
    sharedMat (list): The shared matrix to store the result of multiplication.
    numProcessors (int): The number of processors to be used for parallel computation.

    Returns:
    tuple: A tuple containing the execution time of the operation and the result matrix.
    """
    if numProcessors > len(mat1):
        numProcessors = len(mat1)
    processArr = []
    total_row = len(mat1)
    division = divide_matrix(total_row, numProcessors)

    startTime = time.time()
    
    for i in range(numProcessors):
        mat1_slice = mat1[division[i]:division[i+1]]
        proc = multiprocessing.Process(target=multiply_matrix_paralel, args=(mat1_slice, mat2, sharedMat, division[i]))
        processArr.append(proc)

    if len(division) == 1:
        sharedMat = multiply_matrix(mat1, mat2)

    for p in processArr:
        p.start()

    for p in processArr:
        p.join()
    endTime = time.time()

    exec_time = endTime - startTime
    n = int(len(sharedMat)**0.5)
    result = change_dimension_from_1D_to_2D(sharedMat, n, n)
    return exec_time, result

def readMatrix(filename):
    """
    Reads two matrices from a file and returns them as lists of lists.

    The file should be located in the "Soal 5 Wolfman Sigma/tcmatmul/" directory.
    The file format is expected to be:
    - The first line contains an integer n, the size of the matrices (n x n).
    - The next n lines contain the first matrix, with each line representing a row.
    - An empty line follows.
    - The next n lines contain the second matrix, with each line representing a row.

    Args:
        filename (str): The name of the file to read the matrices from.

    Returns:
        tuple: A tuple containing two matrices (matrix1, matrix2), where each matrix is a list of lists of floats.
    """
    filename = "Soal 5 Wolfman Sigma/tcmatmul/" + filename + ".txt"
    with open(filename) as f:
        n = int(f.readline().strip())
        matrix1 = []
        matrix2 = []
        for i in range(n):
            row = list(map(float, f.readline().strip().split()))
            matrix1.append(row)

        f.readline()  # Skip empty line between matrices
        for _ in range(n):
            row = list(map(float, f.readline().strip().split()))
            matrix2.append(row)
    return matrix1, matrix2

def are_matrices_equal(mat1, mat2):
    """
    Check if two matrices are equal.

    This function compares two matrices to determine if they are identical in terms of dimensions and elements.

    Parameters:
    mat1 (list of list of int/float): The first matrix to compare.
    mat2 (list of list of int/float): The second matrix to compare.

    Returns:
    bool: True if the matrices are equal, False otherwise.
    """
    # Periksa apakah dimensi matriks sama
    if len(mat1) != len(mat2) or len(mat1[0]) != len(mat2[0]):
        return False
    
    # Bandingkan setiap elemen di kedua matriks
    for i in range(len(mat1)):
        for j in range(len(mat1[0])):
            if mat1[i][j] != mat2[i][j]:
                return False
    
    return True

def main():
    filename = input("Masukkan panjang baris atau kolom (32/64/128/256/512/1024/2048):")
    numProcessors = 10
    mat1, mat2 = readMatrix(filename)
    n = len(mat1)
    m = len(mat2[0])
    sharedMat = multiprocessing.Array('d', n * m)  # Array untuk nilai float
    time_par, result_par = run_parallel_matrix_multiplication(mat1, mat2, sharedMat, numProcessors)
    print(f"lama waktu eksekusi paralel :  {time_par:.6f} detik")
    sharedMat = multiprocessing.Array('d', n * m)  # Array untuk nilai float
    time_seq, result_seq = run_seq_matrix_multiplication(mat1, mat2)
    print(f"lama waktu eksekusi sequensial: {time_seq:.6f} detik")

    if are_matrices_equal(result_par, result_seq):
        print("Hasil perkalian matriks sama")
    else:
        print("Hasil perkalian matriks berbeda ada yang salah dengan kode nya")

    print(f"Perbandingan waktu eksekusi : {time_seq/time_par:.2f}")
    return

if __name__ == "__main__":
    main()
