import 'dart:async';
import 'dart:io';
import 'package:git/git.dart';
import 'package:path/path.dart' as Path;

main(){
  getGit(Directory.current.path)
  .then((GitDir git){
    print(git.path);
  });
}

Future<GitDir> getGit(String path){
  var list = Path.split(path);
  if(list.length == 1){
    return new Future.error('Git directory not found');
  }
  
  return GitDir.isGitDir(path).then((found){
    print("$path: $found");
    if(found){
      return GitDir.fromExisting(path);
    }else{
      list.removeLast();
      return getGit(Path.joinAll(list));
    }
  });
}