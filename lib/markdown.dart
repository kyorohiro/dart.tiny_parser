library markdown;

import 'dart:async';
import 'parser.dart' as core;
import 'regex.dart' as reg;
import 'dart:convert' as conv;

reg.RegexVM crlfReg = new reg.RegexVM.createFromPattern("(\r\n|\n|\0)");
reg.RegexVM headingPrefixReg1 = new reg.RegexVM.createFromPattern("(#*)");
reg.RegexVM headingPrefixReg2 = new reg.RegexVM.createFromPattern("(----*)");
reg.RegexVM headingPrefixReg3 = new reg.RegexVM.createFromPattern("(====*)");

reg.RegexVM italic1Reg = new reg.RegexVM.createFromPattern("\\*");
reg.RegexVM italic2Reg = new reg.RegexVM.createFromPattern("\\*|\r\n|\n");
reg.RegexVM bold1Reg = new reg.RegexVM.createFromPattern("\\*\\*");
reg.RegexVM bold2Reg = new reg.RegexVM.createFromPattern("\\*\\*|\r\n|\n");

reg.RegexVM spacePrefixReg = new reg.RegexVM.createFromPattern("( |\t)");

reg.RegexVM paragraphReg = new reg.RegexVM.createFromPattern("(\r\n\r\n|\n\n|\0)");

reg.RegexVM listsPrefixReg1 = new reg.RegexVM.createFromPattern("( *|\t*)(-|+|\\*)( |\t)( *|\t*)");


class Markdown {

  Stream<MarkdownObject> parseFromParser(core.TinyParser parser) async *{
    // extract block
    Paragraph paragraph = new Paragraph();
    while(!parser.isEOF()) {
      MarkdownObject obj = await paragraph.parse(parser);
      yield obj;
    }
  }

}

class Lists {
  //
  // *
  //
  Future<MarkdownObject> parse(core.TinyParser parser) async {
    List<List<int>>  x = await listsPrefixReg1.lookingAtFromEasyParser(parser);
    List<int> value = [];
    List<int> v= await crlfReg.unmatchingAtFromEasyParser(parser);
    value.addAll(v);
    await crlfReg.lookingAtFromEasyParser(parser);

    //
    while(!parser.isEOF() &&!await listsPrefixReg1.isMatched(parser) && !await crlfReg.isMatched(parser)) {
      //print("================> a ${parser.index}");
      List<int> v = await crlfReg.unmatchingAtFromEasyParser(parser);
      await crlfReg.lookingAtFromEasyParser(parser);
      value.addAll([13,10]);
      value.addAll(v);
    }

    return new ListsObject(conv.UTF8.decode(x[0])+conv.UTF8.decode(x[1]), conv.UTF8.decode(value));
  }
}


class Paragraph {
  //
  // (!?\r\n\r\n|\n\n)(\r\n\r\n|\n\n|)
  //
  Future<MarkdownObject> parse(parser) async {
    List<int> value = await paragraphReg.unmatchingAtFromEasyParser(parser);
    await paragraphReg.lookingAtFromEasyParser(parser);
    return new ParagraphObject(conv.UTF8.decode(value));
  }
}

class Italic {
  //
  // \*(?!\*|\r\n\r\n|\n\n)\*
  //
  Future<MarkdownObject> parse(parser) async {
    await italic1Reg.lookingAtFromEasyParser(parser);
    List<int> value = await italic2Reg.unmatchingAtFromEasyParser(parser);
    await italic1Reg.lookingAtFromEasyParser(parser);
    return new ItalicObject(conv.UTF8.decode(value));
  }
}


class Bold {
  //
  // \*\*(?!\*\*|\r\n\r\n|\n\n)*\*\*
  //
  Future<MarkdownObject> parse(parser) async {
    await bold1Reg.lookingAtFromEasyParser(parser);
    List<int> value = await bold2Reg.unmatchingAtFromEasyParser(parser);
    await bold1Reg.lookingAtFromEasyParser(parser);
    return new BoldObject(conv.UTF8.decode(value));
  }
}


class Heading {
  //
  // ##*( |\t)*(?!\r\n|\n)(\r\n|\n)
  //
  Future<MarkdownObject> parse(parser) async {
    List<List<int>> heading = await headingPrefixReg1.lookingAtFromEasyParser(parser);
    await spacePrefixReg.lookingAtFromEasyParser(parser);
    List<int> value = await crlfReg.unmatchingAtFromEasyParser(parser);
    await crlfReg.lookingAtFromEasyParser(parser);
    return new HeadingObject(conv.UTF8.decode(heading[0]), conv.UTF8.decode(value));
  }

}

class Heading2 {
  //
  // (?!\r\n|\n)(\r\n|\n)----*(\r\n|\n)
  //
  Future<MarkdownObject> parse(parser) async {
    List<int> value = await crlfReg.unmatchingAtFromEasyParser(parser);
    await crlfReg.lookingAtFromEasyParser(parser);
    List<List<int>> heading = await headingPrefixReg2.lookingAtFromEasyParser(parser);
    await crlfReg.lookingAtFromEasyParser(parser);
    return new HeadingObject(conv.UTF8.decode(heading[0]), conv.UTF8.decode(value));
  }
}



class Heading3 {
  //
  // (?!\r\n|\n)(\r\n|\n)====*(\r\n|\n)
  //
  Future<MarkdownObject> parse(parser) async {
    List<int> value = await crlfReg.unmatchingAtFromEasyParser(parser);
    await crlfReg.lookingAtFromEasyParser(parser);
    List<List<int>> heading = await headingPrefixReg3.lookingAtFromEasyParser(parser);
    await crlfReg.lookingAtFromEasyParser(parser);
    return new HeadingObject(conv.UTF8.decode(heading[0]), conv.UTF8.decode(value));
  }
}

class HeadingObject extends MarkdownObject {
  String key;
  String value;
  HeadingObject(this.key, this.value);
}

class ItalicObject extends MarkdownObject {
  String value;
  ItalicObject(this.value);
}

class BoldObject extends MarkdownObject {
  String value;
  BoldObject(this.value);
}

class ParagraphObject extends MarkdownObject {
  String value;
  ParagraphObject(this.value);
}

class ListsObject extends MarkdownObject {
  String key;
  String value;
  ListsObject(this.key, this.value);
}

class MarkdownObject {

}

