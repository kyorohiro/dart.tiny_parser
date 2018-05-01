library dart_hetimaparser_test_parser;

import 'package:tiny_parser/parser.dart' as pars;
import 'package:tiny_parser/regex.dart' as regex;
import 'package:test/test.dart';

import 'dart:convert' as conv;

void main() => script00();

void script00() {
  print("xx");
  group('parser00', () {
    test('char true a', () {
      regex.RegexVM italic1Reg = new regex.RegexVM.createFromPattern("\\*");
    });
  });
/*
    test('char true d', () {

      regex.RegexParser parser = new regex.RegexParser();
      return parser.compile("\n|\r\n").then((regex.RegexVM vm) {
        pars.TinyParser p =
        new pars.TinyParser(new pars.ParserByteBuffer.fromList(conv.UTF8.encode("ababc"), true));

        print(vm.toString());

        return vm.unmatchingAtFromEasyParser(p).then((List<int> v){
          print("xx = "+ conv.UTF8.decode(v));
          print("xx = "+ p.index.toString());
        });
      }).catchError((e) {
        expect(true, false);
      });
    });
  });
  */
}

//commentLong()
