library dartcoveralls;

class Coveralls{
  Map _coverage = {};
  
  addCoverage(Map data){
    var coverage = data['coverage'];
    coverage.forEach((Map file){
      print(file['source']);
    });
  }
}