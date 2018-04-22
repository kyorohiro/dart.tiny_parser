library markdown;

import 'dart:async';
import 'parser.dart' as core;
import 'regex.dart' as reg;
import 'dart:convert' as conv;

class Markdown {

  reg.RegexVM headerPrefixReg = new reg.RegexVM.createFromPattern("(#)+( |\t)");
  reg.RegexVM crlfReg = new reg.RegexVM.createFromPattern("(\r\n|\n)");

  Stream<MarkdownObject> parse(String src) {
    core.ParserByteBuffer buffer = new core.ParserByteBuffer.fromList(conv.UTF8.encode(src));
    core.TinyParser parser = new core.TinyParser(buffer);
  }

  //
  // #
  //
  parseHeader1(parser) async {
    List<List<int>> ret = await headerPrefixReg.lookingAtFromEasyParser(parser);
    crlfReg.lookingAtFromEasyParser(parser);
  }
}

class MarkdownObject {

}