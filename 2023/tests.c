#include <criterion/criterion.h>
#include <criterion/redirect.h>

#include "aoc.h"

#define AOC_TEST(day_num, part_num, input_file, expected)              \
    Test(day ## day_num, part ## part_num, .init=cr_redirect_stdout) { \
        day01_part2("day" #day_num "/input_" #input_file ".txt");      \
                                                                       \
        setbuf(stdout, NULL);                                          \
        cr_assert_stdout_eq_str(#expected "\n");                       \
    }

// Day 01
AOC_TEST(01, 1, test1, 142)
AOC_TEST(01, 2, test2, 281)
