const std = @import("std");
const utils = @import("utils.zig");

pub const solutions = [_]?*const fn (std.mem.Allocator) anyerror!utils.AOCSolution{
    @import("day01.zig").solution,
    @import("day02.zig").solution,
    @import("day03.zig").solution,
    @import("day04.zig").solution,
    @import("day05.zig").solution,
    @import("day06.zig").solution,
    @import("day07.zig").solution,
    @import("day08.zig").solution,
    @import("day09.zig").solution,
};

fn get_day() !?u8 {
    var args = std.process.args();
    if (!args.skip())
        return null;
    if (args.next()) |arg|
        return try std.fmt.parseInt(u8, arg, 10);
    return null;
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    if (try get_day()) |day| {
        if (day == 0 or day > solutions.len)
            return;
        if (solutions[day - 1]) |func|
            try stdout.print("day{d:0>2}: {any}\n", .{ day, try func(allocator) });
        return;
    }

    inline for (1.., solutions) |i, day| {
        if (day) |func| {
            try stdout.print("day{d:0>2}: {any}\n", .{ i, try func(allocator) });
        } else {
            try stdout.print("day{d:0>2}: skipped\n", .{i});
        }
    }
}
