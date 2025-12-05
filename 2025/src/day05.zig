const std = @import("std");
const utils = @import("utils.zig");

inline fn between(comptime T: type, value: T, from: T, to: T) bool {
    return value >= from and value <= to;
}

pub fn solution(alloc: std.mem.Allocator, file_content: []const u8) !utils.AOCSolution {
    var sol = utils.AOCSolution{ .part1 = 0, .part2 = 0 };
    var input = try utils.AOCInput.init(alloc, file_content);
    defer input.deinit();

    var ranges: std.ArrayList(struct {
        from: usize,
        to: usize,
        active: bool,
    }) = .empty;
    defer ranges.deinit(alloc);

    var is_ranges = true;
    for (input.items) |line| {
        if (line.len == 0) {
            is_ranges = false;
        } else if (is_ranges) {
            // parsing ranges
            var it = std.mem.splitScalar(u8, line, '-');
            const from = try std.fmt.parseInt(usize, it.next() orelse continue, 10);
            const to = try std.fmt.parseInt(usize, it.next() orelse continue, 10);
            try ranges.append(alloc, .{ .from = from, .to = to, .active = true });
        } else {
            // part 1
            const ingredient = try std.fmt.parseInt(usize, line, 10);
            for (ranges.items) |range| {
                if (between(usize, ingredient, range.from, range.to)) {
                    sol.part1 += 1;
                    break;
                }
            }
        }
    }

    // part 2
    for (ranges.items) |*range| {
        for (ranges.items) |*range2| {
            if (!range2.active or range == range2) continue;
            if (!between(usize, range.from, range2.from, range2.to) and
                !between(usize, range.to, range2.from, range2.to))
                continue;

            range.active = false;
            range2.from = @min(range2.from, range.from);
            range2.to = @max(range2.to, range.to);
        }
        if (range.active)
            sol.part2 += range.to - range.from + 1;
    }

    return sol;
}

test "test input" {
    const test_input =
        \\3-5
        \\10-14
        \\16-20
        \\12-18
        \\
        \\1
        \\5
        \\8
        \\11
        \\17
        \\32
    ;
    const sol = try solution(std.testing.allocator, test_input);

    try std.testing.expectEqual(3, sol.part1);
    try std.testing.expectEqual(14, sol.part2);
}

test "actual input" {
    const sol = try solution(std.testing.allocator, @embedFile("input/day05.txt"));

    try std.testing.expectEqual(770, sol.part1);
    try std.testing.expectEqual(357674099117260, sol.part2);
}
