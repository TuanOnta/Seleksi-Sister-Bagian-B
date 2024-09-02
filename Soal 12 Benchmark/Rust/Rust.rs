use std::fs::File;
use std::io::{BufRead, BufReader, Write};

fn read_matrix(file_name: &str) -> (Vec<Vec<f64>>, usize) {
    let file = File::open(file_name).expect("Error opening file");
    let reader = BufReader::new(file);

    let mut lines = reader.lines();
    let n = lines
        .next()
        .unwrap()
        .unwrap()
        .parse::<usize>()
        .expect("Error parsing size");

    let mut matrix = Vec::with_capacity(n);
    for line in lines {
        let row: Vec<f64> = line
            .unwrap()
            .split_whitespace()
            .map(|x| x.parse::<f64>().unwrap())
            .collect();
        matrix.push(row);
    }

    (matrix, n)
}

fn write_matrix(file_name: &str, matrix: Vec<Vec<f64>>) {
    let mut file = File::create(file_name).expect("Error creating file");
    for row in matrix {
        writeln!(file, "{}", row.iter().map(|x| format!("{:.6}", x)).collect::<Vec<_>>().join(" ")).unwrap();
    }
}

fn gauss_jordan(mut matrix: Vec<Vec<f64>>, n: usize) -> Vec<Vec<f64>> {
    let mut identity = vec![vec![0.0; n]; n];
    for i in 0..n {
        identity[i][i] = 1.0;
    }

    for i in 0..n {
        if matrix[i][i] == 0.0 {
            for j in (i + 1)..n {
                if matrix[j][i] != 0.0 {
                    matrix.swap(i, j);
                    identity.swap(i, j);
                    break;
                }
            }
        }

        let pivot = matrix[i][i];
        for j in 0..n {
            matrix[i][j] /= pivot;
            identity[i][j] /= pivot;
        }

        for k in 0..n {
            if k != i {
                let factor = matrix[k][i];
                for j in 0..n {
                    matrix[k][j] -= factor * matrix[i][j];
                    identity[k][j] -= factor * identity[i][j];
                }
            }
        }
    }

    identity
}

fn main() {
    let (matrix, n) = read_matrix("input.txt");
    let inverse_matrix = gauss_jordan(matrix, n);
    write_matrix("output.txt", inverse_matrix);
}
