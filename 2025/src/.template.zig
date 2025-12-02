const std = @import("std");
const utils = @import("utils.zig");

pub fn solution(_: std.mem.Allocator) !utils.AOCSolution {
    var sol = utils.AOCSolution{ .part1 = 0, .part2 = 0 };
    var file = std.io.fixedBufferStream(@embedFile("input/dayN.txt"));

    var buf: [1024]u8 = undefined;
    var reader = file.reader();
    while (try reader.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        _ = line;
    }
    sol.part1 = sol.part1;
    return sol;
}

test {
    const sol = try solution(std.testing.allocator);

    _ = sol;
    // try std.testing.expectEqual(69, sol.part1);
    // try std.testing.expectEqual(420, sol.part2);
}
