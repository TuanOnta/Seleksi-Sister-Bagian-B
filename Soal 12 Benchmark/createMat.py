import random

def generate_random_matrix(n, filename):
    # Generate nxn random matrix
    matrix = [[random.randint(1, 10000) for _ in range(n)] for _ in range(n)]
    
    # Write the matrix to a file
    with open(filename, 'w') as f:
        f.write(f"{n}\n")
        for row in matrix:
            f.write(" ".join(map(str, row)) + "\n")

n = 135  # ukuran matrix
filename = "input.txt"
generate_random_matrix(n, filename)
