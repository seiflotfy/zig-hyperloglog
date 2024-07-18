const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const root_source_file = b.path("src/main.zig");

    _ = b.addModule("hyperloglog", .{ .root_source_file = root_source_file });

    const lib = b.addStaticLibrary(.{
        .name = "hyperloglog",
        .target = target,
        .optimize = optimize,
        .root_source_file = root_source_file,
    });

    b.installArtifact(lib);

    const tests_step = b.step("test", "Run tests");

    const tests = b.addTest(.{
        .target = target,
        .root_source_file = root_source_file,
    });

    const tests_run = b.addRunArtifact(tests);
    tests_step.dependOn(&tests_run.step);
    b.default_step.dependOn(tests_step);
}
