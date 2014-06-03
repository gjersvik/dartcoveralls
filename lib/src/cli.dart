part of dartcoveralls;

cli(List<String> args){
  var coveralls = new Coveralls();
  coveralls.root = '..';
  var file = new File('../cov.json');
  coveralls.addCoverage(JSON.decode(file.readAsStringSync()));
  coveralls.getPayload('8IdbTHRDDFjBloLp7LogxpoiEvbrMS76J')
  .then(coveralls.upload)
  .then((Response response) {
    print(response.statusCode);
    print(response.reasonPhrase);
    print(response.body);
  });
}