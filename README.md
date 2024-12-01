# advent-of-code

My solutions for the [advent of code](https://adventofcode.com).


## 2024 - :zap: Zig

Lets learn Zig this time!


## 2023 - C

Completed: `6/25`.

The structure of the project:
```sh
2023/
  |__Makefile
  |__main.c
  |__aoc.h
  |__tests.c
  |__day-{n}/
    |__source.c
    |__input_full.txt
    |__input_test{n}.txt
```
To run my solutions:
```sh
make
./aoc2023             # run all
./aoc2023 day08-part2 # run a specific solution
```


## 2022 - Go

Completed: `9/25`.

I made it to the day 9, and choose to discover Go with it. Pretty fun
experience.


## :snowflake: Nix

I use Nix to manage my dev environments, so you can build and run all years
binaries with nix:
```sh
# $YEAR = 2022, 2023, 2024, etc.
nix run github:drawbu/advent-of-code#${YEAR}     # run solutions
nix develop github:drawbu/advent-of-code#${YEAR} # enter dev env
```
