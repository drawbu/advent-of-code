const std = @import("std");
const utils = @import("utils.zig");

const OptionEnum = enum {
    none,
    some,
};

const Option = union(OptionEnum) {
    none: void,
    some: usize,

    inline fn is_some(elem: *const Option) bool {
        return switch (elem.*) {
            .none => false,
            .some => true,
        };
    }
};

fn is_compressed(array: []const Option) bool {
    var num = true;
    for (array) |elem|
        switch (elem) {
            .none => num = false,
            .some => if (!num) return false,
        };
    return true;
}

fn part_one(items: []Option) void {
    var fst: usize = 0;
    for (0..items.len) |i| {
        const idx = items.len - 1 - i;
        if (fst >= idx)
            break;
        const item = &items[idx];
        switch (item.*) {
            .none => continue,
            .some => {},
        }

        // move fst
        while (switch (items[fst]) {
            .none => false,
            .some => true,
        }) {
            if (fst >= idx)
                return;
            fst += 1;
        }

        std.mem.swap(Option, &items[idx], &items[fst]);
    }
}

fn file_size(items: []const Option, elem: Option) usize {
    const is_some = switch (elem) {
        .some => true,
        .none => false,
    };
    for (0..items.len) |i| {
        const item_is_some = switch (items[i]) {
            .some => true,
            .none => false,
        };
        if (is_some != item_is_some)
            return i;
        if (is_some and elem.some != items[i].some)
            return i;
    }
    return items.len;
}

fn part_two(alloc: std.mem.Allocator, items: []Option) !void {
    var hash_map = std.ArrayList(usize).init(alloc);
    defer hash_map.deinit();
    try hash_map.appendNTimes(0, items.len);

    var j: usize = 0;
    while (j < items.len) {
        if (items[j].is_some()) {
            j += 1;
            continue;
        }
        const size = file_size(items[j..], items[j]);
        hash_map.items[j] = size;
        j += size;
    }

    var idx = items.len - 1;
    while (idx > 0) {
        defer idx -= 1;

        const item = items[idx];
        if (!item.is_some())
            continue;

        var size: usize = 0;
        while (idx - size != 0 and items[idx - size].is_some() and item.some == items[idx - size].some)
            size += 1;

        for (0.., hash_map.items) |i, entry| {
            if (i >= idx)
                break;
            if (entry < size)
                continue;
            for (0..size) |k|
                std.mem.swap(Option, &items[idx - (size - 1) + k], &items[i + k]);
            const new = entry - size;
            hash_map.items[i] = 0;
            hash_map.items[i + size] = new;
            break;
        }
        idx -= size - 1;
    }
}

fn checksum(items: []const Option) usize {
    var res: usize = 0;
    for (0.., items) |i, block|
        switch (block) {
            .some => res += i * block.some,
            .none => {},
        };
    return res;
}

pub fn solution(alloc: std.mem.Allocator) !utils.AOCSolution {
    const file = @embedFile("input/day09.txt");

    var array = std.ArrayList(Option).init(alloc);
    defer array.deinit();
    for (0.., file) |i, c|
        if (c >= '0' and c <= '9')
            try array.appendNTimes(if (i % 2 == 0) .{
                .some = i / 2,
            } else .none, c - '0');

    var fs_one = try alloc.dupe(Option, array.items);
    defer alloc.free(fs_one);
    const fs_two = try alloc.dupe(Option, array.items);
    defer alloc.free(fs_two);
    part_one(fs_one[0..]);
    try part_two(alloc, fs_two[0..]);

    return .{ .part1 = checksum(fs_one), .part2 = checksum(fs_two) };
}

test {
    const sol = try solution(std.testing.allocator);

    try std.testing.expectEqual(6463499258318, sol.part1);
    try std.testing.expectEqual(6493634986625, sol.part2);
}
