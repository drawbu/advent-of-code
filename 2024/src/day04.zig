const std = @import("std");
const utils = @import("utils.zig");

fn is_word(word: []const u8, grid: [][]const u8, x: usize, y: usize, dir_x: i32, dir_y: i32) bool {
    for (0.., word) |i, letter|
        if (grid[@as(usize, @bitCast(@as(i64, @bitCast(y)) + @as(i64, @bitCast(i)) * dir_y))][@as(usize, @bitCast(@as(i64, @bitCast(x)) + @as(i64, @bitCast(i)) * dir_x))] != letter)
            return false;
    return true;
}

pub fn solution(alloc: std.mem.Allocator) !utils.AOCSolution {
    const file = @embedFile("input/day04.txt");
    var sol = utils.AOCSolution{ .part1 = 0, .part2 = 0 };

    var grid = std.ArrayList([]const u8).init(alloc);
    defer grid.deinit();
    var it = std.mem.splitAny(u8, file, "\n");
    while (it.next()) |line|
        try grid.append(line);

    // Part 1
    for (0.., grid.items) |y, line| {
        // Lines
        sol.part1 += std.mem.count(u8, line, "XMAS");
        sol.part1 += std.mem.count(u8, line, "SAMX");

        if (y + 4 < grid.items.len) {
            // vertical
            for (0..grid.items.len - 1) |x| {
                if (is_word("XMAS", grid.items, x, y, 0, 1))
                    sol.part1 += 1;
                if (is_word("SAMX", grid.items, x, y, 0, 1))
                    sol.part1 += 1;
            }
            // diagonal
            for (0..grid.items.len - 4) |x| {
                if (is_word("XMAS", grid.items, x, y, 1, 1))
                    sol.part1 += 1;
                if (is_word("SAMX", grid.items, x, y, 1, 1))
                    sol.part1 += 1;
            }
            for (3..grid.items.len - 1) |x| {
                if (is_word("XMAS", grid.items, x, y, -1, 1))
                    sol.part1 += 1;
                if (is_word("SAMX", grid.items, x, y, -1, 1))
                    sol.part1 += 1;
            }
        }
    }

    // Part 2
    for (1..grid.items.len - 2) |y| {
        for (1..grid.items.len - 2) |x| {
            if (grid.items[y][x] == 'A' and grid.items[y - 1][x - 1] == 'M' and grid.items[y - 1][x + 1] == 'S' and grid.items[y + 1][x - 1] == 'M' and grid.items[y + 1][x + 1] == 'S')
                sol.part2 += 1;
            if (grid.items[y][x] == 'A' and grid.items[y - 1][x - 1] == 'S' and grid.items[y - 1][x + 1] == 'M' and grid.items[y + 1][x - 1] == 'S' and grid.items[y + 1][x + 1] == 'M')
                sol.part2 += 1;
            if (grid.items[y][x] == 'A' and grid.items[y - 1][x - 1] == 'M' and grid.items[y - 1][x + 1] == 'M' and grid.items[y + 1][x - 1] == 'S' and grid.items[y + 1][x + 1] == 'S')
                sol.part2 += 1;
            if (grid.items[y][x] == 'A' and grid.items[y - 1][x - 1] == 'S' and grid.items[y - 1][x + 1] == 'S' and grid.items[y + 1][x - 1] == 'M' and grid.items[y + 1][x + 1] == 'M')
                sol.part2 += 1;
        }
    }

    return sol;
}

test {
    const sol = try solution(std.testing.allocator);

    try std.testing.expectEqual(2514, sol.part1);
    try std.testing.expectEqual(1888, sol.part2);
}
