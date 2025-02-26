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

const KEY = "ICE";

const input =
    \\Burning 'em, if you ain't quick and nimble
    \\I go crazy when I hear a cymbal
;

test "simple test" {
    std.debug.print("\n", .{});
    var key_index: usize = 0;

    for (input) |i| {
        const k = KEY[key_index];
        std.debug.print("{x:0>2}", .{ i ^ k });

        key_index = (key_index + 1) % KEY.len;
    }

    std.debug.print("\n", .{});

}
