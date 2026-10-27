#define _GNU_SOURCE
#include <stdint.h>
#include <stdio.h>
#include <sys/mman.h>
#include <unistd.h>

static void hint(const void * p) {
    __asm__ volatile(".byte 0xc5, 0xf8, 0x18, 0x08" : : "a"(p));
}

int main(void) {
    const size_t page = sysconf(_SC_PAGESIZE);
    uint8_t * p = mmap(0, page * 3, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    if (p == MAP_FAILED || mprotect(p + page, page, PROT_READ | PROT_WRITE)) return 2;
    for (size_t i = 0; i < page; ++i) p[page + i] = (uint8_t)(i * 37);
    unsigned count = 0;
    for (unsigned trial = 0; trial < 32; ++trial) {
        for (size_t i = 0; i < page * 3; ++i) {
            hint(p + i);
            ++count;
        }
    }
    for (size_t i = 0; i < page; ++i) if (p[page + i] != (uint8_t)(i * 37)) return 1;
    munmap(p, page * 3);
    printf("PASS native vprefetch0: %u hints, all page offsets, protected pages, unchanged data\n", count);
    return 0;
}
