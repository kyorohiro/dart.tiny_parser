library dart_hetimaparser_test_parser;

import 'package:tiny_parser/parser.dart' as pars;
import 'package:tiny_parser/regex.dart' as regex;
import 'package:test/test.dart';

import 'dart:convert' as conv;

void main() => script00();

void script00() {
  print("xx");
  group('parser00', () {
    /*
    test('char true a', () {
      pars.Parser parser = new pars.Parser(new pars.ParserByteBuffer.fromList(conv.UTF8.encode("aabb"), true));
      regex.RegexParser regParser = new regex.RegexParser();
      return regParser.compile("a").then((regex.RegexVM vm) {
        return vm.lookingAtFromEasyParser(parser).then((List<List<int>> v){
          print("xx = "+ parser.index.toString());
          expect(true, true);
        });
      }).catchError((e) {
        expect(true, false);
      });
    });
*/

    test('char true d', () {

      regex.RegexParser parser = new regex.RegexParser();
      return parser.compile("\n|\r\n").then((regex.RegexVM vm) {
        pars.TinyParser p =
        new pars.TinyParser(new pars.ParserByteBuffer.fromList(conv.UTF8.encode("ababc\r\n"), true));

        print(vm.toString());
/*        return vm.lookingAtFromEasyParser(p).then((List<List<int>> v){
          print("xx = ${v}");
          print("xx = "+ p.index.toString());
        });*/
        return vm.unmatchingAtFromEasyParser(p).then((List<int> v){
          print("xx = "+ conv.UTF8.decode(v));
          print("xx = "+ p.index.toString());
        });
      }).catchError((e) {
        expect(true, false);
      });
    });
  });
}

//commentLong()
