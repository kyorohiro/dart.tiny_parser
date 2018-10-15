part of hetimacore;

//rfc2616 rfc7230
class HetiHttpResponse {
  static List<int> PATH = convert.utf8.encode(RfcTable.RFC3986_PCHAR_AS_STRING + "/");
  static List<int> QUERY = convert.utf8.encode(RfcTable.RFC3986_RESERVED_AS_STRING + RfcTable.RFC3986_UNRESERVED_AS_STRING);


  //
  // head := line headfield
  //
  static Future<HttpClientHead> decodeHttpHead(TinyParser parser) async {
    HttpClientHead result = new HttpClientHead();
    result.line = await decodeStatusline(parser);
    result.headerField =  await decodeHeaderFields(parser);
    result.index = parser.index;
    return result;
  }

  //
  // headerfields := *(headerfiled crlf)
  //
  static Future<List<HttpResponseHeaderField>> decodeHeaderFields(TinyParser parser) async {
    List<HttpResponseHeaderField> result = new List();
    while (true) {
      try {
        HttpResponseHeaderField v = await decodeHeaderField(parser);
        result.add(v);
      } catch (e) {
        break;
      }
    }
    await decodeCrlf(parser);
    return result;
  }

  //
  // headfield := name ":" (OWS) value crlf
  //
  static Future<HttpResponseHeaderField> decodeHeaderField(TinyParser parser) async {
    HttpResponseHeaderField result = new HttpResponseHeaderField();
    result.fieldName = await decodeFieldName(parser);
    await parser.nextString(":");
    await decodeOWS(parser);
    result.fieldValue = await decodeFieldValue(parser);
    await decodeCrlf(parser);
    return result;
  }

  static Future<String> decodeFieldName(TinyParser parser) async {
    List<int> v = await parser.matchBytesFromBytes(RfcTable.TCHAR,expectedMatcherResult: true);
    return convert.utf8.decode(v);
  }

  static Future<String> decodeFieldValue(TinyParser parser) async {
    List<int> v = await parser.matchBytesFromMatche((int target) {
      if (target == 0x0D || target == 0x0A) {
        return false;
      } else {
        return true;
      }
    },expectedMatcherResult: true);
    return convert.utf8.decode(v);
  }

  //
  // Http-version
  static Future<String> decodeHttpVersion(TinyParser parser) async {
    int major = 0;
    int minor = 0;
    await parser.nextString("HTTP" + "/");
    int v1 = await parser.nextByteFromBytes(RfcTable.DIGIT);
    major = v1 - 48;
    await parser.nextString(".");
    int v2 = await parser.nextByteFromBytes(RfcTable.DIGIT);
    minor = v2 - 48;
    return ("HTTP/${major}.${minor}");
  }

  //
  // Status Code
  // DIGIT DIGIT DIGIT
  static Future<String> decodeStatusCode(TinyParser parser) async {
    List<int> v = await parser.matchBytesFromBytes(RfcTable.DIGIT);
    int ret = 100 * (v[0] - 48) + 10 * (v[1] - 48) + (v[2] - 48);
    return "${ret}";
  }

  static Future<String> decodeReasonPhrase(TinyParser parser) async {
    // List<int> vv = await parser.nextBytePatternByUnmatch(new TextMatcher());
    // reason-phrase  = *( HTAB / SP / VCHAR / obs-text )
    List<int> vv = await parser.matchBytesFromMatche((int target) {
      //  VCHAR = 0x21-0x7E
      //  obs-text = %x80-FF
      //  SP = 0x30
      //  HTAB = 0x09
      if (0x21 <= target && target <= 0x7E) {
        return true;
      }
      if (0x80 <= target && target <= 0xFF) {
        return true;
      }
      if (target == 0x20 || target == 0x09) {
        return true;
      }
      return false;
    },expectedMatcherResult: true);
    return convert.utf8.decode(vv);
  }

  //Status-Line = HTTP-Version SP Status-Code SP Reason-Phrase CRLF
  static Future<HetiHttpResponseStatusLine> decodeStatusline(TinyParser parser) async {
    HetiHttpResponseStatusLine result = new HetiHttpResponseStatusLine();
    result.version = await decodeHttpVersion(parser);
    await decodeSP(parser);
    result.statusCode = int.parse(await decodeStatusCode(parser));
    await decodeSP(parser);
    result.statusPhrase = await decodeReasonPhrase(parser);
    await decodeCrlf(parser);
    return result;
  }

  static FutureOr<List<int>> decodeOWS(TinyParser parser) {
    return parser.matchBytesFromBytes(RfcTable.OWS,expectedMatcherResult: true);
  }

  static FutureOr<List<int>> decodeSP(TinyParser parser) {
    return parser.matchBytesFromBytes(RfcTable.OWS,expectedMatcherResult: true);
  }

  //
  static Future<String> decodeCrlf(TinyParser parser) async {
    bool crlf = true;
    parser.push();
    try {
      await parser.nextString("\r\n");
    } catch (e) {
      parser.back();
      parser.pop();
      parser.push();
      crlf = false;
      await parser.nextString("\n");
    } finally {
      parser.pop();
    }
    if (crlf == true) {
      return "\r\n";
    } else {
      return "\n";
    }
  }

