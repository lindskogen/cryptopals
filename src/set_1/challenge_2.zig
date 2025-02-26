const std = @import("std");

pub fn main() !void {
    // Prints to stderr (it's a shortcut based on `std.io.getStdErr()`)
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});

    // stdout is for the actual output of your application, for example if you
    // are implementing gzip, then only the compressed bytes should be sent to
    // stdout, not any debugging messages.
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    try stdout.print("Run `zig build test` to run the tests.\n", .{});

    try bw.flush(); // don't forget to flush!
}

test "simple test" {
    const str1 = "1c0111001f010100061a024b53535009181c";
    const str2 = "686974207468652062756c6c277320657965";

    var hex1: [str1.len / 2]u8 = undefined;
    var hex2: [str1.len / 2]u8 = undefined;
    var hex3: [str1.len / 2]u8 = undefined;

    {
        var it = std.mem.window(u8, str1, 2, 2);
        var i: usize = 0;
        while (it.next()) |pair| {
            hex1[i] = try std.fmt.parseInt(u8, pair, 16);
            i += 1;
        }
        it = std.mem.window(u8, str2, 2, 2);
        i = 0;
        while (it.next()) |pair| {
            hex2[i] = try std.fmt.parseInt(u8, pair, 16);
            i += 1;
        }
    }

    for (hex1, 0..) |_, i| {
        hex3[i] = hex1[i] ^ hex2[i];
    }



    for (hex3) |h| {
        std.debug.print("{x}", .{h});
    }
    std.debug.print("\n", .{});
}
