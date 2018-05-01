part of hetimaregex;

abstract class RegexCommand {
  Future<List<int>> check(RegexVM vm, heti.TinyParser parser);
}

class MemoryStartCommand extends RegexCommand {
  Future<List<int>> check(RegexVM vm, heti.TinyParser parser) {
    Completer<List<int>> c = new Completer();
    RegexTask currentTask = vm.getCurrentTask();
    int index = currentTask._nextMemoryId;
    currentTask._nextMemoryId++;
    currentTask._memory.add([]);
    currentTask._currentMemoryTargetId.add(index);
    currentTask._nextCommandLocation++;
    c.complete([]);
    return c.future;
  }

  String toString() {
    return "<memory start>";
  }
}

class MemoryStopCommand extends RegexCommand {
  Future<List<int>> check(RegexVM vm, heti.TinyParser parser) {
    Completer<List<int>> c = new Completer();
    RegexTask currentTask = vm.getCurrentTask();
    currentTask._currentMemoryTargetId.removeLast();
    currentTask._nextCommandLocation++;
    c.complete([]);
    return c.future;
  }

  String toString() {
    return "<memory stop>";
  }
}

class MatchCommandNotification extends Error {
  MatchCommandNotification(dynamic mes) {}
}

class MatchCommand extends RegexCommand {
  Future<List<int>> check(RegexVM vm, heti.TinyParser parser) {
    Completer<List<int>> c = new Completer();
    c.completeError(new MatchCommandNotification(""));
    return c.future;
  }
  String toString() {
    return "<match>";
  }
}

class UnmatchCommand extends RegexCommand {
  Future<List<int>> check(RegexVM vm, heti.TinyParser parser) {
    Completer<List<int>> c = new Completer();
    c.completeError(new Exception(""));
    return c.future;
  }
  String toString() {
    return "<unmatch>";
  }
}


class JumpTaskCommand extends RegexCommand {
  static final int LM1 = -1;
  static final int L0 = 0;
  static final int L1 = 1;
  static final int L2 = 2;
  static final int L3 = 3;
  int _pos1 = 0;

  JumpTaskCommand.create(int pos1) {
    _pos1 = pos1;
  }

  Future<List<int>> check(RegexVM vm, heti.TinyParser parser) {
    Completer<List<int>> c = new Completer();
    RegexTask currentTask = vm.getCurrentTask();
    if (currentTask == null) {
      throw new Exception("");
    }

    int currentPos = currentTask._nextCommandLocation;
    currentTask._nextCommandLocation = currentPos + _pos1;
    c.complete([]);
    return c.future;
  }

  String toString() {
    return "<jump ${_pos1}>";
  }
}

class SplitTaskCommand extends RegexCommand {
  static final int LM1 = -1;
  static final int L0 = 0;
  static final int L1 = 1;
  static final int L2 = 2;
  static final int L3 = 3;
  int _pos1 = 0;
  int _pos2 = 0;

  SplitTaskCommand.create(int pos1, int pos2) {
    _pos1 = pos1;
    _pos2 = pos2;
  }

  Future<List<int>> check(RegexVM vm, heti.TinyParser parser) {
    Completer<List<int>> c = new Completer();
    RegexTask currentTask = vm.getCurrentTask();
    if (currentTask == null) {
      throw new Exception("");
    }

    int currentPos = currentTask._nextCommandLocation;
    currentTask._nextCommandLocation = currentPos + _pos1;
    vm._insertTask(1, new RegexTask.clone(currentTask, currentPos + _pos2));

    c.complete([]);
    return c.future;
  }

  String toString() {
    return "<split ${_pos1} ${_pos2}>";
  }
}

class CharCommand extends RegexCommand {
  List<int> _expect = [];
  CharCommand.createFromList(List<int> v) {
    _expect = new List.from(v);
  }

  Future<List<int>> check(RegexVM vm, heti.TinyParser parser) async {
    print("CHAR-----------${_expect}");
    int length = _expect.length;
    parser.push();
    List<int> v = await parser.getBytesAsync(length);
    if (v.length != length) {
      parser.back();
      parser.pop();
      throw new Exception("");
    }
    for (int i = 0; i < length; i++) {
      if (_expect[i] != v[i]) {
        parser.back();
        parser.pop();
        throw new Exception("");
      }
    }
    parser.pop();
    RegexTask t = vm.getCurrentTask();
    t._nextCommandLocation++;
    return v;
  }

  String toString() {
    return "<char ${_expect}>";
  }
}

class EOFCommand extends RegexCommand {
  EOFCommand() {
    print("EOF-------==");
  }

  Future<List<int>> check(RegexVM vm, heti.TinyParser parser) async {
    print("EOF-----------");
    if(!parser.isEOF()) {
      throw "";
    }
    RegexTask t = vm.getCurrentTask();
    t._nextCommandLocation++;
    return [];
  }

  String toString() {
    return "<eof>";
  }
}