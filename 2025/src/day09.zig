const std = @import("std");
const utils = @import("utils.zig");

const Point = struct { x: u32, y: u32 };
const Square = struct {
    w: u32,
    e: u32,
    n: u32,
    s: u32,

    fn init(a: Point, b: Point) Square {
        return .{
            .w = @min(a.x, b.x),
            .e = @max(a.x, b.x),
            .n = @min(a.y, b.y),
            .s = @max(a.y, b.y),
        };
    }
};

fn is_valid(square: Square, joints: []const Square) bool {
    for (joints) |joint| {
        if (joint.w == joint.e) {
            if (!(joint.w <= square.w or joint.w >= square.e) and
                joint.n < square.s and joint.s > square.n)
                return false;
        } else {
            if (!(joint.n <= square.n or joint.n >= square.s) and
                joint.w < square.e and joint.e > square.w)
                return false;
        }
    }
    return true;
}

pub fn solution(alloc: std.mem.Allocator, file_content: []const u8) !utils.AOCSolution {
    var sol = utils.AOCSolution{ .part1 = 0, .part2 = 0 };
    var input = try utils.AOCInput.init(alloc, file_content);
    defer input.deinit();

    const points = blk: {
        var points: std.ArrayList(Point) = .empty;
        try points.ensureTotalCapacity(alloc, input.items.len);
        errdefer points.deinit(alloc);
        for (input.items) |line| {
            var it = std.mem.splitScalar(u8, line, ',');
            points.appendAssumeCapacity(.{
                .x = try std.fmt.parseInt(u32, it.next() orelse continue, 10),
                .y = try std.fmt.parseInt(u32, it.next() orelse continue, 10),
            });
        }
        break :blk try points.toOwnedSlice(alloc);
    };
    defer alloc.free(points);

    const joints = blk: {
        var joints: std.ArrayList(Square) = .empty;
        try joints.ensureTotalCapacity(alloc, points.len);
        errdefer joints.deinit(alloc);
        for (points[0 .. points.len - 1], points[1..]) |p1, p2|
            joints.appendAssumeCapacity(Square.init(p1, p2));
        joints.appendAssumeCapacity(Square.init(points[points.len - 1], points[0]));
        break :blk try joints.toOwnedSlice(alloc);
    };
    defer alloc.free(joints);

    for (points, 0..) |p1, i| {
        for (points[i + 1 ..]) |p2| {
            const width = @max(p1.x, p2.x) - @min(p1.x, p2.x) + 1;
            const height = @max(p1.y, p2.y) - @min(p1.y, p2.y) + 1;
            const area = @as(usize, width) * height;
            if (area > sol.part1)
                sol.part1 = area;
            if (area > sol.part2 and is_valid(Square.init(p1, p2), joints))
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
