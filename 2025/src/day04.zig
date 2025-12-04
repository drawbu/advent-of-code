const std = @import("std");
const utils = @import("utils.zig");

fn roll(char: u8) usize {
    return if (char == '@') 1 else 0;
}

fn line_sum(line: []const u8, x: usize) usize {
    return (if (x != 0) roll(line[x - 1]) else 0) +
        roll(line[x]) +
        (if (x != line.len - 1) roll(line[x + 1]) else 0);
}

fn count(grid: []const []const u8, y: usize, x: usize) bool {
    return (grid[y][x] == '@') and ((if (y != 0) line_sum(grid[y - 1], x) else 0) +
        line_sum(grid[y], x) +
        (if (y != grid.len - 1) line_sum(grid[y + 1], x) else 0) <= 4);
}

pub fn solution(alloc: std.mem.Allocator, file_content: []const u8) !utils.AOCSolution {
    var sol = utils.AOCSolution{ .part1 = 0, .part2 = 0 };

    var grid: std.ArrayList([]u8) = .empty;
    defer {
        for (grid.items) |l|
            alloc.free(l);
        grid.deinit(alloc);
    }
    var it = std.mem.splitAny(u8, file_content, "\n");
    while (it.next()) |line|
        try grid.append(alloc, try alloc.dupe(u8, line));

    // part 1
    for (0.., grid.items) |y, line| {
        for (0.., line) |x, _| {
            if (count(grid.items, y, x)) sol.part1 += 1;
        }
    }

    // part 2
    var sum: usize = 1;
    while (sum > 0) {
        sum = 0;
        for (0.., grid.items) |y, line| {
            for (0.., line) |x, _| {
                if (count(grid.items, y, x)) {
                    sum += 1;
                    grid.items[y][x] = '.';
                }
            }
        }
        sol.part2 += sum;
    }

    return sol;
}

test "test input" {
    const test_input =
        \\..@@.@@@@.
        \\@@@.@.@.@@
        \\@@@@@.@.@@
        \\@.@@@@..@.
        \\@@.@@@@.@@
        \\.@@@@@@@.@
        \\.@.@.@.@@@
        \\@.@@@.@@@@
        \\.@@@@@@@@.
        \\@.@.@@@.@.
    ;
    const sol = try solution(std.testing.allocator, test_input);

    try std.testing.expectEqual(13, sol.part1);
    try std.testing.expectEqual(43, sol.part2);
}

test "actual input" {
    const sol = try solution(std.testing.allocator, @embedFile("input/day04.txt"));

    try std.testing.expectEqual(1367, sol.part1);
    try std.testing.expectEqual(9144, sol.part2);
}