  //
  static Future<int> decodeChunkedSize(TinyParser parser) async {
    List<int> n = await parser.matchBytesFromBytes(RfcTable.HEXDIG,expectedMatcherResult: true);
    if (n.length == 0) {
      throw new EasyParseError();
    }
    String nn = convert.utf8.decode(n);
    int v = int.parse(nn, radix: 16);
    await HetiHttpResponse.decodeChunkExtension(parser);
    await HetiHttpResponse.decodeCrlf(parser);
    return v;
  }

  static decodeChunkExtension(TinyParser parser) async {
    if (0 != await parser.checkString(";")) {
      while (0 == await parser.checkString("\r\n")) {
        parser.moveOffset(1);
      }
    }
  }

  //  request-line   = method SP request-target SP HTTP-version CRLF
  static Future<HetiRequestLine> decodeRequestLine(TinyParser parser) async {
    HetiRequestLine result = new HetiRequestLine();
    result.method = await decodeMethod(parser);
    await decodeSP(parser);
    result.requestTarget = await decodeRequestTarget(parser);
    await decodeSP(parser);
    result.httpVersion = await decodeHttpVersion(parser);
    await decodeCrlf(parser);
    return result;
  }

  static Future<HetiHttpRequestHead> decodeRequestMessage(TinyParser parser) async {
    HetiHttpRequestHead result = new HetiHttpRequestHead();
    result.line = await decodeRequestLine(parser);
    result.headerField = await decodeHeaderFields(parser);
    result.index = parser.index;
    return result;
  }

  // metod = token = 1*tchar
  static Future<String> decodeMethod(TinyParser parser) async {
    List<int> v = await parser.matchBytesFromBytes(RfcTable.TCHAR,expectedMatcherResult: true);
    return convert.utf8.decode(v);
  }

  // CHAR_STRING
  static Future<String> decodeRequestTarget(TinyParser parser) async {
    List<int> v = await parser.matchBytesFromBytes(RfcTable.VCHAR,expectedMatcherResult: true);
    return convert.utf8.decode(v);
  }

  // request-target = origin-form / absolute-form / authority-form / asterisk-form
  // absolute-URI  = scheme ":" hier-part [ "?" query ]

  //rfc2616
  static Future<HetiHttpRequestRange> decodeRequestRangeValue(TinyParser parser) async {
    HetiHttpRequestRange ret = new HetiHttpRequestRange();
    await parser.nextString("bytes=");
    List<int> startAsList =  await parser.matchBytesFromBytes(RfcTable.DIGIT,expectedMatcherResult: true);

    ret.start = 0;
    for (int d in startAsList) {
      ret.start = (d - 48) + ret.start * 10;
    }
    await parser.nextString("-");
    List<int> endAsList = await parser.matchBytesFromBytes(RfcTable.DIGIT,expectedMatcherResult: true);
    if (endAsList.length == 0) {
      ret.end = -1;
    } else {
      ret.end = 0;
      for (int d in endAsList) {
        ret.end = (d - 48) + ret.end * 10;
      }
    }
    return ret;
  }
}

// Range: bytes=0-499
class HetiHttpRequestRange {
  int start = 0;
  int end = 0;
}

// reason-phrase  = *( HTAB / SP / VCHAR / obs-text )
class HetiHttpResponseStatusLine {
  String version = "";
  int statusCode = -1;
  String statusPhrase = "";
}

class HttpResponseHeaderField {
  String fieldName = "";
  String fieldValue = "";
}

class HetiRequestLine {
  String method = "";
  String requestTarget = "";
  String httpVersion = "";
}

class HetiHttpRequestHead {
  int index = 0;
  HetiRequestLine line = new HetiRequestLine();
  List<HttpResponseHeaderField> headerField = new List();

  HttpResponseHeaderField find(String fieldName) {
    for (HttpResponseHeaderField field in headerField) {
      if (field != null && field.fieldName.toLowerCase() == fieldName.toLowerCase()) {
        return field;
      }
    }
    return null;
  }
}

// HTTP-message   = start-line
// *( header-field CRLF )
// CRLF
// [ message-body ]
class HttpClientHead {
  int index = 0;
  HetiHttpResponseStatusLine line = new HetiHttpResponseStatusLine();
  List<HttpResponseHeaderField> headerField = new List();

  HttpResponseHeaderField find(String fieldName) {
    for (HttpResponseHeaderField field in headerField) {
      if (field != null && field.fieldName.toLowerCase() == fieldName.toLowerCase()) {
        return field;
      }
    }
    return null;
  }

  int get contentLength {
    HttpResponseHeaderField field = find(RfcTable.HEADER_FIELD_CONTENT_LENGTH);
    if (field == null) {
      return -1;
    }
    try {
      return int.parse(field.fieldValue.replaceAll(" |\r|\n|\t", ""));
    } catch (e) {
      return -1;
    }
  }
}




