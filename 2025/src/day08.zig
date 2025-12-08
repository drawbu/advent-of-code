const std = @import("std");
const utils = @import("utils.zig");

const Point = struct {
    x: usize,
    y: usize,
    z: usize,

    group: ?usize = null,
};

fn count_group(grid: []const Point, id: usize) usize {
    var acc: usize = 0;
    for (grid) |e| {
        if (e.group) |group| {
            if (group == id) {
                acc += 1;
            }
        }
    }
    return acc;
}

fn change_group(grid: []Point, from: usize, to: usize) void {
    for (grid) |*e| {
        if (e.group) |group| {
            if (group == from) {
                e.group = to;
            }
        }
    }
}

fn everything(grid: []Point) bool {
    if (grid[0].group == null) return false;
    const group = grid[0].group.?;
    for (grid[1..]) |e| {
        if (e.group != group) {
            return false;
        }
    }
    return true;
}

const Dis = struct { distance: usize, a: *Point, b: *Point };
fn get_distances(alloc: std.mem.Allocator, grid: []Point) ![]Dis {
    var res: std.ArrayList(Dis) = .empty;
    try res.ensureTotalCapacity(alloc, grid.len * (grid.len / 2) - grid.len / 2);
    errdefer res.deinit(alloc);
    for (grid, 0..) |*a, i| {
        for (grid[i + 1 ..]) |*b| {
            const dx = if (a.x > b.x) a.x - b.x else b.x - a.x;
            const dy = if (a.y > b.y) a.y - b.y else b.y - a.y;
            const dz = if (a.z > b.z) a.z - b.z else b.z - a.z;
            res.appendAssumeCapacity(.{
                .distance = dx * dx + dy * dy + dz * dz,
                .a = a,
                .b = b,
            });
        }
    }
    std.mem.sortUnstable(Dis, res.items, {}, struct {
        fn sort(_: void, a: Dis, b: Dis) bool {
            return a.distance < b.distance;
        }
    }.sort);
    return try res.toOwnedSlice(alloc);
}

fn apply(items: []Dis, grid: []Point, id: *usize) ?usize {
    for (items, 0..) |dis, i| {
        if (everything(grid)) {
            const a = items[i - 1];
            return @intCast(a.a.x * a.b.x);
        }
        if (dis.a.group == null and dis.b.group == null) {
            dis.a.group = id.*;
            dis.b.group = id.*;
            id.* += 1;
        } else if (dis.a.group == null) {
            dis.a.group = dis.b.group;
        } else if (dis.b.group == null) {
            dis.b.group = dis.a.group;
        } else {
            change_group(grid, dis.b.group.?, dis.a.group.?);
        }
    }
    return null;
}

pub fn solution(alloc: std.mem.Allocator, file_content: []const u8) !utils.AOCSolution {
    var sol = utils.AOCSolution{ .part1 = 0, .part2 = 0 };
    var input = try utils.AOCInput.init(alloc, file_content);
    defer input.deinit();

    const grid = blk: {
        var grid: std.ArrayList(Point) = .empty;
        errdefer grid.deinit(alloc);
        for (input.items) |line| {
            var it = std.mem.splitScalar(u8, line, ',');
            try grid.append(alloc, .{
                .x = try std.fmt.parseInt(usize, it.next() orelse continue, 10),
                .y = try std.fmt.parseInt(usize, it.next() orelse continue, 10),
                .z = try std.fmt.parseInt(usize, it.next() orelse continue, 10),
            });
        }
        break :blk try grid.toOwnedSlice(alloc);
    };
    defer alloc.free(grid);

    const distances = try get_distances(alloc, grid);
    defer alloc.free(distances);

    // requirements changes between test case and actual input
    const size: usize = if (grid.len == 20) 10 else 1000;

    var id: usize = 0;
    _ = apply(distances[0..size], grid, &id);

    // > but mom i want sets!
    // > we already have sets at home
    // > sets at home:
    var sizes: std.ArrayList(usize) = .empty;
    defer sizes.deinit(alloc);
    a: for (0..id) |i| {
        const count = count_group(grid, i);
        for (sizes.items) |z|
            if (z == count) continue :a;
        try sizes.append(alloc, count);
    }

    sol.part1 = 1;
    std.mem.sort(usize, sizes.items, {}, comptime std.sort.desc(usize));
    for (sizes.items[0..3]) |count|
        sol.part1 *= count;

    sol.part2 = apply(distances[size..], grid, &id).?;

    return sol;
}

test "test input" {
    const test_input =
        \\162,817,812
        \\57,618,57
        \\906,360,560
        \\592,479,940
        \\352,342,300
        \\466,668,158
        \\542,29,236
        \\431,825,988
        \\739,650,466
        \\52,470,668
        \\216,146,977
        \\819,987,18
        \\117,168,530
        \\805,96,715
        \\346,949,466
        \\970,615,88
        \\941,993,340
        \\862,61,35
        \\984,92,344
        \\425,690,689
    ;
    const sol = try solution(std.testing.allocator, test_input);

    try std.testing.expectEqual(40, sol.part1);
    try std.testing.expectEqual(25272, sol.part2);
}

test "actual input" {
    const sol = try solution(std.testing.allocator, @embedFile("input/day08.txt"));

    try std.testing.expectEqual(75680, sol.part1);
    try std.testing.expectEqual(8995844880, sol.part2);
}
