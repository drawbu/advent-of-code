const std = @import("std");
const utils = @import("utils.zig");

const Array = std.ArrayList(u32);
const OrdRules = std.AutoHashMap(u32, Array);

/// Returns true if the array is valid. Mutates it until it is. Still returns
/// false to identify the day
fn check_array(array: *Array, ord_rules: *const OrdRules) !bool {
    for (1..array.items.len) |idx| {
        if (ord_rules.getPtr(array.items[idx])) |invalid_predecessors| {
            for (invalid_predecessors.items) |invalid_pr| {
                for (0..idx) |previous_idx| {
                    if (array.items[previous_idx] != invalid_pr)
                        continue;
                    const v = array.orderedRemove(idx);
                    try array.insert(previous_idx, v);
                    _ = try check_array(array, ord_rules);
                    return false;
                }
            }
        }
    }
    return true;
}

pub fn solution(alloc: std.mem.Allocator) !utils.AOCSolution {
    const file = @embedFile("input/day05.txt");
    var sol = utils.AOCSolution{ .part1 = 0, .part2 = 0 };

    // parsing
    var ord_rules = OrdRules.init(alloc);
    defer {
        var it = ord_rules.iterator();
        while (it.next()) |entry|
            entry.value_ptr.deinit();
        ord_rules.deinit();
    }

    var it = std.mem.splitAny(u8, file, "\n");
    var update_time = false;
    while (it.next()) |line| {
        if (line.len == 0) {
            update_time = true;
            continue;
        }
        // Parse ordering rules
        if (!update_time) {
            const key = try std.fmt.parseInt(u32, line[0..2], 10);
            const value = try std.fmt.parseInt(u32, line[3..5], 10);
            var values = try ord_rules.getOrPutValue(key, Array.init(ord_rules.allocator));
            try values.value_ptr.append(value);
            continue;
        }

        // Parse updates
        var array = try Array.initCapacity(alloc, 100);
        defer array.deinit();
        var n_it = std.mem.splitAny(u8, line, ",");
        while (n_it.next()) |num|
            try array.append(try std.fmt.parseInt(u32, num, 10));

        // Check updates (can mutate array for part2)
        const correct = try check_array(&array, &ord_rules);
        const val = array.items[array.items.len / 2];

        if (correct) {
            sol.part1 += val;
        } else {
            sol.part2 += val;
        }
    }

    return sol;
}

test {
    const sol = try solution(std.testing.allocator);

    try std.testing.expectEqual(4959, sol.part1);
    try std.testing.expectEqual(4655, sol.part2);
}
