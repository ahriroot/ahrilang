const std = @import("std");

const errors = @import("errors.zig");
const instruction = @import("instruction.zig");
const variable = @import("variable.zig");

const BinaryOperate = errors.BinaryOperate;
const Instruction = instruction.Instruction;
const Variable = variable.Variable;
const binaryAdd = variable.binaryAdd;

pub const Frame = struct {
    consts: []Variable,
    code: []Instruction,
    stack: []Variable,
    top: usize,

    pub fn exec(self: *Frame) BinaryOperate!Variable {
        for (self.code) |value| {
            switch (value) {
                Instruction.LoadConst => |v| {
                    self.stack[self.top] = self.consts[v];
                    self.top += 1;
                },
                Instruction.BinaryAdd => |_| {
                    var a = self.stack[self.top - 2];
                    var b = self.stack[self.top - 1];
                    self.stack[self.top - 2] = try binaryAdd(a, b);
                    self.top -= 1;
                },
                Instruction.Return => |_| {
                    var r = self.stack[self.top - 1];
                    self.top -= 1;
                    return r;
                },
                Instruction.MakeFunction => |v| {
                    _ = v;
                    self.top -= 1;
                    var csts = self.stack[self.top];
                    self.top -= 1;
                    var co = self.stack[self.top];

                    var stack = [_]Variable{
                        Variable.Null,
                        Variable.Null,
                        Variable.Null,
                        Variable.Null,
                        Variable.Null,
                        Variable.Null,
                        Variable.Null,
                        Variable.Null,
                        Variable.Null,
                        Variable.Null,
                    };
                    var f = Frame{
                        .consts = csts.Array,
                        .code = co.Instructions,
                        .stack = stack[0..],
                        .top = 0,
                    };
                    self.stack[self.top] = Variable{ .Frame = &f };
                    self.top += 1;
                },
                Instruction.CallFunction => |v| {
                    _ = v;
                    self.top -= 1;
                    var f = self.stack[self.top];
                    var res = try f.Frame.exec();
                    self.stack[self.top] = res;
                    self.top += 1;
                },
                else => {
                    std.debug.print("else\n", .{});
                },
            }
        }
        return Variable.Null;
    }
};
