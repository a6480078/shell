x=10
#echo $(( 10 + 5 ))
#echo $(( 10 / 5 ))
#echo $(( 10 * 5 ))
#echo $(( 10 - 5 ))
#echo $(( 10 % 5 ))
#echo $(( 10 ** 5 ))
echo $(( x++ ))
echo $(( x-- ))
declare -i y=10
echo $y

declare -i x=10
declare -i z=0
z=$(( x + y ))
echo "$x + $y = $z"

