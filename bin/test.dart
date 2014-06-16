import 'dart:async';
import 'dart:io';
import 'package:git/git.dart';
import 'package:path/path.dart' as Path;

main(){
  var data = {
    "head": {},
    "remotes": []
  };
  
  getGit(Directory.current.path)
  .then((GitDir git){
    print(git.path);
    git.getCurrentBranch().then((BranchReference b){
      data["branch"] = b.branchName;
      data["head"]["id"] = b.sha;
      
      return git.getCommit(b.sha);
    }).then((Commit c){
      data["head"]["author_name"] = c.author;
      data["head"]["author_email"] = c.author;
      data["head"]["committer_name"] = c.committer;
      data["head"]["committer_email"] = c.committer;
      data["head"]["message"] = c.message;
    }).then((_) => print(data));
  });
}

Future<GitDir> getGit(String path){
  print('getGit($path)');
  
  Future<GitDir> subget(String path) => GitDir.fromExisting(path).catchError((e){
    print('subget($path)');
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