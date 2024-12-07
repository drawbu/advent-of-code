const std = @import("std");
const utils = @import("utils.zig");

const Part1 = enum {
    mul,
    add,

    inline fn func(t: Part1, r: u64, v: u64) u64 {
        return switch (t) {
            .mul => r * v,
            .add => r + v,
        };
    }
};

const Part2 = enum {
    mul,
    add,
    concat,

    inline fn func(t: Part2, r: u64, v: u64) u64 {
        return switch (t) {
            .mul => r * v,
            .add => r + v,
            .concat => r * std.math.pow(u64, 10, std.math.log10(v) + 1) + v,
        };
    }
};

fn compute(comptime T: type, alloc: std.mem.Allocator, expect: u64, values: []const u64) !bool {
    const len = comptime @typeInfo(T).Enum.fields.len;

    var vec = try std.ArrayList(T).initCapacity(alloc, values.len - 1);
    defer vec.deinit();
    for (0..values.len - 1) |_|
        vec.appendAssumeCapacity(@enumFromInt(0));

    const pow = std.math.pow(u64, len, values.len - 1);
    for (0..pow) |i| {
        var rem = i;
        for (vec.items) |*item| {
            item.* = @enumFromInt(rem % len);
            rem /= len;
        }

        var r = values[0];
        for (vec.items, values[1..]) |op, v|
            r = T.func(op, r, v);
        if (r == expect)
            return true;
    }
    return false;
}

pub fn solution(alloc: std.mem.Allocator) !utils.AOCSolution {
    const file = @embedFile("input/day07.txt");
    var sol = utils.AOCSolution{ .part1 = 0, .part2 = 0 };

    var it = std.mem.tokenizeAny(u8, file, "\n");
    while (it.next()) |line| {
        var array = try std.ArrayList(u64).initCapacity(alloc, 16);
        defer array.deinit();

        // parsing
        const sep = std.mem.indexOf(u8, line, ":").?;
        const val = try std.fmt.parseInt(u64, line[0..sep], 10);

        var it2 = std.mem.tokenizeAny(u8, line[sep + 1 ..], " ");
        while (it2.next()) |n|
            array.appendAssumeCapacity(try std.fmt.parseInt(u64, n, 10));

        // compute
        if (try compute(Part1, alloc, val, array.items))
            sol.part1 += val;
        if (try compute(Part2, alloc, val, array.items))
            sol.part2 += val;
    }

    return sol;
}

test {
    const sol = try solution(std.testing.allocator);

    try std.testing.expectEqual(8401132154762, sol.part1);
    try std.testing.expectEqual(95297119227552, sol.part2);
}
