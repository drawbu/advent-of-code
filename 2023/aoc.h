#ifndef AOC_H_
    #define AOC_H_

    #include <ctype.h>
    #include <stddef.h>
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    #define SOL(day_num, type, part_num) {                \
        .name = "day" #day_num "-" "part" #part_num,      \
        .input = "./day" #day_num "/input_" #type ".txt", \
        .func = &(day ## day_num ## _part ## part_num),   \
    }
    #define SOLS(day_num)       \
        SOL(day_num, full, 1), \
        SOL(day_num, full, 2)

    #define DAY(day_num, type) { \
        .name = "day" #day_num,      \
        .input = "./day" #day_num "/input_" #type ".txt", \
        .func = &(day ## day_num),   \
    }

    #define READFILE(__filename, __linebuf, __err, code)       \
        FILE *__fp = fopen(__filename, "r");            \
        if (__fp == NULL) {                             \
            perror("fopen");                            \
            return __err;                               \
        }                                               \
        size_t __len = BUFSIZ;                          \
        __linebuf = malloc(BUFSIZ);                     \
        if (__linebuf == NULL) {                        \
            perror("malloc");                           \
            fclose(__fp);                               \
            return __err;                               \
        }                                               \
        while (getline(&__linebuf, &__len, __fp) != -1) \
        code                                            \
        free(__linebuf);                                \
        fclose(__fp);

static inline
long strpnum(char **ptr)
{
    if (!isdigit(**ptr))
        return 0;
    char *endptr = *ptr;
    for (; isdigit(*endptr); endptr++);
    long ret = strtol(*ptr, &endptr, 10);
    *ptr = endptr;
    return ret;
}

static inline
char **get_full_file(char const *filename)
{
    char **lines = NULL;
    void *ptr = NULL;
    char *line;
    int i = 0;

    READFILE(filename, line, NULL, {
        ptr = realloc(lines, (i + 2) * sizeof(char *));
        if (ptr == NULL)
            break;
        lines = ptr;
        lines[i] = malloc(strlen(line) + 1);
        if (lines[i] == NULL)
            break;
        lines[i + 1] = NULL;
        strcpy(lines[i], line);
        i += 1;
    })
    return lines;
}

typedef struct {
    char *name;
    char *input;
    void (*func)(char const *);
} solution_t;

void day01_part1(char const *filename);
void day01_part2(char const *filename);

void day02_part1(char const *filename);
void day02_part2(char const *filename);

void day03_part1(char const *filename);
void day03_part2(char const *filename);

void day04_part1(char const *filename);
void day04_part2(char const *filename);

void day06(char const *filename);

static const solution_t SOLUTIONS[] = {
    SOLS(01),
    SOLS(02),
    SOLS(03),
    SOLS(04),
    DAY(06, full),
    { 0 },
};

#endif /* AOC_H_ */
