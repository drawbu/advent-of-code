const std = @import("std");
const utils = @import("utils.zig");

fn count(comptime T: type, array: []T, value: T) usize {
    var result: usize = 0;
    for (array) |item| {
        if (item == value) {
            result += 1;
        }
    }
    return result;
}

pub fn day01(alloc: std.mem.Allocator) !utils.AOCSolution {
    var file = try std.fs.cwd().openFile("input/day01.txt", .{});
    defer file.close();

    var leftColumn = try std.ArrayList(u31).initCapacity(alloc, 1000);
    defer leftColumn.deinit();

    var rightColumn = try std.ArrayList(u31).initCapacity(alloc, 1000);
    defer rightColumn.deinit();

    var buf: [1024]u8 = undefined;
    var reader = file.reader();
    while (try reader.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        const left = try std.fmt.parseInt(u31, line[0..5], 10);
        try leftColumn.append(left);

        const right = try std.fmt.parseInt(u31, line[8..13], 10);
        try rightColumn.append(right);
    }

    std.mem.sort(u31, leftColumn.items, {}, comptime std.sort.asc(u31));
    std.mem.sort(u31, rightColumn.items, {}, comptime std.sort.asc(u31));

    var part1: usize = 0;
    for (leftColumn.items, rightColumn.items) |left, right|
        part1 += @abs(@as(i32, left) - @as(i32, right));

    var part2: usize = 0;
    for (leftColumn.items) |item|
        part2 += item * count(u31, rightColumn.items, item);

    return .{ .part1 = part1, .part2 = part2 };
}
