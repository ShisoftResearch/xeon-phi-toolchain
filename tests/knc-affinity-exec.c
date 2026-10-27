#define _GNU_SOURCE
#include <sched.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

int main(int argc, char ** argv) {
    if (argc < 3 || strncmp(argv[1], "0x", 2)) return 2;
    cpu_set_t mask;
    CPU_ZERO(&mask);
    const size_t n = strlen(argv[1]);
    if (n < 3 || n > 2 + CPU_SETSIZE / 4) return 2;
    unsigned bits = 0;
    for (size_t i = 2; i < n; ++i) {
        const char c = argv[1][i];
        const int value = c >= '0' && c <= '9' ? c - '0' : c >= 'a' && c <= 'f' ? c - 'a' + 10 : -1;
        if (value < 0) return 2;
        for (unsigned j = 0; j < 4; ++j) {
            if ((value >> j) & 1) { CPU_SET((n - 1 - i) * 4 + j, &mask); ++bits; }
        }
    }
    if (!bits || sched_setaffinity(0, sizeof(mask), &mask)) return 3;
    execv(argv[2], argv + 2);
    perror("execv");
    return 4;
}
