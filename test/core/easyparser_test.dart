import 'package:test/test.dart' as unit;
import 'package:tiny_parser/data.dart';
import 'package:tiny_parser/parser.dart';
import 'package:tiny_parser/sample.dart';

void main() {
  unit.test("nextBuffer", () async {
    {
      ParserByteBuffer b = new ParserByteBuffer();
      b.addBytes([1, 2, 3, 4, 5]);
      Parser parser = new Parser(b);
      List<int> bb = await parser.getBytes(3);
      unit.expect(bb, [1, 2, 3]);
    }
  });

  unit.test("nextString", () async {
    {
      ParserByteBuffer b = new ParserByteBuffer();
      b.appendString("abc");
      Parser parser = new Parser(b);
      String bb = await parser.nextString("abc");
      unit.expect(bb, "abc");
    }
  });

  unit.test("readSign", () async {
    {
      ParserByteBuffer b = new ParserByteBuffer();
      b.appendString("abc");
      Parser parser = new Parser(b);
      String bb = await parser.readString(2);
      unit.expect(bb, "ab");
    }
  });

  unit.test("readShort", () async {
    {
      ParserByteBuffer b = new ParserByteBuffer();
      b.addBytes(ByteOrder.parseShortByte(10, ByteOrderType.BigEndian));
      Parser parser = new Parser(b);
      int bb = await parser.readShort(ByteOrderType.BigEndian);
      unit.expect(bb, 10);
    }
  });


  unit.test("readInt", () async {
    {
      ParserByteBuffer b = new ParserByteBuffer();
      b.addBytes(ByteOrder.parseIntByte(10, ByteOrderType.LittleEndian));
      Parser parser = new Parser(b);
      int bb = await parser.readInt(ByteOrderType.LittleEndian);
      unit.expect(bb, 10);
    }
  });

  unit.test("readLong", () async {
    {
      ParserByteBuffer b = new ParserByteBuffer();
      b.addBytes(ByteOrder.parseLongByte(10, ByteOrderType.LittleEndian));
      Parser parser = new Parser(b);
      int bb = await parser.readLong(ByteOrderType.LittleEndian);
      unit.expect(bb, 10);
    }
  });

  unit.test("readByte", () async {
    {
      ParserByteBuffer b = new ParserByteBuffer();
      b.addByte(10);
      Parser parser = new Parser(b);
      int bb = await parser.readByte();
      unit.expect(bb, 10);
    }
  });


  unit.test("readBytes", () async {
    {
      ParserByteBuffer b = new ParserByteBuffer();
      b.addBytes([1,2,3,4,5,6]);
      Parser parser = new Parser(b);
      List<int> out = [0,0,0,0,0,0,0,0,0,0,0];
      int b1 = await parser.readBytes(3, out, offset: 1);
      unit.expect(b1, 3);
      unit.expect(out.sublist(1,1+3),[1,2,3]);
      int b2 = await parser.readBytes(3, out, offset: 2);
      unit.expect(b2, 3);
      print("${out} ${parser.index}");
      unit.expect(out.sublist(2,2+3),[4,5,6]);
    }
  });

  unit.test("nextBuffer", () async {
    {
      ParserByteBuffer b = new ParserByteBuffer();
      b.addBytes([1,2,3,4,5,6]);
      Parser parser = new Parser(b);
      List<int> b1 = await parser.getBytes(3);
      unit.expect(b1, [1,2,3]);
      List<int> b2 = await parser.getBytes(3);
      unit.expect(b2, [4,5,6]);
    }
  });

}
