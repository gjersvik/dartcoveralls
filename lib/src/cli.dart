part of dartcoveralls;

cli(List<String> args){
  var parser = getArgs();
  var result = parser.parse(args);
  
  var coveralls = new Coveralls(result["root"],
    repoToken: result["repo_token"],
    serviceToken: result["service_name"],
    serviceJobId: result["service_job_id"]
  );
  
  Future.wait((result["files"] as Iterable).map(coveralls.addFile)).then((_){
    print(coveralls.coverage);
      
    coveralls.getPayload()
    .then(coveralls.upload)
    .then((Response response) {
      print("${response.statusCode} ${response.reasonPhrase}");
      print(response.body);
    });
  });
}

ArgParser getArgs(){
  var args = new ArgParser();
  args.addOption("files", abbr: "f", allowMultiple:true);
  args.addOption("root", abbr: "r",  defaultsTo:".");
  args.addOption("repo_token", abbr: "t", defaultsTo:"");
  args.addOption("service_name", abbr: "n", defaultsTo:"");
  args.addOption("service_job_id", abbr: "j", defaultsTo:"");
  return args;
}