library dartcoveralls;

import 'package:path/path.dart' as path;

class Coveralls{
  String root = '.';
  
  Map _coverage = {};
  
  addCoverage(Map data){
    var coverage = data['coverage'];
    coverage.forEach((Map file){
      String source = file['source'];
      if(!source.startsWith('file://')){
        return;
      }
      source = path.fromUri(source);
      if(path.isWithin(root,source)){
        print(path.relative(source,from: root));
      }
    });
  }
}