use rayon::prelude::*;
use std::fs::File;
use std::io::{self, BufRead, BufReader};
use std::path::Path;

fn main() {
    // Membaca input dari pengguna
    let mut input = String::new();
    println!("Masukkan panjang baris atau kolom (32/64/128/256/1024/2048):");
    io::stdin().read_line(&mut input).expect("Failed to read input");
    let filename = input.trim();

    // Membaca matriks dari file
    let matrices = read_matrix(filename).expect("Failed to read matrix");
    let matrix1 = matrices.0;
    let matrix2 = matrices.1;

    // Eksekusi sekuensial
    let start_seq = std::time::Instant::now();
    let result_sequential = multiply(&matrix1, &matrix2);
    let time_seq = start_seq.elapsed().as_millis();
    println!("Lama waktu eksekusi sekuensial: {} ms", time_seq);

    // Eksekusi paralel
    let start_par = std::time::Instant::now();
    let result_parallel = multiply_parallel(&matrix1, &matrix2);
    let time_par = start_par.elapsed().as_millis();
    println!("Lama waktu eksekusi paralel: {} ms", time_par);

    // Membandingkan hasil
    if are_matrices_equal(&result_sequential, &result_parallel) {
        println!("Hasil perkalian matriks sama");
    } else {
        println!("Hasil perkalian matriks berbeda, ada yang salah dengan kodenya");
    }

    // Membandingkan waktu eksekusi
    println!("Perbandingan waktu eksekusi: {}", time_seq as f64 / time_par as f64);
}

fn multiply(matrix1: &Vec<Vec<f64>>, matrix2: &Vec<Vec<f64>>) -> Vec<Vec<f64>> {
    let num_row1 = matrix1.len();
    let num_col1 = matrix1[0].len();
    let num_col2 = matrix2[0].len();

    let mut result = vec![vec![0.0; num_col2]; num_row1];

    for i in 0..num_row1 {
        for j in 0..num_col2 {
            for k in 0..num_col1 {
                result[i][j] += matrix1[i][k] * matrix2[k][j];
            }
        }
    }

    result
}

fn multiply_parallel(matrix1: &Vec<Vec<f64>>, matrix2: &Vec<Vec<f64>>) -> Vec<Vec<f64>> {
    let num_row1 = matrix1.len();

    (0..num_row1).into_par_iter().map(|i| {
        multiply_row(matrix1, matrix2, i)
    }).collect()
}

fn multiply_row(matrix1: &Vec<Vec<f64>>, matrix2: &Vec<Vec<f64>>, row: usize) -> Vec<f64> {
    let num_col1 = matrix1[0].len();
    let num_col2 = matrix2[0].len();
    let mut result_row = vec![0.0; num_col2];

    for j in 0..num_col2 {
        for k in 0..num_col1 {
            result_row[j] += matrix1[row][k] * matrix2[k][j];
        }
    }

    result_row
}

fn read_matrix(filename: &str) -> io::Result<(Vec<Vec<f64>>, Vec<Vec<f64>>)> {
    let formatted_path = format!(
        "c:\\coding\\Seleksi Sister\\Seleksi_Bagian_B_Sister\\Soal 5 Wolfman Sigma\\tcmatmul\\{}.txt",
        filename
    );
    let file_path = Path::new(&formatted_path);
    let file = File::open(&file_path)?;
    let reader = BufReader::new(file);

    let mut lines = reader.lines();
    let n: usize = lines.next().unwrap()?.trim().parse().unwrap();

    let matrix1: Vec<Vec<f64>> = (0..n)
        .map(|_| {
            lines
                .next()
                .unwrap()
                .unwrap()
                .trim()
                .split_whitespace()
                .map(|s| s.parse().unwrap())
                .collect()
        })
        .collect();

    lines.next(); // Skip the empty line between matrices

    let matrix2: Vec<Vec<f64>> = (0..n)
        .map(|_| {
            lines
                .next()
                .unwrap()
                .unwrap()
                .trim()
                .split_whitespace()
                .map(|s| s.parse().unwrap())
                .collect()
        })
        .collect();

    Ok((matrix1, matrix2))
}

fn are_matrices_equal(matrix1: &Vec<Vec<f64>>, matrix2: &Vec<Vec<f64>>) -> bool {
    matrix1 == matrix2
}
