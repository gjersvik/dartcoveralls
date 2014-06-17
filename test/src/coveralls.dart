part of dartcoveralls_unit;

testCoveralls() => group("Coveralls", (){
  test('.root is normalizeed',(){
    var cover = new Coveralls("../");
    expect(cover.root, isNot(contains('..')));
  });
});