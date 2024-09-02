	.cpu arm7tdmi
	.arch armv4t
	.fpu softvfp
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 1
	.eabi_attribute 30, 6
	.eabi_attribute 34, 0
	.eabi_attribute 18, 4
	.file	"program.c"
	.text
	.section	.rodata
	.align	2
.LC0:
	.ascii	"%d %d\012\000"
	.text
	.align	2
	.global	compute
	.syntax unified
	.arm
	.type	compute, %function
compute:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 40
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{fp, lr}    @Menyimpan register fp(frame register) dan lr (link register)
	add	fp, sp, #4  @Membuat frame pointer
	sub	sp, sp, #40 @Membuat stack frame
	str	r0, [fp, #-40]  @Menyimpan nilai r0 ke stack frame
	str	r1, [fp, #-44]  @Menyimpan nilai r1 ke stack frame
	ldr	r3, [fp, #-40]  @Memuat nilai r0 dari stack frame ke r3
	lsl	r3, r3, #3      @Mengalikan r3 dengan 8 (melakukan pergeseran kekiri sebanyak 3 bit)
	add	r3, r3, #25     @Menambahkan r3 dengan 25
	lsr	r2, r3, #31     @Melakukan pergeseran kekanan sebanyak 31 bit
	add	r3, r2, r3      @Menambahkan r3 dengan r2 (r3 += r2)
	asr	r3, r3, #1      @Melakukan pergeseran kekanan sebanyak 1 bit
	str	r3, [fp, #-8]   @Menyimpan nilai r3 ke stack frame
	ldr	r3, [fp, #-44]  @Memuat nilai r1 dari stack frame ke r3
	ldr	r2, [fp, #-8]   @Memuat nilai r8 dari stack frame ke r2
	mul	r3, r2, r3      @Melakukan perkalian r3 dengan r2
	str	r3, [fp, #-12]  @Menyimpan nilai r3 ke stack frame
	ldr	r2, [fp, #-44]  @Memuat nilai r1 dari stack frame ke r2
	ldr	r3, [fp, #-8]   @Memuat nilai r8 dari stack frame ke r3
	add	r3, r2, r3      @Menambahkan r3 dengan r2
	str	r3, [fp, #-16]  @Menyimpan nilai r3 ke stack frame
	ldr	r3, [fp, #-12]  @Memuat nilai r12 dari stack frame ke r3
	and	r3, r3, #3      @Melakukan operasi bitwise and antara r3 dengan 3
	ldr	r2, [fp, #-16]  @Memuat nilai r16 dari stack frame ke r2
	lsl	r3, r2, r3      @Melakukan pergeseran kekiri sebanyak r3 bit
	str	r3, [fp, #-20]  @Menyimpan nilai r3 ke stack frame
	ldr	r2, [fp, #-20]  @Memuat nilai r20 dari stack frame ke r2
	ldr	r3, [fp, #-16]  @Memuat nilai r16 dari stack frame ke r3
	orr	r3, r2, r3      @Melakukan operasi bitwise or antara r3 dengan r2
	ldr	r2, [fp, #-12]  @Memuat nilai r12 dari stack frame ke r2
	eor	r3, r3, r2      @Melakukan operasi bitwise xor antara r3 dengan r2
	str	r3, [fp, #-24]  @Menyimpan nilai r3 ke stack frame
	ldr	r2, [fp, #-20]  @Memuat nilai r20 dari stack frame ke r2
	ldr	r1, [fp, #-16]  @Memuat nilai r16 dari stack frame ke r1
	ldr	r0, .L3         @Memuat alamat .L3 ke r0
	bl	printf          @Memanggil fungsi printf
	str	r0, [fp, #-28]  @Menyimpan nilai r0 ke stack frame
	ldr	r2, [fp, #-28]  @Memuat nilai r28 dari stack frame ke r2
	ldr	r1, [fp, #-24]  @Memuat nilai r24 dari stack frame ke r1
	ldr	r0, .L3         @Memuat alamat .L3 ke r0
	bl	printf          @Memanggil fungsi printf
	str	r0, [fp, #-32]  @Menyimpan nilai r0 ke stack frame
	ldr	r3, [fp, #-28]  @Memuat nilai r28 dari stack frame ke r3
	ldr	r2, [fp, #-32]  @Memuat nilai r32 dari stack frame ke r2
	mul	r3, r2, r3    @Melakukan perkalian r3 dengan r2 
	mov	r0, r3      @Memuat nilai r3 ke r0
	sub	sp, fp, #4  @Menghapus stack frame
	@ sp needed     @Menambahkan stack pointer
	pop	{fp, lr}    @Mengembalikan register fp dan lr
	bx	lr        @Kembali ke fungsi pemanggil
.L4:
	.align	2
.L3:
	.word	.LC0
	.size	compute, .-compute
	.section	.rodata
	.align	2
.LC1:
	.ascii	"%f %f\012\000"
	.text
	.align	2
	.global	main
	.syntax unified
	.arm
	.type	main, %function
main:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r4, r5, fp, lr}    @Menyimpan register r4, r5, fp(frame register) dan lr (link register) 
	add	fp, sp, #12             @Membuat frame pointer
	sub	sp, sp, #16             @Membuat stack frame
	mov	r1, #42                 @Memuat nilai 42 ke r1
	mov	r0, #69                 @Memuat nilai 69 ke r0
	bl	compute                @Memanggil fungsi compute
	mov	r3, r0               @Memuat nilai r0 ke r3
	mov	r0, r3
	bl	__aeabi_i2f         @Memanggil fungsi __aeabi_i2f
	mov	r3, r0              @Memuat nilai r0 ke r3
	str	r3, [fp, #-16]	@ float     @Menyimpan nilai r3 ke stack frame
	mov	r1, #69             @Memuat nilai 69 ke r1
	mov	r0, #42             @Memuat nilai 42 ke r0
	bl	compute             @Memanggil fungsi compute dengan parameter 42 dan 69
	mov	r3, r0              @Memuat nilai r0 ke r3 (hasil dari compute)
	mov	r0, r3              @Memuat nilai r3 ke r0  ()
	bl	__aeabi_i2f         @Memanggil fungsi __aeabi_i2f
	mov	r3, r0              @Memuat nilai r0 ke r3
	str	r3, [fp, #-20]	@ float    @Menyimpan nilai r3 ke stack frame
	ldr	r1, [fp, #-20]	@ float     @Memuat nilai r20 dari stack frame ke r1
	ldr	r0, [fp, #-16]	@ float     @Memuat nilai r16 dari stack frame ke r0
	bl	__aeabi_fadd                @Memanggil fungsi __aeabi_fadd
	mov	r3, r0                      @Memuat nilai r0 ke r3
	str	r3, [fp, #-16]	@ float     @Menyimpan nilai r3 ke stack frame
	ldr	r0, [fp, #-16]	@ float     @Memuat nilai r16 dari stack frame ke r0
	bl	__aeabi_f2d                 @Memanggil fungsi __aeabi_f2d
	mov	r4, r0                      @Memuat nilai r0 ke r4
	mov	r5, r1                      @Memuat nilai r1 ke r5
	ldr	r0, [fp, #-20]	@ float     @Memuat nilai r20 dari stack frame ke r0
	bl	__aeabi_f2d                 @Memanggil fungsi __aeabi_f2d
	mov	r2, r0                      @Memuat nilai r0 ke r2
	mov	r3, r1                      @Memuat nilai r1 ke r3
	stm	sp, {r2-r3}                 @Menyimpan nilai r2 dan r3 ke stack
	mov	r2, r4                  @Memuat nilai r4 ke r2
	mov	r3, r5                  @Memuat nilai r5 ke r3
	ldr	r0, .L7                 @Memuat alamat .L7 ke r0
	bl	printf                      @Memanggil fungsi printf
	mov	r3, #0                  @Memuat nilai 0 ke r3
	mov	r0, r3              @Memuat nilai r3 ke r0
	sub	sp, fp, #12             @Menghapus stack frame
	@ sp needed
	pop	{r4, r5, fp, lr}
	bx	lr
.L8:
	.align	2
.L7:
	.word	.LC1
	.size	main, .-main
	.global	__aeabi_f2d
	.global	__aeabi_fadd
	.global	__aeabi_i2f
	.ident	"GCC: (Fedora 14.1.0-1.fc40) 14.1.0"