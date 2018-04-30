library markdown;

import 'dart:async';
import 'parser.dart' as core;
import 'regex.dart' as reg;
import 'dart:convert' as conv;

reg.RegexVM crlfReg = new reg.RegexVM.createFromPattern("(\r\n|\n)");
reg.RegexVM headerPrefixReg = new reg.RegexVM.createFromPattern("(#*)( |\t)");

class Markdown {

  Stream<MarkdownObject> parse(String src) {
    core.ParserByteBuffer buffer = new core.ParserByteBuffer.fromList(conv.UTF8.encode(src));
    core.TinyParser parser = new core.TinyParser(buffer);
  }

}

class Heading {
  //
  // #
  //
  Future<MarkdownObject> parseHeader1(parser) async {
    List<List<int>> ret = await headerPrefixReg.lookingAtFromEasyParser(parser);
    //crlfReg.lookingAtFromEasyParser(parser);
    return new HeadingObject(conv.UTF8.decode(ret[0]), "");
  }

}

class HeadingObject extends MarkdownObject {
  String key;
  String value;
  HeadingObject(this.key, this.value);
}

class MarkdownObject {

}


