part of dartcoveralls_unit;

testCoveralls() => group("Coveralls", (){
  test('.root is normalizeed',(){
    var cover = new Coveralls("");
    cover.root = 'test/../';
    expect(cover.root, isNot(contains('..')));
  });
});