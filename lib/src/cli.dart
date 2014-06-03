part of dartcoveralls;

cli(List<String> args){
  var parser = getArgs();
  var result = parser.parse(args);
  
  var coveralls = new Coveralls(result["root"]);
  
  (result["files"] as Iterable).forEach((filename){
    var file = new File(path.join(coveralls.root, filename));
    coveralls.addCoverage(JSON.decode(file.readAsStringSync()));
  });
  
  coveralls.getPayload('8IdbTHRDDFjBloLp7LogxpoiEvbrMS76J')
  .then(coveralls.upload)
  .then((Response response) {
    print(response.statusCode);
    print(response.reasonPhrase);
    print(response.body);
  });
}

ArgParser getArgs(){
  var args = new ArgParser();
  args.addOption("files", abbr: "f", allowMultiple:true);
  args.addOption("root", abbr: "r",  defaultsTo:".");
  args.addOption("repo_token", abbr: "t");
  args.addOption("service_name", abbr: "n");
  args.addOption("service_job_id", abbr: "i");
  return args;
}