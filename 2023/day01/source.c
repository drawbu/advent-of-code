#include <ctype.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "aoc.h"

void day01_part1(char const *filename)
{
    char *line;
    int sum = 0;

    READFILE(filename, line, {
        char *ptr = line;
        for (; !isdigit(*ptr) && *ptr != '\0'; ptr++);
        if (*ptr == '\0')
            continue;
        sum += (*ptr - '0') * 10;
        for (ptr = line + strlen(line); !isdigit(*ptr); ptr--);
        sum += *ptr - '0';
    })
    printf("%d\n", sum);
}

static const char *NUM[] = {
    "one", "two", "three", "four", "five",
    "six", "seven", "eight", "nine", NULL
};

static
int get_nbr(char const *str)
{
    if (isdigit(*str))
        return *str - '0';
    for (int i = 0; NUM[i] != NULL; i++)
        if (strncmp(NUM[i], str, strlen(NUM[i])) == 0)
            return i + 1;
    return 0;
}

void day01_part2(char const *filename)
{
    char *line;
    int sum = 0;

    READFILE(filename, line, {
        int tmp = 0;
        char *ptr = line;
        for (; *ptr != '\0'; ptr++) {
            tmp = get_nbr(ptr);
            if (tmp != 0)
                break;
        }
        if (*ptr == '\0')
            continue;
        sum += tmp * 10;
        for (ptr = line + strlen(line); ptr + 1 != line; ptr--) {
            tmp = get_nbr(ptr);
            if (tmp != 0)
                break;
        }
        sum += tmp;
    })
    printf("%d\n", sum);
}
