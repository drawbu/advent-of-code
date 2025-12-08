const std = @import("std");

pub const AOCSolution = struct {
    part1: usize,
    part2: usize,
};

pub const AOCInput = struct {
    items: [][]u8,
    width: usize,
    height: usize,

    alloc: std.mem.Allocator,
    raw: []u8,

    pub fn init(alloc: std.mem.Allocator, raw: []const u8) !AOCInput {
        const duped = try alloc.dupe(u8, raw);
        errdefer alloc.free(duped);

        var items = try alloc.alloc([]u8, std.mem.count(u8, raw, "\n") + 1);
        errdefer alloc.free(items);
        {
            var it = std.mem.splitAny(u8, duped, "\n");
            var i: usize = 0;
            while (it.next()) |line| : (i += 1)
                items[i] = @constCast(line);
        }

        return AOCInput{
            .items = items,
            .height = items.len,
            .width = items[0].len,

            .alloc = alloc,
            .raw = duped,
        };
    }

    pub fn deinit(self: *AOCInput) void {
        self.alloc.free(self.raw);
        self.alloc.free(self.items);
    }
};
