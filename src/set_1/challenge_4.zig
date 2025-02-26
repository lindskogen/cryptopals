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
const strs = @embedFile("./challenge_4_input");

test "simple test" {

    var lines = std.mem.tokenizeScalar(u8, strs, '\n');

    var best_line_idx: usize = 0;
    var key: ?u8 = null;
    var key_score: isize = 0;

    var line_idx: usize = 0;

    while (lines.next()) |str| : (line_idx += 1) {
        var hex: [30]u8 = undefined;

        var it = std.mem.window(u8, str, 2, 2);
        var i: usize = 0;
        while (it.next()) |pair| {
            hex[i] = try std.fmt.parseInt(u8, pair, 16);
            i += 1;
        }



        for (1..255) |c| {
            var score: isize = 0;
            for (hex) |h| {
                const r: u8 = h ^ @as(u8, @intCast(c));

                if (r < 20) {
                    continue;
                } else {
                    if (std.mem.indexOfScalar(u8, &char_freq, r)) |index| {
                        const char_score = char_freq.len - index;
                        score += @intCast(char_score);
                    } else if (r >= 32) {
                        if (std.mem.indexOfScalar(u8, &char_freq, r - 32)) |index| {
                            const char_score = char_freq.len - index;
                            score += @intCast(char_score);
                        }
                    }
                }

            }
            if (score > key_score) {
                key = @intCast(c);
                key_score = score;
                best_line_idx = line_idx;
            }
        }
    }

    lines.reset();

    for (0..best_line_idx) |_| {
        _ = lines.next();
    }

    if (lines.next()) |str| {
        var hex: [30]u8 = undefined;

        var it = std.mem.window(u8, str, 2, 2);
        var i: usize = 0;
        while (it.next()) |pair| {
            hex[i] = try std.fmt.parseInt(u8, pair, 16);
            i += 1;
        }

        if (key) |k| {
            std.debug.print("Found key: '{c}', with score: {d}\n", .{k, key_score});
            for (hex) |h| {
                const r: u8 = h ^ @as(u8, @intCast(k));

                std.debug.print("{c}", .{r});
            }
        }
        std.debug.print("\n", .{});
    }

}
