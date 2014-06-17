part of dartcoveralls;

class Git{
  static Future<Git> fromPath([String path]){
    if(path == null){
      path = Directory.current.path;
    }
    
    Future<GitDir> subget(String path) => GitDir.fromExisting(path)
    .then((git) => new Git._private(git))
    .catchError((e){
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
  
  GitDir _git;
  
  Future<Map> getData() => _git.getCurrentBranch().then((b){
    return Future.wait([_head(b.sha), _remotes()])
    .then((List list) => {
      "branch": b.branchName,
      "head": list[0],
      "remotes": list[1]
    });
  });
  
  Future<Map> _head(String sha){
    return _git.getCommit(sha).then((Commit c){
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
  
  Future<List> _remotes(){
    return _git.runCommand(["remote", "-v"]).then((pro){
      var reg = new RegExp(r"(\S+)\s(\S+)\s\(fetch\)");
      return reg.allMatches(pro.stdout).map((m){
        return {
          "name": m.group(1),
          "url": m.group(2)
        };
      }).toList();
    });
  }
  
  Git._private(this._git);
}