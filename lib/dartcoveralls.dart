library dartcoveralls;

import 'dart:math';

import 'package:path/path.dart' as path;

class Coveralls{
  String root = '.';
  
  Map<String,List<int>> coverage = {};
  
  addCoverage(Map data){
    Map<String,List<int>> newCoverage = {};
    data['coverage'].forEach((Map file){
      String source = file['source'];
      if(!source.startsWith('file://')){
        return;
      }
      source = path.fromUri(source);
      if(path.isWithin(root,source)){
        newCoverage[path.relative(source,from: root)] = _toCoverallLineFormat(file['hits']);
      }
    });
    
    newCoverage.forEach((path,hits){
      if(coverage.containsKey(path)){
        var hits2 = coverage[path];
        var length = max(hits.length,hits2.length);
        hits.length = length;
        hits2.length = length;
        
        for(int i = 0; i < length; i+=1){
          if(hits[i] == null){
            continue;
          }
          if(hits2[i] == null){
            hits2[i] = hits[i];
          }else{
            hits2[i] += hits[i];
          }
        }
      }else{
        coverage[path] = hits;
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