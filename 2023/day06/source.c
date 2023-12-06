#include <stdbool.h>
#include <sys/param.h>

#include "aoc.h"

typedef struct {
    long time;
    long distance;
} race_t;

static
race_t *get_races(char **map)
{
    race_t *races = malloc(10 * sizeof(race_t));
    if (races == NULL || map == NULL)
        return NULL;
    char *time = strchr(map[0], ':');
    char *distance = strchr(map[1], ':');
    int i = 0;
    for (; true; i++) {
        for (; *time && !isdigit(*time); time++);
        for (; *distance && !isdigit(*distance); distance++);
        if (!*time || !*distance)
            break;
        races[i] = (race_t){ strpnum(&time), strpnum(&distance) };
    }
    races[i] = (race_t){ 0 };
    return races;
}

static
long get_distance(long time, long press)
{
    return (time - press) * press;
}

static
long get_winning_press(race_t const *race)
{
    long res = 0;
    bool started = false;

    for (long i = 0; i < race->time; i++) {
        long tmp = get_distance(race->time, i);
        if (tmp <= race->distance) {
            if (started)
                break;
            continue;
        }
        res += 1;
        started = true;
    }
    return res;
}

static
long get_awful_num(char *str)
{
    long ret = 0;

    for (; *str; str++) {
        if (!isdigit(*str))
            continue;
        ret *= 10;
        ret += *str - '0';
    }
    return ret;
}

void day06(char const *filename)
{
    char **map = get_full_file(filename);
    race_t *races = get_races(map);
    if (races == NULL)
        return;
    race_t race2 = (race_t) {
        .time = get_awful_num(strchr(map[0], ':')),
        .distance = get_awful_num(strchr(map[1], ':')),
    };
    long part1 = 1;
    long part2 = 1;

    for (int i = 0; races[i].distance; i++)
        part1 *= get_winning_press(&races[i]);
    printf("%ld %ld\n", race2.distance, race2.time);
    part2 = get_winning_press(&race2);
    printf("part 1: %ld, part 2: %ld\n", part1, part2);
    free(races);
    for (int j = 0; map[j] != NULL; j++)
        free(map[j]);
    free(map);
}
