## 1. Fungsi `compute`

### Deskripsi Umum
Fungsi `compute` menerima dua parameter integer (`r0` dan `r1`), melakukan serangkaian operasi aritmatika dan bitwise, dan menghasilkan satu nilai integer sebagai output.

### Langkah-langkah Eksekusi

#### **Inisialisasi dan Penyimpanan Parameter**

```asm
push	{fp, lr}         ; Menyimpan register fp dan lr ke stack
add	fp, sp, #4        ; Mengatur frame pointer
sub	sp, sp, #40       ; Mengalokasikan 40 byte untuk stack frame
str	r0, [fp, #-40]    ; Menyimpan parameter pertama ke stack frame
str	r1, [fp, #-44]    ; Menyimpan parameter kedua ke stack frame
```

- **Tujuan**: Menyiapkan stack frame dan menyimpan parameter input untuk digunakan dalam operasi selanjutnya.

#### **Operasi Pertama: Menghitung Nilai Intermediate**

```asm
ldr	r3, [fp, #-40]    ; Memuat nilai parameter pertama ke r3
lsl	r3, r3, #3        ; Mengalikan r3 dengan 8 (left shift 3 bit)
add	r3, r3, #25       ; Menambahkan 25 ke r3
lsr	r2, r3, #31       ; Menggeser kanan r3 sebanyak 31 bit, hasil ke r2
add	r3, r2, r3        ; Menambahkan r2 ke r3
asr	r3, r3, #1        ; Menggeser kanan aritmatika r3 sebanyak 1 bit
str	r3, [fp, #-8]     ; Menyimpan hasil ke stack frame
```

- **Penjelasan Detail**:
  1. **`r3 = param1 * 8 + 25`**: Mengalikan parameter pertama dengan 8 dan menambahkan 25.
  2. **`r2 = r3 >> 31`**: Mengambil bit paling signifikan dari `r3`.
  3. **`r3 = r3 + r2`**: Menambahkan koreksi untuk pembulatan (teknik bias).
  4. **`r3 = r3 >> 1`**: Membagi hasil sebelumnya dengan 2, menghasilkan semacam operasi pembulatan.
  5. **Hasil disimpan ke lokasi sementara untuk digunakan nanti.**

#### **Operasi Kedua: Perkalian dengan Parameter Kedua**

```asm
ldr	r3, [fp, #-44]    ; Memuat parameter kedua ke r3
ldr	r2, [fp, #-8]     ; Memuat hasil sebelumnya ke r2
mul	r3, r2, r3        ; Mengalikan r2 dengan parameter kedua
str	r3, [fp, #-12]    ; Menyimpan hasil ke stack frame
```

- **Penjelasan Detail**:
  - **`r3 = (hasil_sebelumnya) * param2`**: Mengalikan hasil operasi pertama dengan parameter kedua.

#### **Operasi Ketiga: Penjumlahan dengan Parameter Kedua**

```asm
ldr	r2, [fp, #-44]    ; Memuat parameter kedua ke r2
ldr	r3, [fp, #-8]     ; Memuat hasil pertama ke r3
add	r3, r2, r3        ; Menambahkan r2 dan r3
str	r3, [fp, #-16]    ; Menyimpan hasil ke stack frame
```

- **Penjelasan Detail**:
  - **`r3 = param2 + hasil_sebelumnya`**: Menambahkan parameter kedua dengan hasil operasi pertama.

#### **Operasi Keempat: Operasi Bitwise Shift dan AND**

```asm
ldr	r3, [fp, #-12]    ; Memuat hasil kedua ke r3
and	r3, r3, #3        ; Melakukan AND dengan 3 (mengambil 2 bit terbawah)
ldr	r2, [fp, #-16]    ; Memuat hasil ketiga ke r2
lsl	r3, r2, r3        ; Menggeser kiri r2 sebanyak nilai di r3
str	r3, [fp, #-20]    ; Menyimpan hasil ke stack frame
```

