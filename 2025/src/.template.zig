const std = @import("std");
const utils = @import("utils.zig");

pub fn solution(alloc: std.mem.Allocator, file_content: []const u8) !utils.AOCSolution {
    var sol = utils.AOCSolution{ .part1 = 0, .part2 = 0 };
    var input = try utils.AOCInput.init(alloc, file_content);
    defer input.deinit();

    for (input.items) |line| {
        _ = line;
    }
    sol.part1 = sol.part1;
    return sol;
}

test "test input" {
    const test_input =
        \\
    ;
    const sol = try solution(std.testing.allocator, test_input);

    _ = sol;
    // try std.testing.expectEqual(3, sol.part1);
    // try std.testing.expectEqual(6, sol.part2);
}

test "actual input" {
    const sol = try solution(std.testing.allocator, @embedFile("input/dayN.txt"));

    _ = sol;
    // try std.testing.expectEqual(69, sol.part1);
    // try std.testing.expectEqual(420, sol.part2);
}
