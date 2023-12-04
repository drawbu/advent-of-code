#include <ctype.h>
#include <math.h>
#include <string.h>

#include "aoc.h"

#define MAXLEN 25

typedef struct {
    size_t len;
    int arr[MAXLEN];
} array_t;

static
void fill_array(array_t *arr, char *line)
{
    for (; *line && *line != '\n' && *line != '|'; line++) {
        if (!isdigit(*line))
            continue;
        char *endptr = line;
        for (; isdigit(*endptr); endptr++);
        arr->arr[arr->len++] = strtol(line, &endptr, 10);
        line = endptr;
    }
}

static
size_t num_winning(array_t const *winning_numbers, array_t const *current)
{
    size_t result = 0;

    for (size_t i = 0; i < winning_numbers->len; i++)
        for (size_t j = 0; j < current->len; j++)
            result += winning_numbers->arr[i] == current->arr[j];
    return result;
}

static
size_t *get_results(char const *filename)
{
    char **map = get_full_file(filename);
    size_t size = 0;

    for (; map[size] != NULL; size++);
    size_t *arr = malloc(sizeof(size_t) * (size + 1));
    for (size_t i = 0; i < size; i++) {
        array_t first_part = {0};
        array_t second_part = {0};
        fill_array(&first_part, strchr(map[i], ':') + 1);
        fill_array(&second_part, strchr(map[i], '|') + 1);
        arr[i] = num_winning(&first_part, &second_part);
    }
    arr[size] = -1;
    for (size_t i = 0; map[i] != NULL; i++)
        free(map[i]);
    free(map);
    return arr;
}

void day04_part1(char const *filename)
{
    size_t res = 0;
    size_t *results = get_results(filename);

    for (size_t i = 0; results[i] != (size_t)-1; i++)
        if (results[i] != 0)
            res += powl(2, (double)(results[i] - 1));
    printf("%zu\n", res);
    free(results);

}

static
size_t process_line(size_t line, size_t *arr)
{
    size_t res = 1;
    for (size_t i = 0; i < arr[line]; i++)
        res += process_line(line + i + 1, arr);
    return res;
}

void day04_part2(char const *filename)
{
    size_t res = 0;
    size_t *results = get_results(filename);

    for (size_t i = 0; results[i] != (size_t)-1; i++)
        res += process_line(i, results);
    printf("%zu\n", res);
    free(results);
}
