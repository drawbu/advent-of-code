const std = @import("std");
const utils = @import("utils.zig");

const OpType = enum { mul, add };

fn sum(op: OpType, nums: []const usize) usize {
    if (op == .mul) {
        var acc: usize = 1;
        for (nums) |elem| acc *= elem;
        return acc;
    } else {
        var acc: usize = 0;
        for (nums) |elem| acc += elem;
        return acc;
    }
}

pub fn solution(alloc: std.mem.Allocator, file_content: []const u8) !utils.AOCSolution {
    var sol = utils.AOCSolution{ .part1 = 0, .part2 = 0 };
    var input = try utils.AOCInput.init(alloc, file_content);
    defer input.deinit();

    var ops = ops: {
        const op_raw = input.items[input.items.len - 1];
        var ops: std.ArrayList(struct {
            type: OpType,
            idx: usize,
            size: usize = 0,
        }) = .empty;
        errdefer ops.deinit(alloc);

        for (op_raw, 0..) |elem, i| {
            switch (elem) {
                ' ' => {},
                '*' => try ops.append(alloc, .{ .type = .mul, .idx = i }),
                '+' => try ops.append(alloc, .{ .type = .add, .idx = i }),
                else => unreachable,
            }
        }
        for (ops.items[0 .. ops.items.len - 1], ops.items[1..]) |*op1, op2|
            op1.size = op2.idx - op1.idx - 1;
        ops.items[ops.items.len - 1].size = op_raw.len - ops.items[ops.items.len - 1].idx;
        break :ops ops;
    };
    defer ops.deinit(alloc);

    const elems = try alloc.alloc([]const u8, input.items.len - 1);
    defer alloc.free(elems);

    const nums = try alloc.alloc(usize, input.items.len - 1);
    defer alloc.free(nums);

    for (ops.items) |op| {
        for (input.items[0 .. input.items.len - 1], elems, nums) |line, *elem, *num| {
            elem.* = line[op.idx .. op.idx + op.size];
            num.* = try std.fmt.parseInt(usize, std.mem.trim(u8, elem.*, " "), 10);
        }
        sol.part1 += sum(op.type, nums);

        for (nums[0..op.size]) |*n| n.* = 0;
        for (elems) |item| {
            for (item, nums[0..op.size]) |c, *n| {
                if (c >= '0' and c <= '9')
                    n.* = n.* * 10 + c - '0';
            }
        }
        sol.part2 += sum(op.type, nums[0..op.size]);
    }

    return sol;
}

test "test input" {
    const test_input =
        "123 328  51 64 \n 45 64  387 23 \n  6 98  215 314\n*   +   *   +  ";
    const sol = try solution(std.testing.allocator, test_input);

    try std.testing.expectEqual(4277556, sol.part1);
    try std.testing.expectEqual(3263827, sol.part2);
}

test "actual input" {
    const sol = try solution(std.testing.allocator, @embedFile("input/day06.txt"));

    try std.testing.expectEqual(3261038365331, sol.part1);
    try std.testing.expectEqual(8342588849093, sol.part2);
}
