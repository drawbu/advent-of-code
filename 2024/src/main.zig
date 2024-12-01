const std = @import("std");
const day01 = @import("day01.zig");
const utils = @import("utils.zig");

pub fn main() !void {
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    inline for (1.., [_]?*const fn (std.mem.Allocator) anyerror!utils.AOCSolution{
        day01.day01,
    }) |i, day| {
        if (day) |func| {
            try stdout.print("day{d:02}: {any}\n", .{ i, try func(allocator) });
        } else {
            try stdout.print("day{d:02}: skipped\n", .{i});
        }
    }

    try bw.flush();
}
