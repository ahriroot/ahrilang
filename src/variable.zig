const BinaryOperate = @import("errors.zig").BinaryOperate;
const interpreter = @import("interpreter.zig");
const instruction = @import("instruction.zig");

const Frame = interpreter.Frame;
const Instruction = instruction.Instruction;

pub const Variable = union(enum) {
    Integer: i64,
    Float: f64,
    String: []const u8,
    Bool: bool,
    Null,
    Frame: *Frame,
    Array: []Variable,
    Instructions: []Instruction,
};

pub fn binaryAdd(first: Variable, second: Variable) BinaryOperate!Variable {
    switch (first) {
        Variable.Integer => |fir| switch (second) {
            Variable.Integer => |sec| return Variable{ .Integer = fir +% sec },
            Variable.Float => |sec| {
                var t: f64 = @floatFromInt(fir);
                return Variable{ .Float = t + sec };
            },
            else => return BinaryOperate.TypeError,
        },
        Variable.Float => |fir| switch (second) {
            Variable.Integer => |sec| {
                var t: f64 = @floatFromInt(sec);
                return Variable{ .Float = fir + t };
            },
            Variable.Float => |sec| return Variable{ .Float = fir + sec },
            else => return BinaryOperate.TypeError,
        },
        else => return BinaryOperate.TypeError,
    }
    return BinaryOperate.TypeError;
}

pub fn binarySub(first: Variable, second: Variable) BinaryOperate!Variable {
    switch (first) {
        Variable.Integer => |fir| switch (second) {
            Variable.Integer => |sec| return Variable{ .Integer = fir - sec },
            Variable.Float => |sec| {
                var t: f64 = @floatFromInt(fir);
                return Variable{ .Float = t - sec };
            },
            else => return BinaryOperate.TypeError,
        },
        Variable.Float => |fir| switch (second) {
            Variable.Integer => |sec| {
                var t: f64 = @floatFromInt(sec);
                return Variable{ .Float = fir - t };
            },
            Variable.Float => |sec| return Variable{ .Float = fir - sec },
            else => return BinaryOperate.TypeError,
        },
        else => return BinaryOperate.TypeError,
    }
    return BinaryOperate.TypeError;
}

pub fn binaryMul(first: Variable, second: Variable) BinaryOperate!Variable {
    switch (first) {
        Variable.Integer => |fir| switch (second) {
            Variable.Integer => |sec| return Variable{ .Integer = fir * sec },
            Variable.Float => |sec| {
                var t: f64 = @floatFromInt(fir);
                return Variable{ .Float = t * sec };
            },
            else => return BinaryOperate.TypeError,
        },
        Variable.Float => |fir| switch (second) {
            Variable.Integer => |sec| {
                var t: f64 = @floatFromInt(sec);
                return Variable{ .Float = fir * t };
            },
            Variable.Float => |sec| return Variable{ .Float = fir * sec },
            else => return BinaryOperate.TypeError,
        },
        else => return BinaryOperate.TypeError,
    }
    return BinaryOperate.TypeError;
}

pub fn binaryDiv(first: Variable, second: Variable) BinaryOperate!Variable {
    switch (first) {
        Variable.Integer => |fir| switch (second) {
            Variable.Integer => |sec| {
                var t1: f64 = @floatFromInt(fir);
                var t2: f64 = @floatFromInt(sec);
                return Variable{ .Float = t1 / t2 };
            },
            Variable.Float => |sec| {
                var t: f64 = @floatFromInt(fir);
                return Variable{ .Float = t / sec };
            },
            else => return BinaryOperate.TypeError,
        },
        Variable.Float => |fir| switch (second) {
            Variable.Integer => |sec| {
                var t: f64 = @floatFromInt(sec);
                return Variable{ .Float = fir / t };
            },
            Variable.Float => |sec| return Variable{ .Float = fir / sec },
            else => return BinaryOperate.TypeError,
        },
        else => return BinaryOperate.TypeError,
    }
    return BinaryOperate.TypeError;
}

pub fn binaryMod(first: Variable, second: Variable) BinaryOperate!Variable {
    switch (first) {
        Variable.Integer => |fir| switch (second) {
            Variable.Integer => |sec| return Variable{ .Integer = @mod(fir, sec) },
            Variable.Float => |sec| {
                var t: f64 = @floatFromInt(fir);
                return Variable{ .Float = @mod(t, sec) };
            },
            else => return BinaryOperate.TypeError,
        },
        Variable.Float => |fir| switch (second) {
            Variable.Integer => |sec| {
                var t: f64 = @floatFromInt(sec);
                return Variable{ .Float = @mod(fir, t) };
            },
            Variable.Float => |sec| return Variable{ .Float = @mod(fir, sec) },
            else => return BinaryOperate.TypeError,
        },
        else => return BinaryOperate.TypeError,
    }
    return BinaryOperate.TypeError;
}

