import 'dart:async';
import "dart:convert";
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
      var reg = new RegExp(r"^([^<]+) <([^>]+)>");
      var author = reg.firstMatch(c.author);
      data["head"]["author_name"] = author.group(1);
      data["head"]["author_email"] = author.group(2);
      
      var committer = reg.firstMatch(c.committer);
      data["head"]["committer_name"] = committer.group(1);
      data["head"]["committer_email"] = committer.group(2);
      data["head"]["message"] = c.message;
      
      return git.runCommand(["remote", "-v"]);
    }).then((ProcessResult pro){
      var reg = new RegExp(r"(\S+)\s(\S+)\s\(fetch\)");
      reg.allMatches(pro.stdout).forEach((m){
        data["remotes"].add({
          "name": m.group(1),
          "url": m.group(2)
        });
      });
    }).then((_){
      var json =  new  JsonEncoder.withIndent("  ");
      print(json.convert(data));
    });
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