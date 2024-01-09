const std = @import("std");
const interpreter = @import("interpreter.zig");
const instruction = @import("instruction.zig");
const variable = @import("variable.zig");

const Frame = interpreter.Frame;
const Instruction = instruction.Instruction;
const Variable = variable.Variable;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = gpa.allocator();
    defer {
        const deinit_status = gpa.deinit();
        if (deinit_status == .leak) @panic("Allocator leaked memory!");
    }

    var insts = [_]Instruction{
        Instruction{ .LoadConst = 0 },
        Instruction{ .LoadConst = 1 },
        Instruction{ .BinaryAdd = 2 },
        Instruction.Return,
    };

    var code = [_]Instruction{
        Instruction{ .LoadConst = 0 },
        Instruction{ .LoadConst = 1 },
        Instruction{ .MakeFunction = 2 },
        Instruction{ .CallFunction = 0 },
        Instruction.Return,
    };

    var csts = [_]Variable{
        Variable{ .Integer = 1 },
        Variable{ .Integer = 2 },
    };

    var consts = [_]Variable{
        Variable{ .Instructions = &insts },
        Variable{ .Array = &csts },
    };

    var stack = try allocator.alloc(Variable, 20);

    defer allocator.free(stack);

    var frame = Frame{
        .code = &code,
        .consts = &consts,
        .stack = stack,
        .top = 0,
    };

    var res = try frame.exec();
    std.debug.print("res: {}\n", .{res});
}
