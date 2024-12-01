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

pub fn day01(alloc: std.mem.Allocator) !utils.aocSolution {
    var file = try std.fs.cwd().openFile("input/day01.txt", .{});
    defer file.close();

    var leftColumn = try std.ArrayList(i32).initCapacity(alloc, 1000);
    defer leftColumn.deinit();

    var rightColumn = try std.ArrayList(i32).initCapacity(alloc, 1000);
    defer rightColumn.deinit();

    var buf: [1024]u8 = undefined;
    var reader = file.reader();
    while (try reader.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        const left = try std.fmt.parseInt(i32, line[0..5], 10);
        try leftColumn.append(left);

        const right = try std.fmt.parseInt(i32, line[8..13], 10);
        try rightColumn.append(right);
    }

    std.mem.sort(i32, leftColumn.items, {}, comptime std.sort.asc(i32));
    std.mem.sort(i32, rightColumn.items, {}, comptime std.sort.asc(i32));

    var part1: usize = 0;
    for (leftColumn.items, rightColumn.items) |left, right| {
        part1 += @as(u32, @abs(left - right));
    }

    var part2: usize = 0;
    for (leftColumn.items) |item| {
        part2 += @as(u32, @bitCast(item)) * count(i32, rightColumn.items, item);
    }

    return .{ .part1 = part1, .part2 = part2 };
}
