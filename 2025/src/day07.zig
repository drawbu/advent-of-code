const std = @import("std");
const utils = @import("utils.zig");

const TileName = enum(u2) {
    pipe,
    split,
    start,
    empty,
};
const Tile = union(TileName) {
    pipe: u62,
    split: void,
    start: void,
    empty: void,
};

fn set_char(input: [][]Tile, y: usize, x: usize, value: u62) usize {
    switch (input[y][x]) {
        .pipe => |*pipe| input[y][x] = .{ .pipe = pipe.* + value },
        .start => unreachable,
        .split => {
            if (x != 0)
                _ = set_char(input, y, x - 1, value);
            if (x != input[0].len - 1)
                _ = set_char(input, y, x + 1, value);
            return 1;
        },
        .empty => input[y][x] = .{ .pipe = value },
    }
    return 0;
}

pub fn solution(alloc: std.mem.Allocator, file_content: []const u8) !utils.AOCSolution {
    var sol = utils.AOCSolution{ .part1 = 0, .part2 = 0 };
    var input = try utils.AOCInput.init(alloc, file_content);
    defer input.deinit();

    const grid = blk: {
        var buf: std.ArrayList([]Tile) = .empty;
        for (input.items) |line| {
            var tmp: std.ArrayList(Tile) = .empty;
            for (line) |c| {
                switch (c) {
                    '|' => try tmp.append(alloc, .{ .pipe = 0 }),
                    'S' => try tmp.append(alloc, .start),
                    '^' => try tmp.append(alloc, .split),
                    '.' => try tmp.append(alloc, .empty),
                    else => unreachable,
                }
            }
            try buf.append(alloc, try tmp.toOwnedSlice(alloc));
        }
        break :blk try buf.toOwnedSlice(alloc);
    };
    defer {
        for (grid) |l| alloc.free(l);
        alloc.free(grid);
    }

    for (grid, 0..) |line, y| {
        for (line, 0..) |c, x| {
            switch (c) {
                .pipe => |*pipe| {
                    if (y != grid.len - 1)
                        sol.part1 += set_char(grid, y + 1, x, pipe.*);
                },
                .start => sol.part1 += set_char(grid, y + 1, x, 1),
                .empty => {},
                .split => {},
            }
        }
    }

    for (grid[grid.len - 2]) |c| {
        switch (c) {
            .pipe => |*pipe| sol.part2 += pipe.*,
            else => {},
        }
    }
    return sol;
}

test "test input" {
    const test_input =
        \\.......S.......
        \\...............
        \\.......^.......
        \\...............
        \\......^.^......
        \\...............
        \\.....^.^.^.....
        \\...............
        \\....^.^...^....
        \\...............
        \\...^.^...^.^...
        \\...............
        \\..^...^.....^..
        \\...............
        \\.^.^.^.^.^...^.
        \\...............
    ;
    const sol = try solution(std.testing.allocator, test_input);

    try std.testing.expectEqual(21, sol.part1);
    // try std.testing.expectEqual(40, sol.part2);
}

test "actual input" {
    const sol = try solution(std.testing.allocator, @embedFile("input/day07.txt"));

    try std.testing.expectEqual(1533, sol.part1);
    try std.testing.expectEqual(10733529153890, sol.part2);
}
