pub const Instruction = union(enum) {
    LoadBuiltin: usize,
    LoadConst: usize,
    LoadName: usize,
    StoreName: usize,
    BinaryAdd: usize,
    MakeFunction: usize,
    CallFunction: usize,
    Return,
};
