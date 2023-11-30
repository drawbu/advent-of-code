#ifndef AOC_H_
    #define AOC_H_

    #include <stddef.h>

    #define SOL(day_num, type, part_num) (solution_t){ \
        .name = "day" #day_num "-" "part" #part_num, \
        .input = "./day" #day_num "/input_" #type ".txt", \
        .func = &(day ## day_num ## part ## part_num), \
    }
    #define DAY(day_num) \
        SOL(day_num, test, 1), \
        SOL(day_num, full, 1), \
        SOL(day_num, test, 2), \
        SOL(day_num, full, 2)

typedef struct {
    char *name;
    char *input;
    void (*func)(char *);
} solution_t;

void foo(char *);

static solution_t SOLUTIONS[] = {
    { 0 },
};

#endif /* AOC_H_ */
