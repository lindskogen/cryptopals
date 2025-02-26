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

const char_freq = "EARIOTNSLCUDPMHGBFYWKVXZJQ ".*;

test "simple test" {
    const str = "1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736";

    var hex: [str.len / 2]u8 = undefined;

    var it = std.mem.window(u8, str, 2, 2);
    var i: usize = 0;
    while (it.next()) |pair| {
        hex[i] = try std.fmt.parseInt(u8, pair, 16);
        i += 1;
    }

    var key: ?u8 = null;
    var key_score: usize = 0;

    for (1..255) |c| {
        var score: usize = 0;
        for (hex) |h| {
            const r: u8 = h ^ @as(u8, @intCast(c));
            // chars[r] += 1;

            if (std.mem.indexOfScalar(u8, &char_freq, r)) |index| {
                const char_score = char_freq.len - index;
                score += char_score;
            } else if (r >= 32) {
                if (std.mem.indexOfScalar(u8, &char_freq, r - 32)) |index| {
                    const char_score = char_freq.len - index;
                    score += char_score;
                }
            }
        }
        if (score > key_score) {
            key = @intCast(c);
            key_score = score;
        }
    }


    if (key) |k| {
        std.debug.print("Found key: '{c}'\n", .{k});
        for (hex) |h| {
            const r: u8 = h ^ @as(u8, @intCast(k));

            std.debug.print("{c}", .{r});
        }
    }


    std.debug.print("\n", .{});
}
