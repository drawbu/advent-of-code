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
            printf("%s:\n", SOLUTIONS[i].name);
        SOLUTIONS[i].func(SOLUTIONS[i].input);
    }
    return EXIT_SUCCESS;
}