- **Penjelasan Detail**:
  1. **`temp = hasil_kedua & 3`**: Mengambil 2 bit terbawah dari hasil kedua.
  2. **`r3 = hasil_ketiga << temp`**: Menggeser kiri hasil ketiga sebanyak `temp` bit.

#### **Operasi Kelima: Operasi OR dan XOR**

```asm
ldr	r2, [fp, #-20]    ; Memuat hasil keempat ke r2
ldr	r3, [fp, #-16]    ; Memuat hasil ketiga ke r3
orr	r3, r2, r3        ; Melakukan OR antara r2 dan r3
ldr	r2, [fp, #-12]    ; Memuat hasil kedua ke r2
eor	r3, r3, r2        ; Melakukan XOR antara r3 dan r2
str	r3, [fp, #-24]    ; Menyimpan hasil akhir ke stack frame
```

- **Penjelasan Detail**:
  1. **`r3 = hasil_keempat | hasil_ketiga`**: Melakukan operasi OR.
  2. **`r3 = r3 ^ hasil_kedua`**: Melakukan operasi XOR untuk menghasilkan hasil akhir.

#### **Mencetak Hasil dengan `printf`**

```asm
ldr	r2, [fp, #-20]    ; Memuat hasil keempat ke r2
ldr	r1, [fp, #-16]    ; Memuat hasil ketiga ke r1
ldr	r0, .L3           ; Memuat format string ke r0 ("%d %d\n")
bl	printf            ; Mencetak hasil keempat dan ketiga
```

- **Penjelasan Detail**:
  - Mencetak dua nilai integer: hasil keempat dan hasil ketiga.

```asm
ldr	r2, [fp, #-28]    ; Memuat nilai return dari printf sebelumnya (tidak terlalu relevan)
ldr	r1, [fp, #-24]    ; Memuat hasil akhir ke r1
ldr	r0, .L3           ; Memuat format string ke r0 ("%d %d\n")
bl	printf            ; Mencetak nilai return sebelumnya dan hasil akhir
```

- **Penjelasan Detail**:
  - Mencetak dua nilai integer: nilai return dari `printf` sebelumnya dan hasil akhir.

#### **Menghitung Hasil Akhir dan Mengembalikan Nilai**

```asm
ldr	r3, [fp, #-28]    ; Memuat nilai return dari printf pertama
ldr	r2, [fp, #-32]    ; Memuat nilai return dari printf kedua
mul	r3, r2, r3        ; Mengalikan kedua nilai tersebut
mov	r0, r3            ; Menyiapkan nilai return fungsi compute
sub	sp, fp, #4        ; Mengembalikan stack pointer
pop	{fp, lr}          ; Memulihkan register fp dan lr
bx	lr                ; Kembali ke pemanggil
```

- **Penjelasan Detail**:
  - Mengalikan nilai return dari kedua pemanggilan `printf` dan mengembalikan hasilnya sebagai output fungsi `compute`.

## 2. Fungsi `main`

### Deskripsi Umum
Fungsi `main` memanggil fungsi `compute` dengan dua set parameter yang berbeda, melakukan konversi dan operasi floating-point pada hasilnya, dan mencetak hasil akhir menggunakan `printf`.

### Langkah-langkah Eksekusi

#### **Inisialisasi dan Pemanggilan Pertama ke `compute`**

```asm
push	{r4, r5, fp, lr}    ; Menyimpan register penting ke stack
add	fp, sp, #12           ; Mengatur frame pointer
sub	sp, sp, #16           ; Mengalokasikan 16 byte untuk stack frame
mov	r1, #42               ; Menyiapkan parameter kedua = 42
mov	r0, #69               ; Menyiapkan parameter pertama = 69
bl	compute               ; Memanggil fungsi compute
```

- **Penjelasan Detail**:
  - Memanggil `compute(69, 42)` dan menyimpan hasilnya di `r0`.

#### **Konversi Hasil Pertama ke Floating-Point**

```asm
mov	r3, r0                ; Menyimpan hasil compute ke r3
mov	r0, r3                ; Menyiapkan argumen untuk konversi
bl	__aeabi_i2f           ; Mengonversi integer ke float
mov	r3, r0                ; Menyimpan hasil float ke r3
str	r3, [fp, #-16]        ; Menyimpan float ke stack frame
```

