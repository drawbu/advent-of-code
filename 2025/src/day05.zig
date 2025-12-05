const std = @import("std");
const utils = @import("utils.zig");

inline fn between(comptime T: type, value: T, from: T, to: T) bool {
    return value >= from and value <= to;
}

pub fn solution(alloc: std.mem.Allocator, file_content: []const u8) !utils.AOCSolution {
    var sol = utils.AOCSolution{ .part1 = 0, .part2 = 0 };
    var input = try utils.AOCInput.init(alloc, file_content);
    defer input.deinit();

    const Range = struct {
        from: usize,
        to: usize,
    };
    var ranges: std.ArrayList(Range) = .{};
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
            try ranges.append(alloc, .{ .from = from, .to = to });
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
    std.mem.sort(Range, ranges.items, {}, struct {
        fn sort(_: void, a: Range, b: Range) bool {
            return a.from < b.from;
        }
    }.sort);
    var last = ranges.items[0];
    for (ranges.items[1..]) |range| {
        if (range.from <= last.to + 1) {
            last.to = @max(last.to, range.to);
        } else {
            sol.part2 += last.to - last.from + 1;
            last = range;
        }
    }
    sol.part2 += last.to - last.from + 1;

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
