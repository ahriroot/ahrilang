const std = @import("std");
const builtin = @import("builtin");
const BuildOptions = @import("build_options");

pub fn run(allocator: std.mem.Allocator, path: []const u8) !void {
    var file = (if (std.fs.path.isAbsolute(path))
        std.fs.openFileAbsolute(path, std.fs.File.OpenFlags{})
    else
        std.fs.cwd().openFile(path, .{})) catch {
        std.debug.print("File not found", .{});
        return error.FileNotFound;
    };
    defer file.close();

    var stat = try file.stat();
    var ctime = stat.ctime;
    var mtime = stat.mtime;
    var t_file = if (ctime > mtime) ctime else mtime;

    // 文件名加 'c'
    var path_cache = try allocator.alloc(u8, path.len + 1);
    defer allocator.free(path_cache);
    _ = std.mem.copy(u8, path_cache, path);
    path_cache[path.len] = 'c';

    var file_cache = (if (std.fs.path.isAbsolute(path_cache))
        std.fs.openFileAbsolute(path, std.fs.File.OpenFlags{})
    else
        std.fs.cwd().openFile(path, .{})) catch {
        // create file
        std.debug.print("File not found", .{});
        return error.FileNotFound;
    };

    var stat_cache = try file_cache.stat();
    var ctime_cache = stat_cache.ctime;
    var mtime_cache = stat_cache.mtime;
    var t_cache = if (ctime_cache > mtime_cache) ctime_cache else mtime_cache;

    if (t_cache >= t_file) {
        std.debug.print("Cache file is newer than source file\n", .{});
        return;
    } else {
        std.debug.print("Source file is newer than cache file\n", .{});
    }

    std.debug.print("File contents: {any}\n", .{try file.stat()});

    const source = try allocator.alloc(u8, (try file.stat()).size);
    defer allocator.free(source);

    _ = try file.readAll(source);

    std.debug.print("File contents: {s}\n", .{source});
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{ .safety = true }){};
    var allocator: std.mem.Allocator = if (builtin.mode == .Debug)
        gpa.allocator()
    else if (BuildOptions.mimalloc)
        @import("mimalloc.zig").mim_allocator
    else
        std.heap.c_allocator;

    try run(allocator, "test.txt");
}
