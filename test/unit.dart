library dartcoveralls_unit;

import 'package:unittest/unittest.dart';
import 'package:unittest/vm_config.dart';

import 'package:dartcoveralls/dartcoveralls.dart';

part 'src/coveralls.dart';

main(){
  //useVMConfiguration();
  
  testCoveralls();
}