pub fn binaryRem(first: Variable, second: Variable) BinaryOperate!Variable {
    switch (first) {
        Variable.Integer => |fir| switch (second) {
            Variable.Integer => |sec| return Variable{ .Integer = @rem(fir, sec) },
            Variable.Float => |sec| {
                var t: f64 = @floatFromInt(fir);
                return Variable{ .Float = @rem(t, sec) };
            },
            else => return BinaryOperate.TypeError,
        },
        Variable.Float => |fir| switch (second) {
            Variable.Integer => |sec| {
                var t: f64 = @floatFromInt(sec);
                return Variable{ .Float = @rem(fir, t) };
            },
            Variable.Float => |sec| return Variable{ .Float = @rem(fir, sec) },
            else => return BinaryOperate.TypeError,
        },
        else => return BinaryOperate.TypeError,
    }
    return BinaryOperate.TypeError;
}

pub fn binaryAnd(first: Variable, second: Variable) BinaryOperate!Variable {
    switch (first) {
        Variable.Bool => |fir| switch (second) {
            Variable.Bool => |sec| return Variable{ .Bool = fir and sec },
            else => return BinaryOperate.TypeError,
        },
        else => return BinaryOperate.TypeError,
    }
    return BinaryOperate.TypeError;
}

pub fn binaryOr(first: Variable, second: Variable) BinaryOperate!Variable {
    switch (first) {
        Variable.Bool => |fir| switch (second) {
            Variable.Bool => |sec| return Variable{ .Bool = fir or sec },
            else => return BinaryOperate.TypeError,
        },
        else => return BinaryOperate.TypeError,
    }
    return BinaryOperate.TypeError;
}

pub fn int(first: Variable) BinaryOperate!Variable {
    switch (first) {
        Variable.Integer => return first,
        Variable.Float => |fir| return Variable{ .Integer = @intFromFloat(fir) },
        else => return BinaryOperate.TypeError,
    }
    return BinaryOperate.TypeError;
}

pub fn float(first: Variable) BinaryOperate!Variable {
    switch (first) {
        Variable.Integer => |fir| return Variable{ .Float = @floatFromInt(fir) },
        Variable.Float => return first,
        else => return BinaryOperate.TypeError,
    }
    return BinaryOperate.TypeError;
}

pub fn boolean(first: Variable) BinaryOperate!Variable {
    switch (first) {
        Variable.Integer => |v| return Variable{ .Bool = v != 0 },
        Variable.Float => |v| return Variable{ .Bool = v != 0.0 },
        Variable.Bool => return first,
        else => return BinaryOperate.TypeError,
    }
    return BinaryOperate.TypeError;
}

pub fn equal(first: Variable, second: Variable) BinaryOperate!Variable {
    switch (first) {
        Variable.Integer => |fir| switch (second) {
            Variable.Integer => |sec| return Variable{ .Bool = fir == sec },
            Variable.Float => |sec| {
                var t: f64 = @floatFromInt(fir);
                return Variable{ .Bool = t == sec };
            },
            else => return BinaryOperate.TypeError,
        },
        Variable.Float => |fir| switch (second) {
            Variable.Integer => |sec| {
                var t: f64 = @floatFromInt(sec);
                return Variable{ .Bool = fir == t };
            },
            Variable.Float => |sec| return Variable{ .Bool = fir == sec },
            else => return BinaryOperate.TypeError,
        },
        Variable.Bool => |fir| switch (second) {
            Variable.Bool => |sec| return Variable{ .Bool = fir == sec },
            else => return BinaryOperate.TypeError,
        },
        else => return BinaryOperate.TypeError,
    }
    return BinaryOperate.TypeError;
}

pub fn eq(first: Variable, second: Variable) bool {
    var res = equal(first, second) catch return false;
    return res.Bool;
}

test "Variable Binary Add" {
    const std = @import("std");
    const expect = std.testing.expect;

    var a: Variable = Variable{ .Integer = 1 };
    var b: Variable = Variable{ .Integer = 2 };
    var c: Variable = Variable{ .Float = 1.0 };
    var d: Variable = Variable{ .Float = 2.0 };
    var max: Variable = Variable{ .Integer = 9223372036854775807 };

    try expect(eq(try binaryAdd(a, b), Variable{ .Integer = 3 }));
    try expect(eq(try binaryAdd(a, c), Variable{ .Float = 2.0 }));
    try expect(eq(try binaryAdd(a, d), Variable{ .Float = 3.0 }));
    try expect(eq(try binaryAdd(b, c), Variable{ .Float = 3.0 }));
    try expect(eq(try binaryAdd(b, d), Variable{ .Float = 4.0 }));
    try expect(eq(try binaryAdd(c, d), Variable{ .Float = 3.0 }));
    try expect(eq(try binaryAdd(max, a), Variable{ .Float = -9223372036854775808 }));
}

