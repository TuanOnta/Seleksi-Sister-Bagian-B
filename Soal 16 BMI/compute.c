#include <stdio.h>

float compute(int a, int b) {
    int r3, r2;
    r3 = (a << 3) + 25;
    r2 = r3 >> 31;
    r3 += r2;
    r3 >>= 1;
    
    int r12 = a * r3;
    int r16 = b + r3;
    int r20 = r12 & 3;
    int r24 = r16 << r20;
    int r28 = r24 | r16;
    int r24_eor = r28 ^ r12;

    printf("%d %d\n", r24_eor, r12);
    printf("%d %d\n", r3, r24_eor);
    
    return r3 * r12;
}

int main() {
    float r4, r5;
    int r3 = compute(69, 42);
    r4 = (float)r3;

    r3 = compute(42, 69);
    r5 = (float)r3;

    float result = r4 + r5;
    double d_result = (double)result;

    printf("%f %f\n", d_result, r5);
    return 0;
}