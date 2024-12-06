const std = @import("std");
const utils = @import("utils.zig");

const TileName = enum(u2) {
    empty,
    visited,
    obstacle,
};
const Tile = union(TileName) {
    empty: void,
    visited: u4,
    obstacle: void,
};

const Position = struct {
    x: usize,
    y: usize,

    inline fn idx(pos: *const Position, width: usize) usize {
        return pos.y * width + pos.x;
    }
};

const Guard = struct {
    pos: Position,
    direction: u2,
};

fn parse(alloc: std.mem.Allocator, file: []const u8, guard: *Guard) !std.ArrayList(Tile) {
    var map = std.ArrayList(Tile).init(alloc);
    errdefer map.deinit();

    var it = std.mem.tokenizeAny(u8, file, "\n");
    var y: usize = 0;
    while (it.next()) |line| {
        defer y += 1;
        for (0.., line) |x, tile| {
            switch (tile) {
                '^' => {
                    guard.pos = .{ .x = x, .y = y };
                    try map.append(.{ .visited = 0b0000 });
                },
                '.' => try map.append(.empty),
                '#' => try map.append(.obstacle),
                else => unreachable,
            }
        }
    }
    return map;
}

const Move = enum {
    ok,
    ko,
    void,
};

fn can_move(map: []const Tile, pos: *Position, direction: u2, width: usize) Move {
    var new: Position = pos.*;

    switch (direction) {
        0 => {
            if (new.y == 0)
                return .void;
            new.y -= 1;
        },
        1 => {
            new.x += 1;
            if (new.x >= width)
                return .void;
        },
        2 => {
            new.y += 1;
            if (new.y >= width)
                return .void;
        },
        3 => {
            if (new.x == 0)
                return .void;
            new.x -= 1;
        },
    }

    switch (map[new.idx(width)]) {
        .obstacle => return .ko,
        else => {
            pos.* = new;
            return .ok;
        },
    }
}

/// Returns true if not infinite loop
fn compute(map: []Tile, g: Guard, width: usize) bool {
    var guard = g;
    while (true) {
        switch (can_move(map, &guard.pos, guard.direction, width)) {
            .void => return true,
            .ko => guard.direction +%= 1,
            .ok => {
                const tile = &map[guard.pos.idx(width)];
                switch (tile.*) {
                    .visited => {},
                    else => tile.* = .{ .visited = 0b0000 },
                }
                // infinite loop
                if ((tile.visited & (@as(u4, 0b1) << guard.direction)) != 0)
                    return false;
                tile.visited |= @as(u4, 0b1) << guard.direction;
            },
        }
    }
}

pub fn solution(alloc: std.mem.Allocator) !utils.AOCSolution {
    const file = @embedFile("input/day06.txt");
    var sol = utils.AOCSolution{ .part1 = 0, .part2 = 0 };

    const width = std.mem.indexOf(u8, file, "\n").?;

    var guard = Guard{ .pos = .{ .x = 0, .y = 0 }, .direction = 0 };
    var map = try parse(alloc, file, &guard);
    defer map.deinit();

    const m1 = try alloc.dupe(Tile, map.items);
    defer alloc.free(m1);
    // part 1
    _ = compute(m1, guard, width);
    for (m1) |tile| {
        switch (tile) {
            .visited => sol.part1 += 1,
            else => {},
        }
    }

    // part 2
    const m2 = try alloc.dupe(Tile, map.items);
    defer alloc.free(m2);
    for (0.., map.items) |i, _| {
        switch (m1[i]) {
            .obstacle => continue,
            .empty => continue,
            .visited => {},
        }
        // No idea how it's faster to alloc on each loop but ok
        @memcpy(m2, map.items);
        m2[i] = .obstacle;
        if (!compute(m2, guard, width))
            sol.part2 += 1;
    }
    return sol;
}

test {
    const sol = try solution(std.testing.allocator);

    try std.testing.expectEqual(5212, sol.part1);
    try std.testing.expectEqual(1767, sol.part2);
}
