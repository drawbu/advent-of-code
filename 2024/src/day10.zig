const std = @import("std");
const utils = @import("utils.zig");

const HikeTrail = enum {
    Start,
    One,
    Two,
    Three,
    Four,
    Five,
    Six,
    Seven,
    Eight,
    End,

    Empty,
};

fn parse_map(alloc: std.mem.Allocator, file: []const u8) !std.ArrayList([]HikeTrail) {
    const width = std.mem.indexOf(u8, file, "\n").?;

    var map = try std.ArrayList([]HikeTrail).initCapacity(alloc, width);
    errdefer map.deinit();

    var it = std.mem.tokenizeAny(u8, file, "\n");
    while (it.next()) |raw_line| {
        var line = try std.ArrayList(HikeTrail).initCapacity(alloc, width);
        for (raw_line) |tile|
            line.appendAssumeCapacity(if (tile >= '0' and tile <= '9')
                @enumFromInt(tile - '0')
            else if (tile == '.') .Empty else unreachable);
        map.appendAssumeCapacity(try line.toOwnedSlice());
    }
    return map;
}

const Coordiates = struct {
    x: i64,
    y: i64,

    inline fn add(self: Coordiates, other: Coordiates) Coordiates {
        return .{ .x = self.x + other.x, .y = self.y + other.y };
    }
};

fn compute(comptime part_1: bool, map: [][]HikeTrail, pos: Coordiates) usize {
    var result: usize = 0;

    const expect: HikeTrail =
        @enumFromInt(@intFromEnum(map[@intCast(pos.y)][@intCast(pos.x)]) + 1);
    for (&[_]Coordiates{
        pos.add(.{ .x = 0, .y = -1 }),
        pos.add(.{ .x = -1, .y = 0 }),
        pos.add(.{ .x = 1, .y = 0 }),
        pos.add(.{ .x = 0, .y = 1 }),
    }) |other| {
        if (other.y >= map.len or other.y < 0)
            continue;
        const line = &map[@intCast(other.y)];
        if (other.x >= line.len or other.x < 0)
            continue;
        const tile = &line.*[@intCast(other.x)];
        if (tile.* != expect)
            continue;
        if (tile.* == .End) {
            if (part_1)
                tile.* = .Empty;
            result += 1;
        } else {
            result += compute(part_1, map, other);
        }
    }
    return result;
}

fn deinit(array: *std.ArrayList([]HikeTrail)) void {
    for (array.items) |l| {
        array.allocator.free(l);
    }
    array.deinit();
}

pub fn solution(alloc: std.mem.Allocator) !utils.AOCSolution {
    const file = @embedFile("input/day10.txt");
    var map = try parse_map(alloc, file);
    defer deinit(&map);

    var sol = utils.AOCSolution{ .part1 = 0, .part2 = 0 };
    for (0.., map.items) |y, line| {
        for (0.., line) |x, _| {
            if (map.items[y][x] == .Start) {
                var m = try map.clone();
                defer deinit(&m);
                for (m.items) |*l| {
                    l.* = try alloc.dupe(HikeTrail, l.*);
                }
                sol.part1 += compute(true, m.items, .{ .x = @intCast(x), .y = @intCast(y) });
                sol.part2 += compute(false, map.items, .{ .x = @intCast(x), .y = @intCast(y) });
            }
        }
    }

    return sol;
}

test {
    const sol = try solution(std.testing.allocator);

    try std.testing.expectEqual(593, sol.part1);
    try std.testing.expectEqual(1192, sol.part2);
}
