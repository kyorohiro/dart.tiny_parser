import 'package:test/test.dart' as unit;
import 'package:tiny_parser/markdown.dart' as markd;
import 'dart:convert' as convert;

import 'dart:async';
import 'package:tiny_parser/parser.dart' as core;
import 'package:tiny_parser/regex.dart' as reg;
import 'dart:convert' as conv;

void main() {
  unit.test("ps1", () async {
    core.ParserByteBuffer buffer = new core.ParserByteBuffer.fromList(conv.UTF8.encode("##  sdf\r\n"));
    core.TinyParser parser = new core.TinyParser(buffer);
    markd.Heading heading = new markd.Heading();
    markd.HeadingObject object = await heading.parseHeader1(parser);
    print(object.key);
  });
}
