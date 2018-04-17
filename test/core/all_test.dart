import './arraybuilder_test.dart' as t_arraybuilder;
import './arraybuilder_test2.dart' as t_arraybuilder2;


import './arraybuilder_z99_test.dart' as t_arrraybuilder_z99;
import './easyparser_test.dart' as t_easyparser;
import './percentencode_test.dart' as t_persent;

import './bencode_test.dart' as bencode_test;
import './bencode_test2.dart' as bencode_test2;
import './pieceinfo_test.dart' as pieceinfo_test;

import './hetihttpresponse_test_b.dart' as httpresponse_test_b;
import './hetihttpresponse_test_c.dart' as httpresponse_test_c;
import './hetihttpresponse_test_d.dart' as httpresponse_test_d;
import './httpurldecoder_test.dart' as httpurldecoder_test;
import './test_hetiip.dart' as test_hetiip;


void main() {
  t_arraybuilder.main();
  t_arraybuilder2.main();
  t_arrraybuilder_z99.main();

  t_easyparser.main();

  t_persent.main();

  //
  bencode_test.main();
  bencode_test2.main();

  //
  pieceinfo_test.main();

  //
  httpresponse_test_b.main();
  httpresponse_test_c.main();
  httpresponse_test_d.main();
  httpurldecoder_test.main();
  test_hetiip.main();


}
