/// OpCodes for the DartNative Go Stack Virtual Machine.
abstract final class OpCode {
  static const int nop = 0x00;
  static const int pushConst = 0x01; // [u16 constIndex]
  static const int pushNull = 0x02;
  static const int pushTrue = 0x03;
  static const int pushFalse = 0x04;
  static const int pushInt = 0x05; // [i32 inlineVal]
  static const int pop = 0x06;
  static const int dup = 0x07;
  static const int loadLocal = 0x08; // [u16 slotIndex]
  static const int storeLocal = 0x09; // [u16 slotIndex]
  static const int loadGlobal = 0x0A; // [u16 nameConstIndex]
  static const int storeGlobal = 0x0B; // [u16 nameConstIndex]
  static const int loadField = 0x0C; // [u16 nameConstIndex]
  static const int storeField = 0x0D; // [u16 nameConstIndex]
  static const int loadIndex = 0x0E;
  static const int storeIndex = 0x0F;
  static const int makeList = 0x10; // [u16 count]
  static const int makeMap = 0x11; // [u16 entryCount]
  static const int makeClosure = 0x12; // [u32 funcId, u16 captureCount]
  static const int callInterpreted = 0x13; // [u32 funcId, u8 argCount, u8 namedCount]
  static const int callMethod = 0x14; // [u16 nameConstIndex, u8 argCount, u8 namedCount]
  static const int callBridged = 0x15; // [u16 targetConstIndex, u8 argCount, u8 namedCount]
  static const int jump = 0x16; // [i32 offset]
  static const int jumpIfFalse = 0x17; // [i32 offset]
  static const int jumpIfTrue = 0x18; // [i32 offset]
  static const int jumpIfNull = 0x19; // [i32 offset]
  static const int ret = 0x1A; // return null
  static const int retValue = 0x1B; // return top of stack
  static const int typeCheck = 0x1C; // [u16 typeConstIndex]
  static const int typeCast = 0x1D; // [u16 typeConstIndex]
  static const int unaryOp = 0x1E; // [u8 unaryOpId]
  static const int binaryOp = 0x1F; // [u8 binaryOpId]
  static const int tryCatchBegin = 0x20; // [i32 catchOffset]
  static const int tryCatchEnd = 0x21;
  static const int throwEx = 0x22;
  static const int callConstructor = 0x23; // [u16 classConstIndex, u16 ctorNameConstIndex, u8 argCount, u8 namedCount]
  static const int makeEmptyList = 0x24;
  static const int listAdd = 0x25;
  static const int listAddAll = 0x26;
  static const int makeEmptyMap = 0x27;
  static const int mapPut = 0x28;
  static const int mapPutAll = 0x29;

  static String nameOf(int op) => switch (op) {
        nop => 'Nop',
        pushConst => 'PushConst',
        pushNull => 'PushNull',
        pushTrue => 'PushTrue',
        pushFalse => 'PushFalse',
        pushInt => 'PushInt',
        pop => 'Pop',
        dup => 'Dup',
        loadLocal => 'LoadLocal',
        storeLocal => 'StoreLocal',
        loadGlobal => 'LoadGlobal',
        storeGlobal => 'StoreGlobal',
        loadField => 'LoadField',
        storeField => 'StoreField',
        loadIndex => 'LoadIndex',
        storeIndex => 'StoreIndex',
        makeList => 'MakeList',
        makeMap => 'MakeMap',
        makeClosure => 'MakeClosure',
        callInterpreted => 'CallInterpreted',
        callMethod => 'CallMethod',
        callBridged => 'CallBridged',
        callConstructor => 'CallConstructor',
        makeEmptyList => 'MakeEmptyList',
        listAdd => 'ListAdd',
        listAddAll => 'ListAddAll',
        makeEmptyMap => 'MakeEmptyMap',
        mapPut => 'MapPut',
        mapPutAll => 'MapPutAll',
        jump => 'Jump',
        jumpIfFalse => 'JumpIfFalse',
        jumpIfTrue => 'JumpIfTrue',
        jumpIfNull => 'JumpIfNull',
        ret => 'Return',
        retValue => 'ReturnValue',
        typeCheck => 'TypeCheck',
        typeCast => 'TypeCast',
        unaryOp => 'UnaryOp',
        binaryOp => 'BinaryOp',
        tryCatchBegin => 'TryCatchBegin',
        tryCatchEnd => 'TryCatchEnd',
        throwEx => 'Throw',
        _ => 'Unknown($op)',
      };
}

abstract final class UnaryOpId {
  static const int not = 0x01; // !x
  static const int neg = 0x02; // -x
  static const int bitNot = 0x03; // ~x

  static String nameOf(int id) => switch (id) {
        not => '!',
        neg => '-',
        bitNot => '~',
        _ => 'UnknownUnary($id)',
      };
}

abstract final class BinaryOpId {
  static const int add = 0x01; // +
  static const int sub = 0x02; // -
  static const int mul = 0x03; // *
  static const int div = 0x04; // /
  static const int truncDiv = 0x05; // ~/
  static const int mod = 0x06; // %
  static const int eq = 0x07; // ==
  static const int neq = 0x08; // !=
  static const int lt = 0x09; // <
  static const int lte = 0x0A; // <=
  static const int gt = 0x0B; // >
  static const int gte = 0x0C; // >=
  static const int bitAnd = 0x0D; // &
  static const int bitOr = 0x0E; // |
  static const int bitXor = 0x0F; // ^
  static const int shl = 0x10; // <<
  static const int shr = 0x11; // >>
  static const int identical = 0x12; // identical()

  static String nameOf(int id) => switch (id) {
        add => '+',
        sub => '-',
        mul => '*',
        div => '/',
        truncDiv => '~/',
        mod => '%',
        eq => '==',
        neq => '!=',
        lt => '<',
        lte => '<=',
        gt => '>',
        gte => '>=',
        bitAnd => '&',
        bitOr => '|',
        bitXor => '^',
        shl => '<<',
        shr => '>>',
        identical => 'identical',
        _ => 'UnknownBinary($id)',
      };
}
