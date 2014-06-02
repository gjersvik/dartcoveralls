library dartcoveralls;

import 'dart:math';

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
        print(_toCoverallLineFormat(file['hits']));
      }
    });
  }
  
  List<int> _toCoverallLineFormat(List cov){
    List out = [];
    for(int i = 0; i < cov.length; i += 2){
      var line = cov[i];
      var hits = cov[i+1];
      // test length
      if(out.length < line){
        out.length = line;
      }
      
      if(out[line-1] == null){
        out[line-1] = hits;
      }else{
        out[line-1] = max(out[line-1], hits);
      }
    }
    return out;
  }
}