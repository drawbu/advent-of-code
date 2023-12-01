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
        int n;
        char *ptr = line;
        for (; !isdigit(*ptr) && *ptr != '\0'; ptr++);
        if (*ptr == '\0')
            continue;
        n = *ptr - '0';
        int tmp = 0;
        for (size_t i = 0; line[i]; i++) {
            if (!isdigit(line[i]))
                continue;
            tmp = line[i] - '0';
        }
        n = (n * 10) + tmp;
        sum += n;
    })
    printf("%d\n", sum);
}

static const struct {
    char *word;
    int value;
} LETTERS[] = {
    { "one", 1 },
    { "two", 2 },
    { "three", 3 },
    { "four", 4 },
    { "five", 5 },
    { "six", 6 },
    { "seven", 7 },
    { "eight", 8 },
    { "nine", 9 },
    { 0 },
};

static
int get_nbr(char const *str)
{
    if (isdigit(*str))
        return *str - '0';
    for (size_t i = 0; LETTERS[i].word != NULL; i++) {
        if (strncmp(LETTERS[i].word, str, strlen(LETTERS[i].word)) == 0)
            return LETTERS[i].value;
    }
    return INT_MAX;
}

void day01_part2(char const *filename)
{
    char *line;
    int sum = 0;

    READFILE(filename, line, {
        int n;
        char *ptr = line;
        int tmp = 0;
        for (; *ptr != '\0'; ptr++) {
            tmp = get_nbr(ptr);
            if (tmp != INT_MAX)
                break;
        }
        n = tmp;
        if (*ptr == '\0')
            continue;
        tmp = 0;
        int tmp2 = 0;
        for (size_t i = 0; line[i]; i++) {
            tmp2 = get_nbr(line + i);
            if (tmp2 == INT_MAX)
                continue;
            tmp = tmp2;
        }
        n = (n * 10) + tmp;
        sum += n;
    })
    printf("%d\n", sum);
}