//
//
//



class RfcTable {
  static const String HEADER_FIELD_CONTENT_LENGTH = "Content-Length";
  static const String HEADER_FIELD_CONTENT_TYPE = "Content-Type";
  static const String HEADER_FIELD_RANGE = "Range";
  //0x21-0x7E
  static String VCHAR_STRING =
      """!#\$%&'()*+,-./"""
          +"""0123456789:;<=>?"""
          +"""@ABCDEFGHIJKLMNO"""
          +"""PQRSTUVWXYZ[\\]^_"""
          +"""`abcdefghijklmno###"""
          +"""pqrstuvwxyz{|}~""";

  static String TCHAR_STRING =
      """!#\$%&'*+-.^_`|~"""
          + ALPHA_AS_STRING
          + DIGIT_AS_STRING;

  static String OWS_STRING = SP_STRING +"\t";
  static String SP_STRING = " ";
  static String ALPHA_AS_STRING =
      "abcdefghijklmnopqrstuvwxyz"
          +"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  static String DIGIT_AS_STRING =
      "0123456789";
  static String HEXDIG_AS_STRING =
      DIGIT_AS_STRING+"ABCDEFabcdef";
  static String RFC3986_UNRESERVED_AS_STRING =
      ALPHA_AS_STRING+DIGIT_AS_STRING+"-._~";
  static String RFC3986_RESERVED_AS_STRING =
      GEM_DELIMS_AS_STRING+SUB_DELIMS_AS_STRING+"%";

  static String GEM_DELIMS_AS_STRING = """:/?#[]@""";
  static String SUB_DELIMS_AS_STRING = """!\$&'()*+,;=""";
  static String PCT_ENCODED_AS_STRING = "%"+HEXDIG_AS_STRING;
  static String RFC3986_SUB_DELIMS_AS_STRING = "!\$&'()*+,;=";
  static String RFC3986_PCHAR_AS_STRING = RFC3986_UNRESERVED_AS_STRING+":@"+RFC3986_SUB_DELIMS_AS_STRING+"%";
  static List<int> ALPHA = convert.utf8.encode(ALPHA_AS_STRING);
  static List<int> DIGIT = convert.utf8.encode(DIGIT_AS_STRING);
  static List<int> RFC3986_UNRESERVED = convert.utf8.encode(RFC3986_UNRESERVED_AS_STRING);
  static List<int> RFC3986_RESERVED = convert.utf8.encode(RFC3986_RESERVED_AS_STRING);
  static List<int> GEM_DELIMS = convert.utf8.encode(GEM_DELIMS_AS_STRING);
  static List<int> SUB_DELIMS = convert.utf8.encode(SUB_DELIMS_AS_STRING);
  static List<int> HEXDIG = convert.utf8.encode(HEXDIG_AS_STRING);
  static List<int> PCT_ENCODED = convert.utf8.encode(PCT_ENCODED_AS_STRING);
  static List<int> VCHAR = convert.utf8.encode(VCHAR_STRING);
  static List<int> TCHAR = convert.utf8.encode(TCHAR_STRING);
  static List<int> OWS = convert.utf8.encode(OWS_STRING);
  static List<int> SP = convert.utf8.encode(SP_STRING);

  //  obs-text = %x80-FF
  static List<int> OBS_TEXT = [
    0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87, 0x88, 0x89,
    0x8A, 0x8B, 0x8C, 0x8E, 0x8F,
    0x90, 0x91, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97, 0x98, 0x99,
    0x9A, 0x9B, 0x9C, 0x9E, 0x9F,
    0xA0, 0xA1, 0xA2, 0xA3, 0xA4, 0xA5, 0xA6, 0xA7, 0xA8, 0xA9,
    0xAA, 0xAB, 0xAC, 0xAE, 0xAF,
    0xB0, 0xB1, 0xB2, 0xB3, 0xB4, 0xB5, 0xB6, 0xB7, 0xB8, 0xB9,
    0xBA, 0xBB, 0xBC, 0xBE, 0xBF,
    0xC0, 0xC1, 0xC2, 0xC3, 0xC4, 0xC5, 0xC6, 0xC7, 0xC8, 0xC9,
    0xCA, 0xCB, 0xCC, 0xCE, 0xCF,
    0xD0, 0xD1, 0xD2, 0xD3, 0xD4, 0xD5, 0xD6, 0xD7, 0xD8, 0xD9,
    0xDA, 0xDB, 0xDC, 0xDE, 0xDF,
    0xE0, 0xE1, 0xE2, 0xE3, 0xE4, 0xE5, 0xE6, 0xE7, 0xE8, 0xE9,
    0xEA, 0xEB, 0xEC, 0xEE, 0xEF,
    0xF0, 0xF1, 0xF2, 0xF3, 0xF4, 0xF5, 0xF6, 0xF7, 0xF8, 0xF9,
    0xFA, 0xFB, 0xFC, 0xFE, 0xFF,
  ];
}

class ParseError extends Error {
  ParseError([String mes=""])  {
  }
}