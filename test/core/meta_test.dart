import 'package:tiny_parser/sample.dart' as hetima;
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {

    setUp(() {
    });
/*
    test('not exist metadata', () async{
      String convertedText = await markd.markdownToHtml("# h1");
      print(convertedText);
    });
*/
    test('meta data1', () async {
      hetima.MarkdownData markdownData = await hetima.markdownToHtml(
          "---\r\n" // 0-5
              "a:b\r\n"  // 5-10
              "test:test\r\n" // 11-22
              "---\r\n"
              "# test\r\n"
              "Game programming\r\n");
      expect(markdownData.metadata["a"], "b");
      expect(markdownData.metadata["test"], "test");
      print(markdownData.html);
    });

    test('meta data2', () async {
      hetima.MarkdownData markdownData = await  hetima.markdownToHtml(
          "---\r\n" // 0-5
              "a:b\r\n"  // 5-10
              "test:test\r\n asdfasdf\r\n" // 11-22
              "---\r\n"
              "# test\r\n"
              "Game programming\r\n");
      expect(markdownData.metadata["a"], "b");
      expect(markdownData.metadata["test"], "test\r\nasdfasdf");
      print(markdownData.html);
    });
  });
}
