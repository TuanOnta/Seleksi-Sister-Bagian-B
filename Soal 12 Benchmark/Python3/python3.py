def read_matrix(file_name):
    with open(file_name, 'r') as file:
        n = int(file.readline())
        matrix = []
        for _ in range(n):
            row = list(map(float, file.readline().split()))
            matrix.append(row)
    return matrix, n

def write_matrix(file_name, matrix):
    path = "Python3/" + file_name
    with open(file_name, 'w') as file:
        for row in matrix:
            file.write(" ".join(map(str, row)) + "\n")

def gauss_jordan(matrix, n):
    # Membuat matriks identitas
    identity_matrix = [[1 if i == j else 0 for j in range(n)] for i in range(n)]

    # Proses Gauss-Jordan
    for i in range(n):
        # Pivoting: memastikan elemen diagonal tidak nol
        if matrix[i][i] == 0.0:
            for j in range(i+1, n):
                if matrix[j][i] != 0:
                    matrix[i], matrix[j] = matrix[j], matrix[i]
                    identity_matrix[i], identity_matrix[j] = identity_matrix[j], identity_matrix[i]
                    break

        # Normalisasi baris i
        pivot = matrix[i][i]
        for j in range(n):
            matrix[i][j] /= pivot
            identity_matrix[i][j] /= pivot

        # Eliminasi kolom
        for k in range(n):
            if k != i:
                factor = matrix[k][i]
                for j in range(n):
                    matrix[k][j] -= factor * matrix[i][j]
                    identity_matrix[k][j] -= factor * identity_matrix[i][j]

    return identity_matrix

def invert_matrix(input_file, output_file):
    matrix, n = read_matrix(input_file)
    inverse_matrix = gauss_jordan(matrix, n)
    write_matrix(output_file, inverse_matrix)

invert_matrix('input.txt', 'output.txt')
