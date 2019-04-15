#! /bin/bash
echo $(uname);
declare num=1000;

uname()
{
  echo "1to100"
  ((num++));
  return 100;
}

testv()
{
    local num=10;
    ((num++));
    echo $num;
}

uname;
echo $?
echo $num
testv;
echo $num;
