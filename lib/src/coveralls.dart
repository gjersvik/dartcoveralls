part of dartcoveralls;

class Coveralls{
  final String repoToken;
  final String serviceToken;
  final String serviceJobId;
  
  String _root = '.';
  String _projectName = '';
  
  Coveralls(String root,{this.repoToken:'',
                         this.serviceToken:'',
                         this.serviceJobId:''}){
    _root = path.normalize(path.absolute(root));
    var pubspec = new File(path.join(root,'pubspec.yaml')).readAsStringSync();
    _projectName = loadYaml(pubspec)['name'];
  }
  
  String get root => _root;
  
  Map<String,List<int>> coverage = {};
  
  addCoverage(Map data){
    Map<String,List<int>> newCoverage = {};
    data['coverage'].forEach((Map file){
      String source = file['source'];
      if(source.startsWith('file://')){
        source = path.fromUri(source);
        if(path.isWithin(root,source)){
          newCoverage[path.relative(source,from: root)] = _toCoverallLineFormat(file["hits"]);
        }
      }
      if(source.startsWith("package:$_projectName")){
        source = "lib" + source.replaceFirst("package:$_projectName", "");
        newCoverage[path.relative(source,from: root)] = _toCoverallLineFormat(file["hits"]);
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
  
  Future<Map> getPayload(){
    var data = {"repo_token": repoToken,
                "source_files": []
    };
    
    var files = coverage.keys.map((file) => new File(path.join(root,file)));
    var content = files.map((File f) =>f.readAsLines());
    return Future.wait(content).then((list){
      var source = new Map.fromIterables(coverage.keys,list.map((c) => c.join("\n")));
      coverage.forEach((key,hits){
        data["source_files"].add({
          "name" : key,
          "source" : source[key],
          "coverage": hits
        });
      });
      
      return data;
    });
  }
  
  Future upload(Map payload){
    var uri = Uri.parse("https://coveralls.io/api/v1/jobs");
    var body = {"json": JSON.encode(payload)};
    return post(uri,body: body);
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