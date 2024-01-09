const std = @import("std");

pub var gpa = std.heap.GeneralPurposeAllocator(.{}){};

pub var allocator = gpa.allocator();
