library dart_hetimaparser_test_parser;

import 'package:tiny_parser/regex.dart' as regex;
import 'package:test/test.dart';

import 'dart:convert' as conv;

void main() => script00();

void script00() {
  group('parser00', () {
    test('char true a', () {
      regex.RegexParser parser = new regex.RegexParser();
      return parser.compile("aa").then((regex.RegexVM vm) {
        return vm.lookingAt(conv.utf8.encode("aabb")).then((List<List<int>> v){
          expect(true, true);
        });
      }).catchError((e) {
        expect(true, false);
      });
    });
    test('char true b', () {
      regex.RegexParser parser = new regex.RegexParser();
      return parser.compile("(aa)").then((regex.RegexVM vm) {
        return vm.lookingAt(conv.utf8.encode("aabb")).then((List<List<int>> v){
          //expect(true, true);
          expect(conv.utf8.decode(v[0]),"aa");
        });
      }).catchError((e) {
        expect(true, false);
      });
    });
    test('char true c', () {
      regex.RegexParser parser = new regex.RegexParser();
      return parser.compile("(a*)").then((regex.RegexVM vm) {
        return vm.lookingAt(conv.utf8.encode("aaabb")).then((List<List<int>> v){
          expect(conv.utf8.decode(v[0]),"aaa");
        });
      }).catchError((e) {
        expect(true, false);
      });
    });
    test('char true c1', () {
      regex.RegexParser parser = new regex.RegexParser();
      return parser.compile("(a*)b").then((regex.RegexVM vm) {
        return vm.lookingAt(conv.utf8.encode("aaabb")).then((List<List<int>> v){
          expect(conv.utf8.decode(v[0]),"aaa");
        });
      }).catchError((e) {
        expect(true, false);
      });
    });

    test('char true d', () {
      regex.RegexParser parser = new regex.RegexParser();
      return parser.compile("(ab)*").then((regex.RegexVM vm) {
        print(vm.toString());
        return vm.lookingAt(conv.utf8.encode("ababc")).then((List<List<int>> v){
          expect(conv.utf8.decode(v[0]),"ab");
          expect(conv.utf8.decode(v[1]),"ab");
        });
      }).catchError((e) {
        expect(true, false);
      });
    });

    test('char true d', () {
      regex.RegexParser parser = new regex.RegexParser();
      return parser.compile("(abc)*d").then((regex.RegexVM vm) {
        return vm.lookingAt(conv.utf8.encode("abcabcd")).then((List<List<int>> v){
          expect(conv.utf8.decode(v[0]),"abc");
          expect(conv.utf8.decode(v[1]),"abc");
        });
      }).catchError((e) {
        expect(true, false);
      });
    });
    test('char true d', () {
      regex.RegexParser parser = new regex.RegexParser();
      return parser.compile("((abc)*d)").then((regex.RegexVM vm) {
        return vm.lookingAt(conv.utf8.encode("abcabcd")).then((List<List<int>> v){
          expect(conv.utf8.decode(v[0]),"abcabcd");
          expect(conv.utf8.decode(v[1]),"abc");
          expect(conv.utf8.decode(v[2]),"abc");
        });
      }).catchError((e) {
        expect(true, false);
      });
    });
    test('char true d', () {
      regex.RegexParser parser = new regex.RegexParser();
      return parser.compile("abc|def").then((regex.RegexVM vm) {
        print("${vm}");
        return vm.lookingAt(conv.utf8.encode("abcabc")).then((List<List<int>> v){
          expect(v.length,0);
        });
      }).catchError((e) {
        expect(true, false);
      });
    });

    test('char true d', () {
      regex.RegexParser parser = new regex.RegexParser();
      return parser.compile("(abc|def)").then((regex.RegexVM vm) {
        return vm.lookingAt(conv.utf8.encode("abcabc")).then((List<List<int>> v){
          expect(conv.utf8.decode(v[0]),"abc");
        });
      }).catchError((e) {
        expect(true, false);
      });
    });

    test('char true d', () {
      regex.RegexParser parser = new regex.RegexParser();
      return parser.compile("(abc|def)").then((regex.RegexVM vm) {
        return vm.lookingAt(conv.utf8.encode("defabc")).then((List<List<int>> v){
          expect(conv.utf8.decode(v[0]),"def");
        });
      }).catchError((e) {
        expect(true, false);
      });
    });

    test('char true e', () {
      regex.RegexParser parser = new regex.RegexParser();
      return parser.compile("(\r\n|\n)").then((regex.RegexVM vm) {
        return vm.lookingAt(conv.utf8.encode("\r\n")).then((List<List<int>> v){
          expect(conv.utf8.decode(v[0]),"\r\n");
        });
      }).catchError((e) {
        expect(true, false);
      });
    });

    test('char true f', () async {
      regex.RegexParser parser = new regex.RegexParser();
      regex.RegexVM vm = await parser.compile("(xx)\$");
      try {
        List<List<int>> v = await  vm.lookingAt(conv.utf8.encode("xx"));
        expect(conv.utf8.decode(v[0]),"xx");
      } catch(e) {
        expect(true, false);
      }
    });

    test('char true g', () async {
      regex.RegexParser parser = new regex.RegexParser();
      regex.RegexVM vm = await parser.compile("xx(\n|\$)");
      print(vm);
      try {
        List<List<int>> v = await vm.lookingAt(conv.utf8.encode("xx"));
        expect(conv.utf8.decode(v[0]),"");
      } catch(e) {
        expect(true, false);
      }
    });

    test('char true h', () async {
      regex.RegexParser parser = new regex.RegexParser();
      regex.RegexVM vm = await parser.compile("(\n|\$)");
      print(vm);
      try {
        List<List<int>> v = await vm.lookingAt(conv.utf8.encode(""));
        expect(conv.utf8.decode(v[0]),"");
      } catch(e) {
        expect(true, false);
      }
    });
  });
}

//commentLong()
