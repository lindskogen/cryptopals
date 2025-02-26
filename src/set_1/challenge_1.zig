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

pub const standard_alphabet_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/".*;

fn bytesTo6BitStream(bytes: []const u8, output: *[256]u6) usize {
    var bit_buffer: u32 = 0; // Buffer to hold bits
    var bit_count: u8 = 0;   // Number of bits in buffer
    var output_index: usize = 0;

    for (bytes) |byte| {
        // Append the 8 bits from byte into the buffer
        bit_buffer = (bit_buffer << 8) | byte;
        bit_count += 8;

        // Extract 6-bit values from the buffer
        while (bit_count >= 6) {
            output[output_index] = @intCast((bit_buffer >> (@as(u5, @intCast(bit_count)) - 6)) & 0b111111);
            output_index += 1;
            bit_count -= 6;
        }
    }

    return output_index; // Number of 6-bit values generated
}

test "simple test" {
    const str = "49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d";
    var it = std.mem.window(u8, str, 2, 2);

    var hex: [str.len / 2]u8 = undefined;

    var i: usize = 0;
    while (it.next()) |pair| {
        const num = try std.fmt.parseInt(u8, pair, 16);
        hex[i] = num;
        i += 1;
    }

    var output : [256]u6 = undefined;
    const output_length = bytesTo6BitStream(&hex, &output);

    for (0..output_length) |h| {
        std.debug.print("{c}", .{ standard_alphabet_chars[output[h]] });
    }
    std.debug.print("\n", .{});


}
