import 'dart:convert';
import 'dart:io';

import 'package:dartcoveralls/dartcoveralls.dart';
import 'package:http/http.dart';

main(){
  var coveralls = new Coveralls();
  coveralls.root = '..';
  var file = new File('../cov.json');
  coveralls.addCoverage(JSON.decode(file.readAsStringSync()));
  coveralls.getPayload('2V6WR3QvcnklMj9bxd6AHYFkZgpmPGynD')
  .then(coveralls.upload)
  .then((Response response) {
    print(response.statusCode);
    print(response.reasonPhrase);
    print(response.body);
  });
}