#ifndef AOC_H_
    #define AOC_H_

    #include <stddef.h>

    #define SOL(day_num, type, part_num) {                \
        .name = "day" #day_num "-" "part" #part_num,      \
        .input = "./day" #day_num "/input_" #type ".txt", \
        .func = &(day ## day_num ## _part ## part_num),   \
    }
    #define DAY(day_num)       \
        SOL(day_num, full, 1), \
        SOL(day_num, full, 2)

    #define READFILE(__filename, __linebuf, code)       \
        FILE *__fp = fopen(__filename, "r");            \
        size_t __len = BUFSIZ;                          \
        __linebuf = malloc(BUFSIZ);                     \
        while (getline(&__linebuf, &__len, __fp) != -1) \
        code                                            \
        free(__linebuf);                                \
        fclose(__fp);

typedef struct {
    char *name;
    char *input;
    void (*func)(char const *);
} solution_t;

void day01_part1(char const *filename);
void day01_part2(char const *filename);

void day02_part1(char const *filename);
void day02_part2(char const *filename);

static const solution_t SOLUTIONS[] = {
    DAY(01),
    DAY(02),
    { 0 },
};

#endif /* AOC_H_ */
