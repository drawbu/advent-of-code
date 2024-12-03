const std = @import("std");
const utils = @import("utils.zig");

fn find_non_digit(slice: []u8, item: u8) ?usize {
    for (0..slice.len) |i|
        switch (slice[i]) {
            '0'...'9' => continue,
            else => return if (slice[i] == item) i else null,
        };
    return null;
}

pub fn solution(_: std.mem.Allocator) !utils.AOCSolution {
    var file = std.io.fixedBufferStream(@embedFile("input/day03.txt"));
    var sol = utils.AOCSolution{ .part1 = 0, .part2 = 0 };

    var enabled = true;

    var buf: [4096]u8 = undefined;
    var reader = file.reader();
    while (try reader.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var ptr = line[0..];
        while (ptr.len != 0) {
            defer ptr = ptr[1..];
            if (!std.mem.startsWith(u8, ptr, "mul(")) {
                if (std.mem.startsWith(u8, ptr, "do()")) {
                    enabled = true;
                } else if (std.mem.startsWith(u8, ptr, "don't()")) {
                    enabled = false;
                }
                continue;
            }
            ptr = ptr[4..];

            var idx = find_non_digit(ptr[0..4], ',') orelse continue;
            const n1 = try std.fmt.parseInt(u32, ptr[0..idx], 10);
            ptr = ptr[idx + 1 ..];

            idx = find_non_digit(ptr[0..4], ')') orelse continue;
            const n2 = try std.fmt.parseInt(u32, ptr[0..idx], 10);
            ptr = ptr[idx..];

            sol.part1 += n1 * n2;
            if (enabled)
                sol.part2 += n1 * n2;
        }
    }

    return sol;
}

test {
    const sol = try solution(std.testing.allocator);

    try std.testing.expectEqual(173419328, sol.part1);
    try std.testing.expectEqual(90669332, sol.part2);
}