- **Penjelasan Detail**:
  - Mengonversi hasil integer dari `compute` menjadi nilai floating-point dan menyimpannya.

#### **Pemanggilan Kedua ke `compute`**

```asm
mov	r1, #69               ; Menyiapkan parameter kedua = 69
mov	r0, #42               ; Menyiapkan parameter pertama = 42
bl	compute               ; Memanggil fungsi compute
```

- **Penjelasan Detail**:
  - Memanggil `compute(42, 69)` dan menyimpan hasilnya di `r0`.

#### **Konversi Hasil Kedua ke Floating-Point**

```asm
mov	r3, r0                ; Menyimpan hasil compute ke r3
mov	r0, r3                ; Menyiapkan argumen untuk konversi
bl	__aeabi_i2f           ; Mengonversi integer ke float
mov	r3, r0                ; Menyimpan hasil float ke r3
str	r3, [fp, #-20]        ; Menyimpan float ke stack frame
```

- **Penjelasan Detail**:
  - Mengonversi hasil integer dari `compute` menjadi nilai floating-point dan menyimpannya.

#### **Menjumlahkan Dua Hasil Floating-Point**

```asm
ldr	r1, [fp, #-20]        ; Memuat float kedua ke r1
ldr	r0, [fp, #-16]        ; Memuat float pertama ke r0
bl	__aeabi_fadd          ; Menambahkan dua float
mov	r3, r0                ; Menyimpan hasil penjumlahan ke r3
str	r3, [fp, #-16]        ; Menyimpan hasil ke stack frame
```

- **Penjelasan Detail**:
  - Menambahkan dua hasil float dari pemanggilan `compute` sebelumnya.

#### **Konversi ke Double dan Persiapan untuk `printf`**

```asm
ldr	r0, [fp, #-16]        ; Memuat hasil penjumlahan float ke r0
bl	__aeabi_f2d           ; Mengonversi float ke double
mov	r4, r0                ; Menyimpan bagian rendah double ke r4
mov	r5, r1                ; Menyimpan bagian tinggi double ke r5

ldr	r0, [fp, #-20]        ; Memuat float kedua ke r0
bl	__aeabi_f2d           ; Mengonversi float ke double
mov	r2, r0                ; Menyimpan bagian rendah double ke r2
mov	r3, r1                ; Menyimpan bagian tinggi double ke r3

stm	sp, {r2-r3}           ; Menyimpan double kedua ke stack
mov	r2, r4                ; Menyiapkan double pertama bagian rendah untuk printf
mov	r3, r5                ; Menyiapkan double pertama bagian tinggi untuk printf
ldr	r0, .L7               ; Memuat format string ("%f %f\n") ke r0
bl	printf                ; Mencetak dua nilai double
```

- **Penjelasan Detail**:
  - Mengonversi hasil penjumlahan dan float kedua menjadi double precision dan mencetak keduanya menggunakan `printf`.

#### **Mengakhiri Fungsi `main`**

```asm
mov	r3, #0                ; Menyiapkan nilai return = 0
mov	r0, r3                ; Menyiapkan nilai return
sub	sp, fp, #12           ; Mengembalikan stack pointer
pop	{r4, r5, fp, lr}      ; Memulihkan register yang disimpan
bx	lr                    ; Kembali ke sistem operasi
```

- **Penjelasan Detail**:
  - Mengakhiri eksekusi program dengan kode return 0.

### Ringkasan Fungsi `main`
Fungsi `main` melakukan hal berikut:
1. Memanggil `compute(69, 42)` dan mengonversi hasilnya ke float.
2. Memanggil `compute(42, 69)` dan mengonversi hasilnya ke float.
3. Menambahkan kedua nilai float tersebut.
4. Mengonversi hasil penjumlahan ke double precision.
5. Mencetak hasil penjumlahan dan nilai float kedua dalam format double menggunakan `printf`.
6. Mengembalikan nilai 0 sebagai kode exit program.