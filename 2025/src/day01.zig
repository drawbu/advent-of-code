const std = @import("std");
const utils = @import("utils.zig");

pub fn solution(_: std.mem.Allocator) !utils.AOCSolution {
    var sol = utils.AOCSolution{ .part1 = 0, .part2 = 0 };
    var file = std.io.fixedBufferStream(@embedFile("input/day01.txt"));

    var lock: usize = 50;

    var buf: [1024]u8 = undefined;
    var reader = file.reader();
    while (try reader.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        const padd = try std.fmt.parseInt(u32, line[1..], 10);
        switch (line[0]) {
            'R' => {
                lock += padd;
                sol.part2 += lock / 100;
            },
            'L' => {
                sol.part2 += padd / 100;
                const rem = padd % 100;
                if (lock == 0) {
                    lock = 100 - rem;
                } else if (rem >= lock) {
                    lock = 100 - (rem - lock);
                    sol.part2 += 1;
                } else {
                    lock -= rem;
                }
            },
            else => {},
        }
        lock %= 100;
        if (lock == 0) {
            sol.part1 += 1;
        }
    }
    return sol;
}

test {
    const sol = try solution(std.testing.allocator);

    try std.testing.expectEqual(1150, sol.part1);
    try std.testing.expectEqual(6738, sol.part2);
}
