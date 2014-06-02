// Comment shuld not be counted.
dud(){
  // Comment shuld not be counted.
  print('Will not run.');
  print('Will not run.');
}

run1(){
  print('Run 1/1');
}

run5(){
  for(int i = 1; i < 6; i +=1){
    print('Run $i/5');
  }
}

run10(){
  for(int i = 1; i < 11; i +=1){
    print('Run $i/10');
  }
}

main(){
  print('Start');
  run1();
  run5();
  run10();
}

// Comment shuld not be counted.
// Comment shuld not be counted.