const std = @import("std");
const process = std.process;
const alloc = std.testing.allocator;
const exe_path = "zig-out/bin/roz";

test "single number arg" {
    // the command to run
    const argv = [_][]const u8{ exe_path, "7" };

    const proc = try process.Child.run(.{
        .allocator = alloc,
        .argv = &argv,
    });

    // on success, we own the output streams
    defer alloc.free(proc.stdout);
    defer alloc.free(proc.stderr);

    const term = proc.term;

    // test the exit code
    try std.testing.expectEqual(term, process.Child.Term{ .Exited = 0 });

    // test the stdout
    try std.testing.expectEqualStrings(proc.stdout, "weight in grams: 7000g\ndaily amount: 140g to 210g\namount per meal: \u{001b}[32m70g to 105g\n");
}

test "no args" {
    // the command to run
    const argv = [_][]const u8{exe_path};

    const proc = try process.Child.run(.{
        .allocator = alloc,
        .argv = &argv,
    });

    // on success, we own the output streams
    defer alloc.free(proc.stdout);
    defer alloc.free(proc.stderr);

    const term = proc.term;

    // test the exit code
    try std.testing.expectEqual(term, process.Child.Term{ .Exited = 1 });

    // test the stdout
    try std.testing.expectEqualStrings(proc.stdout, "Usage: roz [weight-kg]\n");
}
