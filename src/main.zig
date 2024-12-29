const std = @import("std");
const stdout = std.io.getStdOut().writer();

const fg_green = "\u{001b}[32m";
const fg_red = "\u{001b}[31m";

pub fn main() !u8 {
    // Get the command line arguments.
    const args = std.os.argv;

    // Check that there is one argument provided.
    if (args.len < 2) {
        try stdout.writeAll("Usage: roz [weight-kg]\n");
        return 1;
    } else if (args.len > 2) {
        try stdout.print("{s}error: too many arguments provided\n", .{fg_red});
        return 1;
    }

    // Cast the argument to `[]const u8`.
    const arg = std.mem.span(args[1]);

    // Cast to a float.
    const weight = std.fmt.parseFloat(f32, arg) catch {
        try stdout.print("{s}error: unable to parse \"{s}\" to a float\n", .{ fg_red, arg });
        return 1;
    };

    // Validate input float is a realistic value.
    if (weight > 500.0) {
        try stdout.print("{s}weight is over 500kg, how big is the dog?!\n", .{fg_red});
        return 1;
    } else if (weight <= 0.0) {
        try stdout.print("{s}weight is 0kg or less, need I say more?\n", .{fg_red});
        return 1;
    }

    // Convert from Kilograms to Grams.
    const grams: u32 = @intFromFloat(weight * 1000);
    try stdout.print("weight in grams: {d}g\n", .{grams});

    // Calculate 2% and 3% of the weight in grams.
    const daily_1_percent = grams / 100;
    const daily_2_percent = daily_1_percent * 2;
    const daily_3_percent = daily_1_percent * 3;
    try stdout.print("daily amount: {d}g to {d}g\n", .{ daily_2_percent, daily_3_percent });

    // Calculate amount per meal. Based on fixed rate of 2 meals per day.
    const meal_2_percent = daily_2_percent / 2;
    const meal_3_percent = daily_3_percent / 2;
    try stdout.print("amount per meal: {s}{d}g to {d}g\n", .{ fg_green, meal_2_percent, meal_3_percent });

    return 0;
}
