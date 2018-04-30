part of hetimaregex;

class RegexVM {
  List<RegexCommand> _commands = [];
  List<RegexTask> _tasks = [];

  RegexVM.createFromCommand(List<RegexCommand> command) {
    _commands = new List.from(command);
  }

  factory RegexVM.createFromPattern(String pattern) {
    return (new RegexParser()).compileSync(pattern);
  }

  void addCommand(RegexCommand command) {
    print(command.toString());
    _commands.add(command);
  }

//  void _addTask(RegexTask task) {
//      _tasks.add(task);
//  }

  void _insertTask(int index, RegexTask task) {
    _tasks.insert(index, task);
  }

  String toString() {
    String ret = "";
    for (RegexCommand c in _commands) {
      ret += "${c.toString()}\n";
    }
    return ret;
  }

  bool hasCurrentTask() {
    if (_tasks.length > 0) {
      return true;
    } else {
      return false;
    }
  }

  RegexTask getCurrentTask() {
    if (hasCurrentTask()) {
      return _tasks[0];
    } else {
      throw new Exception("");
    }
  }

  RegexTask _eraseCurrentTask() {
    if (hasCurrentTask()) {
      RegexTask prevTask = _tasks[0];
      _tasks.removeAt(0);
      return prevTask;
    } else {
      throw new Exception("");
    }
  }

  Future<List<List<int>>> lookingAt(List<int> text) {
    heti.TinyParser parser = new heti.TinyParser(new heti.ParserByteBuffer.fromList(text, true));
    return lookingAtFromEasyParser(parser);
  }

  Future<List<List<int>>> lookingAtFromEasyParser(heti.TinyParser parser) async {
    _tasks.add(new RegexTask.fromCommnadPos(0, parser));
    do {
      if (!hasCurrentTask()) {
        throw "";
      }
      try {
        List<List<int>> v = await getCurrentTask().lookingAt(this);
        parser.resetIndex(getCurrentTask()._parseHelperWithTargetSource.index);
        _tasks.clear();
        return v;
      } catch(e) {
        _eraseCurrentTask();
      }
    } while(true);
  }
}
