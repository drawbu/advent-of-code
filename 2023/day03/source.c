#include <ctype.h>
#include <stdbool.h>
#include <string.h>
#include <unistd.h>

#include "aoc.h"

static
bool is_gear(char c)
{
    return (!isdigit(c) && c != '.' && c != '\n');
}

static
bool check_surrounding(char *const *map, int x, int y)
{
    for (int j = -1; j < 2; j++) {
        if (y + j < 0)
            continue;
        char *line = map[y + j];
        if (line == NULL)
            return false;
        for (int i = -1; i < 2; i++) {
            if (x + i < 0)
                continue;
            if (line[x + i] == '\0')
                break;
            if (is_gear(line[x + i]))
                return true;
        }
    }
    return false;
}

static
void scan_line(char *const *lines, int x, int y, size_t *result)
{
    bool found = false;

    for (; lines[y][x] != '\0' && !isdigit(lines[y][x]); x++);
    char *start = lines[y] + x;
    for (; isdigit(lines[y][x]); x++)
        if (!found && check_surrounding(lines, x, y))
            found = true;
    if (found) {
        char *end = lines[y] + x;
        *result += strtoul(start, &end, 10);
    }
    if (lines[y][x] != '\0')
        scan_line(lines, x, y, result);
}

// Sum all numbers adjacent (vertical, horizontal or diagonal)
// to a symbol in a 2D array.
void day03_part1(char const *filename)
{
    char **lines = get_full_file(filename);
    size_t result = 0;

    for (int y = 0; lines[y] != NULL; y++) {
        int x = 0;
        scan_line(lines, x, y, &result);
    }
    printf("%zu\n", result);
    for (int i = 0; lines[i] != NULL; i++)
        free(lines[i]);
    free(lines);
}

static
size_t add_engine_part(char *const *map, int x, int y)
{
    size_t res = 0;

    for (int j = -1; j < 2; j++) {
        if (y + j < 0)
            continue;
        char *line = map[y + j];
        if (line == NULL)
            return 0;
        for (int i = -1; i < 2; i++) {
            if (x + i < 0 || !isdigit(line[x + i]))
                continue;
            int index = x + i;
            for (; index != 0 && isdigit(line[index]); index--);
            if (index != 0 || !isdigit(line[index]))
                index += 1;
            for (; isdigit(line[x + i]); i++);
            char *end = line + i;
            size_t tmp = strtoul(line + index, &end, 10);
            if (res != 0)
                return res * tmp;
            res = tmp;
        }
    }
    return 0;
}

// Sum the multiplication of two numbers adjacent
// (vertical, horizontal or diagonal) to the same '*' symbol
void day03_part2(char const *filename)
{
    char **lines = get_full_file(filename);
    size_t result = 0;

    for (int y = 0; lines[y] != NULL; y++)
        for (int x = 0; lines[y][x]; x++)
            if (lines[y][x] == '*')
                result += add_engine_part(lines, x, y);

    printf("%zu\n", result);
    for (int i = 0; lines[i] != NULL; i++)
        free(lines[i]);
    free(lines);
}
