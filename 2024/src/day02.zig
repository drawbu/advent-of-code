const std = @import("std");
const utils = @import("utils.zig");

fn is_valid(numbers: []i32) bool {
    const incr = numbers[0] - numbers[1] > 0;
    for (0..numbers.len - 1) |i| {
        const item = numbers[i + 1];
        const last = numbers[i];
        if (last == item or @abs(last - item) > 3 or incr != (last - item > 0))
            return false;
    }
    return true;
}

fn bruteforce_part2(numbers: *const std.ArrayList(i32)) !bool {
    if (is_valid(numbers.items))
        return true;
    for (0..numbers.items.len) |i| {
        var num = try numbers.clone();
        defer num.deinit();
        _ = num.orderedRemove(i);
        if (is_valid(num.items))
            return true;
    }
    return false;
}

pub fn solution(alloc: std.mem.Allocator) !utils.AOCSolution {
    var file = std.io.fixedBufferStream(@embedFile("input/day02.txt"));
    var sol = utils.AOCSolution{ .part1 = 0, .part2 = 0 };

    var buf: [1024]u8 = undefined;
    var reader = file.reader();
    while (try reader.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var numbers = try std.ArrayList(i32).initCapacity(alloc, 1000);
        defer numbers.deinit();

        var it = std.mem.split(u8, line, " ");
        while (it.next()) |n|
            try numbers.append(try std.fmt.parseInt(i32, n, 10));

        if (is_valid(numbers.items))
            sol.part1 += 1;
        if (try bruteforce_part2(&numbers))
            sol.part2 += 1;
    }

    return sol;
}

test {
    const sol = try solution(std.testing.allocator);

    try std.testing.expectEqual(549, sol.part1);
    try std.testing.expectEqual(589, sol.part2);
}
