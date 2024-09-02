### Go
- **Input dan Pembacaan Matriks:** Program meminta pengguna untuk memasukkan ukuran matriks, kemudian membaca dua matriks dari file dengan nama yang sesuai dengan ukuran tersebut.
- **Perkalian Matriks:** Terdapat dua metode untuk mengalikan matriks: secara sekuensial dan paralel. Pada pendekatan paralel, setiap elemen hasil perkalian dihitung dalam goroutine terpisah, yang disinkronisasi menggunakan `sync.WaitGroup`.
- **Perbandingan:** Hasil dari kedua metode dibandingkan untuk memastikan konsistensi, dan waktu eksekusi antara metode paralel dan sekuensial dibandingkan.

### Python
- **Input dan Pembacaan Matriks:** Pengguna diminta untuk memasukkan ukuran matriks. Dua matriks dibaca dari file dengan format yang diharapkan.
- **Perkalian Matriks:** Program menggunakan multiprocessing untuk melakukan perkalian matriks secara paralel. Setiap proses mengerjakan bagian dari matriks hasil, yang disimpan dalam shared memory.
- **Perbandingan:** Hasil dari perkalian matriks paralel dan sekuensial dibandingkan, dan waktu eksekusi kedua metode tersebut dibandingkan untuk melihat efisiensi.

### Rust
- **Input dan Pembacaan Matriks:** Pengguna diminta untuk memasukkan ukuran matriks, dan kemudian matriks dibaca dari file.
- **Perkalian Matriks:** Program menggunakan `rayon` untuk melakukan perkalian matriks secara paralel, di mana elemen-elemen hasil dihitung secara bersamaan. Pendekatan sekuensial juga diimplementasikan.
- **Perbandingan:** Hasil dari metode paralel dan sekuensial dibandingkan, dan waktu eksekusi kedua metode dihitung serta dibandingkan.

### Java
- **Input Pengguna:** Program meminta pengguna untuk memasukkan nama file yang berisi matriks serta jumlah prosesor yang akan digunakan.
- **Membaca Matriks:** Program membaca dua matriks dari file teks dengan menggunakan method `readMatrix`.
- **Perkalian Matriks Secara Sekuensial:** Program mengalikan kedua matriks secara sekuensial menggunakan method `multiply`.
- **Perkalian Matriks Secara Paralel:** Program mengalikan kedua matriks secara paralel menggunakan method `multiply_parallel`, yang memanfaatkan `IntStream` untuk menjalankan operasi secara paralel.
- **Perbandingan Hasil:** Program membandingkan hasil perkalian matriks dari kedua metode untuk memastikan bahwa hasilnya sama, dan mencetak waktu eksekusi dari kedua metode.

### Hasil Test Case
## Python
# 32x32
![32x32](HasilTC/Python/32.png)
# 64x64
![64x64](HasilTC/Python/64.png)
# 128x128
![128x128](HasilTC/Python/128.png)
# 256x256
![256x256](HasilTC/Python/256.png)
# 512x512
![512x512](HasilTC/Python/512.png)
# 1024x1024
![1024x1024](HasilTC/Python/1024.png)
# 2048x2048
![2048x2048](HasilTC/Python/2048.png)

## Rust
# 32x32
![32x32](HasilTC/Rust/32.png)
# 64x64
![64x64](HasilTC/Rust/64.png)
# 128x128
![128x128](HasilTC/Rust/128.png)
# 256x256
![256x256](HasilTC/Rust/256.png)
# 512x512
![512x512](HasilTC/Rust/512.png)
# 1024x1024
![1024x1024](HasilTC/Rust/1024.png)
# 2048x2048
![2048x2048](HasilTC/Rust/2048.png)

## Java
# 32x32
![32x32](HasilTC/Java/32.png)
# 64x64
![64x64](HasilTC/Java/64.png)
# 128x128
![128x128](HasilTC/Java/128.png)
# 256x256
![256x256](HasilTC/Java/256.png)
# 512x512
![512x512](HasilTC/Java/512.png)
# 1024x1024
![1024x1024](HasilTC/Java/1024.png)
# 2048x2048
![2048x2048](HasilTC/Java/2048.png)

## Go
# 32x32
![32x32](HasilTC/Go/32.png)
# 64x64
![64x64](HasilTC/Go/64.png)
# 128x128
![128x128](HasilTC/Go/128.png)
# 256x256
![256x256](HasilTC/Go/256.png)
# 512x512
![512x512](HasilTC/Go/512.png)
# 1024x1024
![1024x1024](HasilTC/Go/1024.png)
# 2048x2048
![2048x2048](HasilTC/Go/2048.png)