test "Variable Binary Sub" {
    const std = @import("std");
    const expect = std.testing.expect;

    var a: Variable = Variable{ .Integer = 1 };
    var b: Variable = Variable{ .Integer = 2 };
    var c: Variable = Variable{ .Float = 1.0 };
    var d: Variable = Variable{ .Float = 2.0 };

    try expect(((try equal(try binarySub(a, b), Variable{ .Integer = -1 })).Bool));
    try expect(((try equal(try binarySub(a, c), Variable{ .Float = 0.0 })).Bool));
    try expect(((try equal(try binarySub(a, d), Variable{ .Float = -1.0 })).Bool));
    try expect(((try equal(try binarySub(b, c), Variable{ .Float = 1.0 })).Bool));
    try expect(((try equal(try binarySub(b, d), Variable{ .Float = 0.0 })).Bool));
    try expect(((try equal(try binarySub(c, d), Variable{ .Float = -1.0 })).Bool));
}

test "Variable Binary Mul" {
    const std = @import("std");
    const expect = std.testing.expect;

    var a: Variable = Variable{ .Integer = 1 };
    var b: Variable = Variable{ .Integer = 2 };
    var c: Variable = Variable{ .Float = 1.0 };
    var d: Variable = Variable{ .Float = 2.0 };

    try expect(((try equal(try binaryMul(a, b), Variable{ .Integer = 2 })).Bool));
    try expect(((try equal(try binaryMul(a, c), Variable{ .Float = 1.0 })).Bool));
    try expect(((try equal(try binaryMul(a, d), Variable{ .Float = 2.0 })).Bool));
    try expect(((try equal(try binaryMul(b, c), Variable{ .Float = 2.0 })).Bool));
    try expect(((try equal(try binaryMul(b, d), Variable{ .Float = 4.0 })).Bool));
    try expect(((try equal(try binaryMul(c, d), Variable{ .Float = 2.0 })).Bool));
}

test "Variable Binary Div" {
    const std = @import("std");
    const expect = std.testing.expect;

    var a: Variable = Variable{ .Integer = 1 };
    var b: Variable = Variable{ .Integer = 2 };
    var c: Variable = Variable{ .Float = 1.0 };
    var d: Variable = Variable{ .Float = 2.0 };

    try expect(((try equal(try binaryDiv(a, b), Variable{ .Float = 0.5 })).Bool));
    try expect(((try equal(try binaryDiv(a, c), Variable{ .Float = 1.0 })).Bool));
    try expect(((try equal(try binaryDiv(a, d), Variable{ .Float = 0.5 })).Bool));
    try expect(((try equal(try binaryDiv(b, c), Variable{ .Float = 2.0 })).Bool));
    try expect(((try equal(try binaryDiv(b, d), Variable{ .Float = 1.0 })).Bool));
    try expect(((try equal(try binaryDiv(c, d), Variable{ .Float = 0.5 })).Bool));
}

test "Variable Binary Mod" {
    const std = @import("std");
    const expect = std.testing.expect;

    var a: Variable = Variable{ .Integer = 11 };
    var b: Variable = Variable{ .Integer = 5 };
    var c: Variable = Variable{ .Float = 7.5 };
    var d: Variable = Variable{ .Float = -3.5 };
    var e: Variable = Variable{ .Float = 1.5 };

    try expect(((try equal(try binaryMod(a, b), Variable{ .Integer = 1 })).Bool));
    try expect(((try equal(try binaryMod(a, c), Variable{ .Float = 3.5 })).Bool));
    try expect(((try equal(try binaryMod(a, d), Variable{ .Float = 0.5 })).Bool));
    try expect(((try equal(try binaryMod(a, e), Variable{ .Float = 0.5 })).Bool));
    try expect(((try equal(try binaryMod(b, c), Variable{ .Float = 5.0 })).Bool));
    try expect(((try equal(try binaryMod(b, d), Variable{ .Float = 1.5 })).Bool));
    try expect(((try equal(try binaryMod(b, e), Variable{ .Float = 0.5 })).Bool));
    try expect(((try equal(try binaryMod(c, d), Variable{ .Float = 0.5 })).Bool));
    try expect(((try equal(try binaryMod(c, e), Variable{ .Float = 0.0 })).Bool));
    try expect(((try equal(try binaryMod(d, e), Variable{ .Float = 1.0 })).Bool));
}

