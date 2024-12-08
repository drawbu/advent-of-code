const std = @import("std");
const utils = @import("utils.zig");

const Coordinate = struct {
    x: i64,
    y: i64,
};

fn parsing(alloc: std.mem.Allocator, file: []const u8) !std.AutoHashMap(u8, std.ArrayList(Coordinate)) {
    var map = std.AutoHashMap(u8, std.ArrayList(Coordinate)).init(alloc);

    var it = std.mem.tokenizeAny(u8, file, "\n");
    var y: i64 = 0;
    while (it.next()) |line| {
        defer y += 1;
        for (0.., line) |x, char| {
            if (char == '.')
                continue;

            var array = try map.getOrPutValue(char, std.ArrayList(Coordinate).init(alloc));
            try array.value_ptr.append(Coordinate{
                .x = @intCast(x),
                .y = y,
            });
        }
    }
    return map;
}

fn add_to_set(antinode: Coordinate, array: *std.ArrayList(Coordinate), width: usize, height: usize) !bool {
    if (antinode.x < 0 or antinode.y < 0 or antinode.x >= width or antinode.y >= height)
        return false;
    for (array.items) |a|
        if (antinode.x == a.x and antinode.y == a.y)
            return true;
    try array.append(antinode);
    return true;
}

pub fn solution(alloc: std.mem.Allocator) !utils.AOCSolution {
    const file = @embedFile("input/day08.txt");

    var map = try parsing(alloc, file);
    defer {
        var it = map.iterator();
        while (it.next()) |entry|
            entry.value_ptr.deinit();
        map.deinit();
    }
    const width = std.mem.indexOf(u8, file, "\n").?;
    const height = std.mem.count(u8, file, "\n");

    var part1 = std.ArrayList(Coordinate).init(map.allocator);
    defer part1.deinit();

    var part2 = std.ArrayList(Coordinate).init(map.allocator);
    defer part2.deinit();

    var it = map.iterator();
    while (it.next()) |entry| {
        for (entry.value_ptr.items) |antennaA| {
            for (entry.value_ptr.items) |antennaB| {
                if (antennaA.x == antennaB.x and antennaA.y == antennaB.y)
                    continue;
                const diff = Coordinate{
                    .x = antennaA.x - antennaB.x,
                    .y = antennaA.y - antennaB.y,
                };

                // Part 1
                _ = try add_to_set(Coordinate{
                    .x = antennaA.x + diff.x,
                    .y = antennaA.y + diff.y,
                }, &part1, width, height);

                // Part 2
                _ = try add_to_set(antennaA, &part2, width, height);
                var i: i64 = 1;
                while (try add_to_set(Coordinate{
                    .x = antennaA.x + diff.x * i,
                    .y = antennaA.y + diff.y * i,
                }, &part2, width, height))
                    i += 1;
            }
        }
    }

    return .{
        .part1 = part1.items.len,
        .part2 = part2.items.len,
    };
}

test {
    const sol = try solution(std.testing.allocator);

    try std.testing.expectEqual(398, sol.part1);
    try std.testing.expectEqual(1333, sol.part2);
}
