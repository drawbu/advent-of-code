const std = @import("std");
const day01 = @import("day01.zig");

pub fn main() !void {
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    var gpa = std.heap.GeneralPurposeAllocator(.{
        .safety = true,
    }){};
    defer {
        if (gpa.deinit() == std.heap.Check.leak) {
            std.debug.print("Mem leaks detected\n", .{});
        }
    }
    const allocator = gpa.allocator();

    try stdout.print("part01: {any}\n", .{try day01.day01(allocator)});

    try bw.flush(); // don't forget to flush!
}
