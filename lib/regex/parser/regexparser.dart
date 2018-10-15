part of hetimaregex;


class RegexParser {

  Future<RegexVM> compile(String source) async {
    Completer<RegexVM> completer = new Completer();
    RegexLexer lexer = new RegexLexer();

    List<RegexToken> tokens = await lexer.scan(conv.utf8.encode(source));

    GroupPattern root = new GroupPattern(isSaveInMemory:false);
    List<GroupPattern> stack = [root];

    for (RegexToken t in tokens) {
      switch (t.kind) {
        case RegexToken.character:
          stack.last.addRegexNode(new CharacterPattern.fromBytes([t.value]));
          break;
        case RegexToken.eof:
          stack.last.addRegexNode(new EOFPattern());
          break;
        case RegexToken.lparan:
          GroupPattern l = new GroupPattern(isSaveInMemory:true);
          stack.last.addRegexNode(l);
          stack.add(l);
          break;
        case RegexToken.rparen:
          stack.removeLast();
          break;
        case RegexToken.star:
          stack.last.addRegexNode(new StarPattern.fromPattern(stack.last.elements.removeLast()));
          break;
        case RegexToken.union:
          stack.last.groupingCurrentElement();
          break;
      }
    }
    List<RegexCommand> ret = [];
    ret.addAll(root.convertRegexCommands());
    ret.add(new MatchCommand());
    RegexVM vm = new RegexVM.createFromCommand(ret);

    return vm;
  }

  RegexVM compileSync(String source) {
    RegexLexer lexer = new RegexLexer();
    List<RegexToken> tokens = lexer.scanSync(conv.utf8.encode(source));
    GroupPattern root = new GroupPattern(isSaveInMemory:false);
    List<GroupPattern> stack = [root];

    for (RegexToken t in tokens) {
      switch (t.kind) {
        case RegexToken.character:
          stack.last.addRegexNode(new CharacterPattern.fromBytes([t.value]));
          break;
        case RegexToken.eof:
          stack.last.addRegexNode(new EOFPattern());
          break;
        case RegexToken.lparan:
          GroupPattern l = new GroupPattern(isSaveInMemory:true);
          stack.last.addRegexNode(l);
          stack.add(l);
          break;
        case RegexToken.rparen:
          stack.removeLast();
          break;
        case RegexToken.star:
          stack.last.addRegexNode(new StarPattern.fromPattern(stack.last.elements.removeLast()));
          break;
        case RegexToken.union:
          stack.last.groupingCurrentElement();
          break;
      }
    }
    List<RegexCommand> ret = [];
    ret.addAll(root.convertRegexCommands());
    ret.add(new MatchCommand());
    RegexVM vm = new RegexVM.createFromCommand(ret);

    return vm;
  }
}
