import 'package:test/test.dart' as unit;
import 'package:tiny_parser/markdown.dart' as markd;
import 'dart:convert' as convert;

import 'dart:async';
import 'package:tiny_parser/parser.dart' as core;
import 'package:tiny_parser/regex.dart' as reg;
import 'dart:convert' as conv;

void main() {

  unit.test("block", () async {
    core.ParserByteBuffer buffer = new core.ParserByteBuffer.fromList(conv.UTF8.encode("==="));
    core.TinyParser parser = new core.TinyParser(buffer);
    parser.buffer.loadCompleted = true;
    markd.Paragraph paragraph = new markd.Paragraph();
    markd.ParagraphObject object = await paragraph.parse(parser);
    unit.expect(object.value, "===");
  });
/*
  unit.test("main", () async {
    core.ParserByteBuffer buffer =
      new core.ParserByteBuffer.fromList(conv.UTF8.encode(
          "# sdf\r\n\r\n asdfasdf\r\n\r\n\0"));
    core.TinyParser parser = new core.TinyParser(buffer);

    markd.Markdown markdown = new markd.Markdown();
    await for(markd.MarkdownObject o in  markdown.parseFromParser(parser)) {
        print("^^^^---------->>");
    }

  });

  unit.test("heading1", () async {
    core.ParserByteBuffer buffer = new core.ParserByteBuffer.fromList(conv.UTF8.encode("# sdf\r\n"));
    core.TinyParser parser = new core.TinyParser(buffer);
    markd.Heading heading = new markd.Heading();
    markd.HeadingObject object = await heading.parse(parser);
    unit.expect(object.key, "#");
    unit.expect(object.value, "sdf");
  });

  unit.test("heading2", () async {
    core.ParserByteBuffer buffer = new core.ParserByteBuffer.fromList(conv.UTF8.encode("sdf\r\n----\r\n"));
    core.TinyParser parser = new core.TinyParser(buffer);
    markd.Heading2 heading = new markd.Heading2();
    markd.HeadingObject object = await heading.parse(parser);
    unit.expect(object.key, "----");
    unit.expect(object.value, "sdf");
  });

  unit.test("heading2", () async {
    core.ParserByteBuffer buffer = new core.ParserByteBuffer.fromList(conv.UTF8.encode("sdf\r\n===\r\n"));
    core.TinyParser parser = new core.TinyParser(buffer);
    markd.Heading3 heading = new markd.Heading3();
    markd.HeadingObject object = await heading.parse(parser);
    unit.expect(object.key, "===");
    unit.expect(object.value, "sdf");
  });

  unit.test("italic", () async {
    core.ParserByteBuffer buffer = new core.ParserByteBuffer.fromList(conv.UTF8.encode("*===*"));
    core.TinyParser parser = new core.TinyParser(buffer);
    markd.Italic bold = new markd.Italic();
    markd.ItalicObject object = await bold.parse(parser);
    unit.expect(object.value, "===");
  });

  unit.test("bold", () async {
    core.ParserByteBuffer buffer = new core.ParserByteBuffer.fromList(conv.UTF8.encode("**===**"));
    core.TinyParser parser = new core.TinyParser(buffer);
    markd.Bold bold = new markd.Bold();
    markd.BoldObject object = await bold.parse(parser);
    unit.expect(object.value, "===");
  });

  unit.test("block", () async {
    core.ParserByteBuffer buffer = new core.ParserByteBuffer.fromList(conv.UTF8.encode("===\0"));
    core.TinyParser parser = new core.TinyParser(buffer);
    parser.buffer.loadCompleted = true;
    markd.Paragraph paragraph = new markd.Paragraph();
    markd.ParagraphObject object = await paragraph.parse(parser);
    unit.expect(object.value, "===");
  });

  unit.test("lists", () async {
    core.ParserByteBuffer buffer = new core.ParserByteBuffer.fromList(conv.UTF8.encode(" * xxx\r\nasdf\0"));
    core.TinyParser parser = new core.TinyParser(buffer);
    parser.buffer.loadCompleted = true;
    markd.Lists lists = new markd.Lists();
    markd.ListsObject object = await lists.parse(parser);
    unit.expect(object.key, " *");
    unit.expect(object.value, "xxx\r\nasdf");
    print("key:${object.key}; value:${object.value}");
  });*/
}
