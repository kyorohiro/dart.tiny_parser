//import 'package:unittest/unittest.dart' as unit;
import 'package:tiny_parser/data.dart' as hetima;
import 'package:tiny_parser/parser.dart' as hetima;
import 'package:tiny_parser/sample.dart' as hetima;
import 'dart:async';
import 'package:test/test.dart' as unit;

void main() {
  unit.test("001",() async{
    hetima.ParserByteBuffer builder = new hetima.ParserByteBuffer();
    hetima.TinyParser parser = new hetima.TinyParser(builder);
    Future<hetima.HetiHttpRequestRange> f = hetima.HetiHttpResponse.decodeRequestRangeValue(parser);
    builder.appendString("bytes=0-100");
    //builder.fin();
    builder.loadCompleted = true;
    unit.expect(0, (await f).start);
    unit.expect(100, (await f).end);
  });

  unit.test("002",() async {
    hetima.ParserByteBuffer builder = new hetima.ParserByteBuffer();
    hetima.TinyParser parser = new hetima.TinyParser(builder);
    Future<hetima.HetiHttpRequestRange> f = hetima.HetiHttpResponse.decodeRequestRangeValue(parser);
    builder.appendString("bytes=0-");
    //builder.fin();
    builder.loadCompleted = true;

    unit.expect(0, (await f).start);
    unit.expect(-1, (await f).end);
  });
}