const std = @import("std");

pub const AOCSolution = struct {
    part1: usize,
    part2: usize,
};

pub const AOCInput = struct {
    items: [][]u8,
    alloc: std.mem.Allocator,
    raw: []u8,

    pub fn init(alloc: std.mem.Allocator, raw: []const u8) !AOCInput {
        var grid: std.ArrayList([]u8) = .empty;
        try grid.ensureTotalCapacity(alloc, std.mem.count(u8, raw, "\n") + 1);

        const duped = try alloc.dupe(u8, raw);
        var it = std.mem.splitAny(u8, duped, "\n");
        while (it.next()) |line|
            grid.appendAssumeCapacity(@constCast(line));

        return AOCInput{
            .items = try grid.toOwnedSlice(alloc),
            .alloc = alloc,
            .raw = duped,
        };
    }

    pub fn deinit(self: *AOCInput) void {
        self.alloc.free(self.raw);
        self.alloc.free(self.items);
    }
};
