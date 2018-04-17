part of hetimacore;



Future<MarkdownData> markdownToHtml(String markdownSrc) async {
  //
  //
  MarkdownData markdownData = new MarkdownData();
  markdownData.src = markdownSrc;

  Metadata meta = new Metadata.create();
  await meta.parse(markdownSrc);
  markdownData.metadata = meta.metadata;

  markdownData.html = "dummy";
  return markdownData;
}

class MarkdownData {
  String src;
  String html;
  Map<String, String> metadata;
}

class Metadata {
  pars.ParserByteBuffer reader;
  pars.EasyParser parser;
  Map<String,String> metadata = {};
  String content = "";

  Metadata.create() {
  }

  Future<int> parse(String source) async {
    content = source;
    reader = new pars.ParserByteBuffer();
    parser = new pars.EasyParser(reader);
    reader.addBytes(conv.UTF8.encode(source));
    reader.loadCompleted = true;
    int ret = await encMetadata(parser);
    content = source.substring(ret);
    return ret;
  }

  Future<int> encMetadata(pars.EasyParser parser) async {
    try {
      parser.push();

      //
      // --- crlf
      await parser.nextString("---");await encSpace(parser);await encCrlf(parser);

      //
      // <xxx> : <yyy> crlf
      do{
        if(0 != await parser.checkBytesFromMatchBytes(conv.UTF8.encode(" \t")));
        await encKeyVaklue(parser);
      } while(0 == await parser.checkString("---"));

      //
      // --- crlf
      await parser.nextString("---");await encSpace(parser);await encCrlf(parser);

      parser.pop();
      return parser.index;
    } catch(e) {
      parser.back();
      parser.pop();
      return parser.index;
    }
  }

  Future<bool> encKeyVaklue(pars.EasyParser parser) async {
    String k = await encKey(parser);
    await parser.nextString(":");
    var v = await encValue(parser);
    await encSpace(parser);
    await encCrlf(parser);
    metadata[k] = v;
  }

  Future<String> encKey(pars.EasyParser parser) async {
    int start = parser.index;
    int end = parser.index;
    if(0!=await parser.checkString(" ")) {
      throw "";
    }
    List<int> v = await parser.matchBytesFromBytes(conv.UTF8.encode(":\n"), expectedMatcherResult: false);
    return conv.UTF8.decode(v, allowMalformed: true);
  }

  Future<String> encValue(pars.EasyParser parser) async {
    List<int> v = await parser.matchBytesFromBytes(conv.UTF8.encode("\r\n"), expectedMatcherResult: false);
    String ret = conv.UTF8.decode(v);

    if(0 == await parser.checkString("\n---") &&
        0 == await parser.checkString("\r\n---") &&
        (0 != await parser.checkString("\r\n ") || 0 != await parser.checkString("\r\n\t"))
    ) {
      return ret + await encCrlf(parser) + (await encSpace(parser)?"":"") + await encValue(parser);
    }
    else {
      return ret;
    }
  }

  Future<String> encCrlf(pars.EasyParser parser) async {
    int nextIndex = 0;
    if( 0!= (nextIndex= parser.checkString("\r\n")) || 0!=(nextIndex = parser.checkString("\n"))) {
      parser.resetIndex(parser.index +nextIndex);
      return (nextIndex == 1?"\n":"\r\n");
    } else {
      throw "";
    }
  }

  Future<bool> encSpace(pars.EasyParser parser) async {
    try {
      do {
        List<int> v = parser.matchBytesFromBytes(conv.UTF8.encode(" \t"));
        if(v.length == 0) {
          break;
        }
      } while(true);
      return true;
    } catch(e) {
      return false;
    }
  }
}