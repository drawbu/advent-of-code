const std = @import("std");
const utils = @import("utils.zig");

const Point = struct { x: usize, y: usize };

fn through_square(corner_a: Point, corner_b: Point, p1: Point, p2: Point) bool {
    const w = @min(corner_a.x, corner_b.x);
    const e = @max(corner_a.x, corner_b.x);
    const n = @min(corner_a.y, corner_b.y);
    const s = @max(corner_a.y, corner_b.y);

    if (p1.x == p2.x)
        return !(p1.x <= w or p1.x >= e) and
            @min(p1.y, p2.y) < s and @max(p1.y, p2.y) > n;
    return !(p1.y <= n or p1.y >= s) and
        @min(p1.x, p2.x) < e and @max(p1.x, p2.x) > w;
}

fn is_valid(points: []const Point, corner_a: Point, corner_b: Point) bool {
    for (points[0 .. points.len - 1], points[1..]) |p1, p2| {
        if (through_square(corner_a, corner_b, p1, p2)) {
            return false;
        }
    }
    return !through_square(corner_a, corner_b, points[points.len - 1], points[0]);
}

pub fn solution(alloc: std.mem.Allocator, file_content: []const u8) !utils.AOCSolution {
    var sol = utils.AOCSolution{ .part1 = 0, .part2 = 0 };
    var input = try utils.AOCInput.init(alloc, file_content);
    defer input.deinit();

    const points = blk: {
        var points: std.ArrayList(Point) = .empty;
        errdefer points.deinit(alloc);
        for (input.items) |line| {
            var it = std.mem.splitScalar(u8, line, ',');
            try points.append(alloc, .{
                .x = try std.fmt.parseInt(usize, it.next() orelse continue, 10),
                .y = try std.fmt.parseInt(usize, it.next() orelse continue, 10),
            });
        }
        break :blk try points.toOwnedSlice(alloc);
    };
    defer alloc.free(points);

    for (points, 0..) |p1, i| {
        for (points[i + 1 ..]) |p2| {
            const width = @max(p1.x, p2.x) - @min(p1.x, p2.x) + 1;
            const height = @max(p1.y, p2.y) - @min(p1.y, p2.y) + 1;
            const area = width * height;
            if (area > sol.part1)
                sol.part1 = area;
            if (area > sol.part2 and is_valid(points, p1, p2))
                sol.part2 = area;
        }
    }

    return sol;
}

test "test input" {
    const test_input =
        \\7,1
        \\11,1
        \\11,7
        \\9,7
        \\9,5
        \\2,5
        \\2,3
        \\7,3
    ;
    const sol = try solution(std.testing.allocator, test_input);

    try std.testing.expectEqual(50, sol.part1);
    try std.testing.expectEqual(24, sol.part2);
}

test "actual input" {
    const sol = try solution(std.testing.allocator, @embedFile("input/day09.txt"));

    try std.testing.expectEqual(4764078684, sol.part1);
    try std.testing.expectEqual(1652344888, sol.part2);
}
