#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "aoc.h"

int main(int argc, char **argv)
{
    for (int i = 0; SOLUTIONS[i].name != NULL; i++) {
        if (argc > 1 && strcmp(argv[1], SOLUTIONS[i].name) != 0)
            continue;
        if (argc == 1)
            printf("%s: \x1b[33m", SOLUTIONS[i].name);
        SOLUTIONS[i].func((argc > 2) ? argv[2] : SOLUTIONS[i].input);
        printf("\x1b[0m");
    }
    return EXIT_SUCCESS;
}
