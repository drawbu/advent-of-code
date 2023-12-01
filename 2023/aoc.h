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

    #define READFILE(filename, code)           \
        FILE *fp = fopen(filename, "r");       \
        char *line;                            \
        size_t len = 0;                        \
        while (getline(&line, &len, fp) != -1) \
        code                                   \
        fclose(fp);

typedef struct {
    char *name;
    char *input;
    void (*func)(char const *);
} solution_t;

void day01_part1(char const *filename);
void day01_part2(char const *filename);

static const solution_t SOLUTIONS[] = {
    DAY(01),
    { 0 },
};

#endif /* AOC_H_ */
