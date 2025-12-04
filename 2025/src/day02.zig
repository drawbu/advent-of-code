const std = @import("std");
const utils = @import("utils.zig");

fn cmp(s: []const u8, n: usize) bool {
    if (s.len % n != 0) return false;
    const it = s[0..n];
    for (1..s.len / n) |idx| {
        const rep = s[n * idx .. n * (idx + 1)];
        if (!std.mem.eql(u8, it, rep)) return false;
    }
    return true;
}

pub fn solution(alloc: std.mem.Allocator, file_content: []const u8) !utils.AOCSolution {
    var sol = utils.AOCSolution{ .part1 = 0, .part2 = 0 };
    var input = try utils.AOCInput.init(alloc, file_content);
    defer input.deinit();

    var buf: [32]u8 = undefined;
    var ranges = std.mem.splitAny(u8, input.items[0], ",");
    while (ranges.next()) |range| {
        var it = std.mem.splitAny(u8, range, "-");
        const start =
            try std.fmt.parseInt(usize, it.next() orelse continue, 10);
        const end =
            try std.fmt.parseInt(usize, it.next() orelse continue, 10);

        for (start..end + 1) |i| {
            const num_buffer = try std.fmt.bufPrint(&buf, "{}", .{i});
            if (num_buffer.len % 2 == 0 and cmp(num_buffer, num_buffer.len / 2))
                sol.part1 += i;
            for (1..num_buffer.len / 2 + 1) |div| {
                if (cmp(num_buffer, div)) {
                    sol.part2 += i;
                    break;
                }
            }
        }
    }
    return sol;
}

test "test input" {
    const test_input =
        "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124";
    const sol = try solution(std.testing.allocator, test_input);

    try std.testing.expectEqual(1227775554, sol.part1);
    try std.testing.expectEqual(4174379265, sol.part2);
}

test "actual input" {
    const sol = try solution(std.testing.allocator, @embedFile("input/day02.txt"));

    try std.testing.expectEqual(19574776074, sol.part1);
    try std.testing.expectEqual(25912654282, sol.part2);
}
