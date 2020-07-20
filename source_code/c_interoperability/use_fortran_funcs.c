#include <stdio.h>

double func(double x, void *params);

int main() {
    double x = 0.5;
    double params[] = {1.0, -2.0, 3.0};
    printf("result = %lf\n", func(x, params));
    return 0;
}
