#include <err.h>
#include <stdio.h>
#include <stdlib.h>

double linear(double x, double a, double b) {
    return a*x + b;
}

double polynomial(double x, double coeff[], int order) {
    double value = 0.0;
    double power = 1.0;
    for (int i = 0; i <= order; ++i) {
        value += coeff[i]*power;
        power *= x;
    }
    return value;
}

int *random_vector(int n) {
    int *vector = (int *) malloc(n*sizeof(int));
    if (!vector) {
        errx(1, "error: can not allocate vector of size %d\n", n);
    }
    for (int i = 0; i < n; ++i) {
        vector[i] = rand();
        printf("C: %d\n", vector[i]);
    }
    return vector;
}
