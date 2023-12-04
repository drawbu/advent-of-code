#include <criterion/criterion.h>
#include <criterion/redirect.h>

#include "aoc.h"

#define AOC_TEST(day_num, part_num, input_file, expected)              \
    Test(day ## day_num, part ## part_num, .init=cr_redirect_stdout) { \
        day ##day_num ## _part ## part_num ("day" #day_num "/input_" #input_file ".txt");      \
                                                                       \
        setbuf(stdout, NULL);                                          \
        cr_assert_stdout_eq_str(#expected "\n");                       \
    }

// Day 01
AOC_TEST(01, 1, test1, 142)
AOC_TEST(01, 2, test2, 281)

// Day 02
AOC_TEST(02, 1, test, 8)
AOC_TEST(02, 2, test, 2286)

// Day 03
AOC_TEST(03, 1, test, 4361)
AOC_TEST(03, 2, test, 467835)

// Day 04
AOC_TEST(04, 1, test, 13)
AOC_TEST(04, 2, test, 30)
