#include <err.h>
#include <stdio.h>

int main(int argc, char* argv[]) {
    if (argc != 2) {
        errx(1, "error: file name as argument required");
    }
    FILE *fp;
    if (!(fp = fopen(argv[1], "rb"))) {
        err(2, "error: ");
    }
    double r, theta;
    while (!feof(fp)) {
        fread(&r, sizeof(double), 1, fp);
        fread(&theta, sizeof(double), 1, fp);
        printf("%27.15e%27.15e\n", r, theta);
    }
    fclose(fp);
    return 0;
}
