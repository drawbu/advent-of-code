#include <ctype.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/param.h>

#include "aoc.h"

static
long read_num(char **ptr)
{
    long val;
    for (; **ptr && !isdigit(**ptr); (*ptr)++);
    if (**ptr == '\0')
        return 0;
    char *endptr = *ptr;
    for (; *endptr && isdigit(*endptr); endptr++);
    val = strtol(*ptr, &endptr, 10);
    *ptr = (endptr) ? endptr + 1 : endptr;
    return val;
}

static
bool is_valid(char const *ptr, long value)
{
    switch (*ptr) {
        case 'r': return value <= 12;
        case 'g': return value <= 13;
        case 'b': return value <= 14;
        default: return false;
    }
}

void day02_part1(char const *filename)
{
    char *line;
    size_t line_num = 0;
    size_t result = 0;

    READFILE(filename, line, {
        char *ptr = line;
        bool valid = true;
        for (; *ptr && *ptr != ':'; ptr++);
        if (*ptr == '\0')
            break;
        while (*ptr) {
            long val = read_num(&ptr);
            if (val == 0)
                break;
            if (!is_valid(ptr, val)) {
                valid = false;
                break;
            }
        }
        if (valid)
            result += line_num + 1;
        line_num++;
    })
    printf("%zu\n", result);
}

static
void set_cubes(char const *ptr, long val, size_t cubes[3])
{
    switch (*ptr) {
        case 'r':
            cubes[0] = MAX((long)cubes[0], val);
            return;
        case 'g':
            cubes[1] = MAX((long)cubes[1], val);
            return;
        case 'b':
            cubes[2] = MAX((long)cubes[2], val);
            return;
        default: return;
    }
}

void day02_part2(char const *filename)
{
    char *line;
    size_t result = 0;

    READFILE(filename, line, {
        char *ptr = line;
        size_t cubes[3] = { 0 };
        for (; *ptr && *ptr != ':'; ptr++);
        if (*ptr == '\0')
            break;
        while (*ptr) {
            long val = read_num(&ptr);
            if (val == 0)
                break;
            set_cubes(ptr, val, cubes);
        }
        result += cubes[0] * cubes[1] * cubes[2];
    })
    printf("%zu\n", result);
}
