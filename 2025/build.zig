const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Find all available days at build time
    const availableDays = blk: {
        var availableDays: std.ArrayList(?[]const u8) = .empty;
        availableDays.appendNTimes(b.allocator, null, 25) catch unreachable;
        var top: usize = 0;
        for (0..availableDays.items.len) |day| {
            const filename = std.fmt.allocPrint(b.allocator, "src/day{d:0>2}.zig", .{day + 1}) catch unreachable;
            if (std.fs.cwd().access(filename, .{})) |_| {
                top = day;
                availableDays.insertAssumeCapacity(day, filename);
            } else |_| {}
        }
        const slice = availableDays.toOwnedSlice(b.allocator) catch unreachable;
        break :blk slice[0 .. top + 1];
    };

    // Generate solutions array
    const solutions_file = blk: {
        var solutions_list: std.ArrayList(u8) = .empty;
        var writer = solutions_list.writer(b.allocator);
        writer.writeAll(
            \\const std = @import("std");
            \\const utils = @import("utils.zig");
            \\pub const solutions = [_]?*const fn (std.mem.Allocator) anyerror!utils.AOCSolution{
            \\
        ) catch unreachable;
        for (availableDays, 1..) |filename, day| {
            if (filename) |_| {
                writer.print("    @import(\"day{d:0>2}.zig\").solution,\n", .{day}) catch unreachable;
            } else {
                writer.writeAll("    null,\n") catch unreachable;
            }
        }
        writer.writeAll("};\n") catch unreachable;
        const wf = b.addWriteFiles();
        break :blk wf.add("solutions.zig", solutions_list.items);
    };

    // Create shared utils module
    const utils_module = b.createModule(.{
        .root_source_file = b.path("src/utils.zig"),
        .target = target,
        .optimize = optimize,
    });

    const solutions_module = b.createModule(.{
        .root_source_file = solutions_file,
        .target = target,
        .optimize = optimize,
    });
    solutions_module.addImport("utils.zig", utils_module);
    for (availableDays, 1..) |filename, day| {
        const file = filename orelse continue;
        const module_name = std.fmt.allocPrint(b.allocator, "day{d:0>2}.zig", .{day}) catch unreachable;
        const day_module = b.createModule(.{
            .root_source_file = b.path(file),
            .target = target,
            .optimize = optimize,
        });
        day_module.addImport("utils.zig", utils_module);
        solutions_module.addImport(module_name, day_module);
    }

    const exe = b.addExecutable(.{ .name = "aoc2025", .root_module = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    }) });
    exe.root_module.addImport("solutions", solutions_module);
    exe.root_module.addImport("utils.zig", utils_module);
    b.installArtifact(exe);

    // zig build run
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    // zig build test
    const test_step = b.step("test", "Run unit tests");
    for (availableDays) |filename| {
        const file = filename orelse continue;
        const day_tests = b.addTest(.{ .root_module = b.createModule(.{
            .root_source_file = b.path(file),
            .target = target,
            .optimize = optimize,
        }) });
        const run_day_tests = b.addRunArtifact(day_tests);
        test_step.dependOn(&run_day_tests.step);
    }
}
