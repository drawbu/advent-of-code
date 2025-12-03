const std = @import("std");
const utils = @import("utils.zig");

fn joltage(bank: []const u8, size: usize) usize {
    if (size == 0) return 0;
    const idx = std.mem.indexOfMax(u8, bank[0 .. bank.len - size + 1]);
    return (bank[idx] - '0') * std.math.pow(usize, 10, size - 1) + joltage(bank[idx + 1 ..], size - 1);
}

pub fn solution(_: std.mem.Allocator, file_content: []const u8) !utils.AOCSolution {
    var sol = utils.AOCSolution{ .part1 = 0, .part2 = 0 };
    var file = std.io.fixedBufferStream(file_content);

    var buf: [1024]u8 = undefined;
    var reader = file.reader();
    while (try reader.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        sol.part1 += joltage(line, 2);
        sol.part2 += joltage(line, 12);
    }
    return sol;
}

test "test input" {
    const test_input =
        \\987654321111111
        \\811111111111119
        \\234234234234278
        \\818181911112111
    ;
    const sol = try solution(std.testing.allocator, test_input);

    try std.testing.expectEqual(357, sol.part1);
    try std.testing.expectEqual(3121910778619, sol.part2);
}

test "actual input" {
    const sol = try solution(std.testing.allocator, @embedFile("input/day03.txt"));

    try std.testing.expectEqual(17324, sol.part1);
    try std.testing.expectEqual(171846613143331, sol.part2);
}
