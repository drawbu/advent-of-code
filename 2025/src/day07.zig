const std = @import("std");
const utils = @import("utils.zig");

pub fn solution(alloc: std.mem.Allocator, file_content: []const u8) !utils.AOCSolution {
    var sol = utils.AOCSolution{ .part1 = 0, .part2 = 0 };
    var input = try utils.AOCInput.init(alloc, file_content);
    defer input.deinit();

    // (c >> 3) & 3 =>
    // 'S'=1   '.'=0   '^'=1 << 63
    const lookup = [_]usize{ undefined, 0, 1, 1 << 63 };

    var buf = [_]usize{0} ** 300;
    const width = input.items[0].len;
    const line1 = buf[0..width];
    const line2 = buf[width .. width * 2];

    for (input.items[0], line2) |c, *r| r.* = lookup[(c >> 3) & 3];
    for (input.items[1..]) |rline2| {
        std.mem.copyForwards(usize, line1, line2);
        for (rline2, line2) |c, *r| r.* = lookup[(c >> 3) & 3];

        for (line1, 0..) |c, x| {
            if (c != 1 << 63 and c > 0) {
                if (line2[x] == 1 << 63) {
                    line2[x - 1] += c;
                    line2[x + 1] += c;
                    sol.part1 += 1;
                } else {
                    line2[x] += c;
                }
            }
        }
    }

    for (line2) |tile| {
        if (tile != 1 << 63)
            sol.part2 += tile;
    }
    return sol;
}

test "test input" {
    const test_input =
        \\.......S.......
        \\...............
        \\.......^.......
        \\...............
        \\......^.^......
        \\...............
        \\.....^.^.^.....
        \\...............
        \\....^.^...^....
        \\...............
        \\...^.^...^.^...
        \\...............
        \\..^...^.....^..
        \\...............
        \\.^.^.^.^.^...^.
        \\...............
    ;
    const sol = try solution(std.testing.allocator, test_input);

    try std.testing.expectEqual(21, sol.part1);
    try std.testing.expectEqual(40, sol.part2);
}

test "actual input" {
    const sol = try solution(std.testing.allocator, @embedFile("input/day07.txt"));

    try std.testing.expectEqual(1533, sol.part1);
    try std.testing.expectEqual(10733529153890, sol.part2);
}
