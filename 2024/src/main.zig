const std = @import("std");
const utils = @import("utils.zig");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    inline for (1.., [_]?*const fn (std.mem.Allocator) anyerror!utils.AOCSolution{
        @import("day01.zig").solution,
        @import("day02.zig").solution,
        @import("day03.zig").solution,
        @import("day04.zig").solution,
        @import("day05.zig").solution,
        @import("day06.zig").solution,
    }) |i, day| {
        if (day) |func| {
            try stdout.print("day{d:0>2}: {any}\n", .{ i, try func(allocator) });
        } else {
            try stdout.print("day{d:0>2}: skipped\n", .{i});
        }
    }
}
