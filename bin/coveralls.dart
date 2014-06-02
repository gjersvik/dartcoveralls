import 'dart:convert';
import 'dart:io';

import 'package:dartcoveralls/dartcoveralls.dart';

main(){
  var coveralls = new Coveralls();
  var file = new File('../cov.json');
  coveralls.addCoverage(JSON.decode(file.readAsStringSync()));
}