test "Variable Binary Rem" {
    const std = @import("std");
    const expect = std.testing.expect;

    var a: Variable = Variable{ .Integer = 11 };
    var b: Variable = Variable{ .Integer = 5 };
    var c: Variable = Variable{ .Float = 7.5 };
    var d: Variable = Variable{ .Float = -3.5 };
    var e: Variable = Variable{ .Float = 1.5 };

    try expect(((try equal(try binaryRem(a, b), Variable{ .Integer = 1 })).Bool));
    try expect(((try equal(try binaryRem(a, c), Variable{ .Float = 3.5 })).Bool));
    try expect(((try equal(try binaryRem(a, d), Variable{ .Float = 0.5 })).Bool));
    try expect(((try equal(try binaryRem(a, e), Variable{ .Float = 0.5 })).Bool));
    try expect(((try equal(try binaryRem(b, c), Variable{ .Float = 5.0 })).Bool));
    try expect(((try equal(try binaryRem(b, d), Variable{ .Float = 1.5 })).Bool));
    try expect(((try equal(try binaryRem(b, e), Variable{ .Float = 0.5 })).Bool));
    try expect(((try equal(try binaryRem(c, d), Variable{ .Float = 0.5 })).Bool));
    try expect(((try equal(try binaryRem(c, e), Variable{ .Float = 0.0 })).Bool));
    try expect(((try equal(try binaryRem(d, e), Variable{ .Float = -0.5 })).Bool));
}

test "Variable Binary And" {
    const std = @import("std");
    const expect = std.testing.expect;

    var a: Variable = Variable{ .Bool = true };
    var b: Variable = Variable{ .Bool = false };

    try expect(((try equal(try binaryAnd(a, a), Variable{ .Bool = true })).Bool));
    try expect(((try equal(try binaryAnd(a, b), Variable{ .Bool = false })).Bool));
    try expect(((try equal(try binaryAnd(b, a), Variable{ .Bool = false })).Bool));
    try expect(((try equal(try binaryAnd(b, b), Variable{ .Bool = false })).Bool));
}

test "Variable Binary Or" {
    const std = @import("std");
    const expect = std.testing.expect;

    var a: Variable = Variable{ .Bool = true };
    var b: Variable = Variable{ .Bool = false };

    try expect(((try equal(try binaryOr(a, a), Variable{ .Bool = true })).Bool));
    try expect(((try equal(try binaryOr(a, b), Variable{ .Bool = true })).Bool));
    try expect(((try equal(try binaryOr(b, a), Variable{ .Bool = true })).Bool));
    try expect(((try equal(try binaryOr(b, b), Variable{ .Bool = false })).Bool));
}

test "Variable To Int" {
    const std = @import("std");
    const expect = std.testing.expect;

    var a: Variable = Variable{ .Integer = 1 };
    var b: Variable = Variable{ .Float = 1.0 };
    var c: Variable = Variable{ .Float = 1.4 };
    var d: Variable = Variable{ .Float = 1.5 };
    var e: Variable = Variable{ .Float = 1.6 };

    try expect(((try equal(try int(a), Variable{ .Integer = 1 })).Bool));
    try expect(((try equal(try int(b), Variable{ .Integer = 1 })).Bool));
    try expect(((try equal(try int(c), Variable{ .Integer = 1 })).Bool));
    try expect(((try equal(try int(d), Variable{ .Integer = 1 })).Bool));
    try expect(((try equal(try int(e), Variable{ .Integer = 1 })).Bool));
}

test "Variable To Float" {
    const std = @import("std");
    const expect = std.testing.expect;

    var a: Variable = Variable{ .Float = 1.0 };
    var b: Variable = Variable{ .Integer = 1 };

    try expect(((try equal(try float(a), Variable{ .Float = 1.0 })).Bool));
    try expect(((try equal(try float(b), Variable{ .Float = 1.0 })).Bool));
}

test "Variable To Boolean" {
    const std = @import("std");
    const expect = std.testing.expect;

    var a: Variable = Variable{ .Integer = 0 };
    var b: Variable = Variable{ .Integer = 1 };
    var c: Variable = Variable{ .Float = 0.0 };
    var d: Variable = Variable{ .Float = 0.1 };
    var e: Variable = Variable{ .Bool = true };
    var f: Variable = Variable{ .Bool = false };

    try expect(((try equal(try boolean(a), Variable{ .Bool = false })).Bool));
    try expect(((try equal(try boolean(b), Variable{ .Bool = true })).Bool));
    try expect(((try equal(try boolean(c), Variable{ .Bool = false })).Bool));
    try expect(((try equal(try boolean(d), Variable{ .Bool = true })).Bool));
    try expect(((try equal(try boolean(e), Variable{ .Bool = true })).Bool));
    try expect(((try equal(try boolean(f), Variable{ .Bool = false })).Bool));
}
