part of dartcoveralls;

Future<Map> getGitData(String path) => getGit(path).then((GitDir git){
  return git.getCurrentBranch().then((b) => Future.wait([
    getGitHead(b.sha,git),
    getGitRemotes(git)
  ]).then((List list) => {
    "branch": b.branchName,
    "head": list[0],
    "remotes": list[1]
  }));
});

Future<Map> getGitHead(String sha, GitDir git){
  return git.getCommit(sha).then((Commit c){
    var reg = new RegExp(r"^([^<]+) <([^>]+)>");
    var author = reg.firstMatch(c.author);
    var committer = reg.firstMatch(c.committer);
    
    return {
      "id": sha,
      "author_name": author.group(1),
      "author_email": author.group(2),
      "committer_name": committer.group(1),
      "committer_email": committer.group(2),
      "message": c.message
    };
  });
}

Future<List> getGitRemotes(GitDir git){
  return git.runCommand(["remote", "-v"]).then((pro){
    var reg = new RegExp(r"(\S+)\s(\S+)\s\(fetch\)");
    return reg.allMatches(pro.stdout).map((m){
      return {
        "name": m.group(1),
        "url": m.group(2)
      };
    }).toList();
  });
}

Future<GitDir> getGit(String path){
  Future<GitDir> subget(String path) => GitDir.fromExisting(path).catchError((e){
    var list = Path.split(path);
    list.removeLast();
    return subget(Path.joinAll(list));
  });
  
  return GitDir.isGitDir(path).then((found){
    if(!found){
      return new Future.error('Git directory not found');
    }
  }).then((_) => subget(path));
}

main(){
  getGitData(Directory.current.path).then((data){
    var json = new  JsonEncoder.withIndent("  ");
    print(json.convert(data));
  });
}