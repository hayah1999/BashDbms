#!/bin/bash
read -e -p "Which table you want to select from : " filename
while [ -z "$filename" ] ||  [ ! -f $filename ]
do
    if [ -z "$filename" ]
    then
          echo           
          echo  -e "\e[41mYou must enter a name \e[0m"
          echo           
          read -e -p "Enter the name of the table : " filename
          echo  
      fi
      if [ ! -f $filename ]
      then
          echo           
          echo  -e "\e[41mThis table name doesn't exist. Try again! \e[0m"
          echo           
          read -e -p "Enter the name of the table : " filename
          echo 
      fi
done

colnames=(`awk -F: '{ print $1 }' .$filename"meta"`)
coltypes=(`awk -F: '{ print $2 }' .$filename"meta"`)
numberOfCols=`awk -F: 'END {print NR}' .$filename"meta"`
echo "Number of columns:" $numberOfCols
echo 
typeset -i counter
counter=1
for l in "${colnames[@]}"
do 
echo "$counter)"   $l
counter=$counter+1
done

entry=`echo -e "\e[36m$filename\e[0m"`
PS3=''$entry' table >> Enter your choice : '

echo 

select choice in "Select all columns" "select specific columns" "select columns where condition" "exit"
do
case $REPLY in
1)  #awk -F: '{print}' $filename
 #cut -d: -f1 .$filename"meta" | awk '{if(NR == '$numberOfCols') {for (k=1; k <= NF; k++) printf "%-5s", $k; print " "}}'
# awk 'BEGIN {FS=OFS=":"} {for (k=1; k <= NF; k++) printf "%-5s", $k; print " "}' $filename
#cut -d: -f1 .$filename"meta" | awk '{for (k=1; k <= NR; k++) printf "%-5s", $k; print " "}'
delim=""
joined=""
for item in "${colnames[@]}"; do
  joined="$joined$delim$item"
  delim="\t|\t"
done

echo
echo
echo "-------------------------------------------------------------------"
echo -e "$joined"
echo "-------------------------------------------------------------------"
list=`cat $filename  | column --table --separator ":" --output-separator "\t|\t"`
echo -e "$list"
echo
echo
;;
2) 
echo
read -p "Enter Number of columns: " number;
echo
    while [ -z "$number" ] || ! [[ $number =~ ^[0-9]+$ ]] 
do
  if [ -z "$number " ]
  then
      echo  -e "\e[41mYou must enter a number\e[0m"
      read -e -p "Enter column number of the condition : " number 
  elif [ ^$number = -* ]
  then
      echo
      echo -e "\e[41minvalid entery\e[0m"
      echo
      read -e -p "Enter column number of the condition : " number 
      echo
  else
      echo
      echo -e "\e[41minvalid entery\e[0m"
      echo
      read -e -p "Enter column number of the condition : " number 
      echo
  fi
done
       for (( i = 1; i <= number; i++ )); 
          do
             echo
             echo "Enter column number : "
             read colNum
             echo
while [ -z "$colNum" ] || ! [[ $colNum =~ ^[0-9]+$ ]] || [ $colNum -gt $numberOfCols -o $colNum -le 0 ]
do
  if [ -z "$colNum" ]
  then
      echo
      echo  -e "\e[41mYou must enter a number\e[0m"
      echo
      read -e -p "Enter column number of the condition : " colNum
      echo
  elif [ ^$colNum = -* ]
  then
      echo
      echo -e "\e[41minvalid entery\e[0m"
      echo
      read -e -p "Enter column number of the condition : " colNum
      echo
  else
      echo
      echo -e "\e[41minvalid entery\e[0m"
      echo
      read -e -p "Enter column number of the condition : " colNum
      echo
  fi
done


            if [ $colNum -le $numberOfCols -a $colNum -gt 0 ] 
            then
dec=$colNum-1
delim=""
joined=""
tt=""
var="${colnames[$'$dec']}"
 joined="$joined$var\t|\t"
 
col=(`awk -F: '{ print $'$colNum' }' $filename`)
echo
echo "---------"
echo -e "$joined"
echo "---------"
for l in "${col[@]}"
do 
echo -e "$l\t|\t"
done
echo 

else 
echo
echo -e "\e[41m Invalid entery! \e[0m"
echo
fi
done
;;
3)
echo			
read -p "Enter column number of the condition : " colnu
echo

while [ -z "$colnu" ] || ! [[ $colnu =~ ^[0-9]+$ ]] || [ $colnu -gt $numberOfCols -o $colnu -le 0 ]
do
  if [ -z "$colnu" ]
  then
      echo
      echo  -e "\e[41mYou must enter a number\e[0m"
      echo
      read -e -p "Enter column number of the condition : " colnu
      echo
  elif [ ^$colnu = -* ]
  then
      echo
      echo -e "\e[41minvalid entery\e[0m"
      echo
      read -e -p "Enter column number of the condition : " colnu  
      echo
  else
      echo
      echo -e "\e[41minvalid entery\e[0m"
      echo
      read -e -p "Enter column number of the condition : " colnu
      echo
  fi
done

echo
read -p "Enter condition value: " val;  
echo
dec2=$colnu-1


while [ "${coltypes[$'$dec2']}" = int ] && [[ $val =~ ^[a-zA-Z] ]] ; 
do
  echo
  echo -e "\e[41mYour entry expected to be integer\e[0m"
  echo
  read -e -p "Enter condition value : " val
  echo
done

while [ "${coltypes[$'$dec2']}" = string ] && [[ $val =~ ^[1-9] ]]; 
do
  echo
  echo -e "\e[41mYour entry expected to be string\e[0m"
  echo
  read -e -p "Enter condition value : " val
  echo
done 
while [ -z "$val" ]
        do  
          echo
          echo  -e "\e[41mYou must enter a value\e[0m"
          echo
          read -e -p "Enter condition value : " val
          echo
  done
while !  cut -d: -f$colnu $filename| grep -q -w "$val"  > /dev/null
do
  echo
  echo -e "\e[41mYour value is not in the file\e[0m"
  echo
  read -e -p "Enter condition value : " val
  echo
done
delim=""
joined=""
for item in "${colnames[@]}"; do
  joined="$joined$delim$item"
  delim="\t|\t"
done

echo
echo "-------------------------------------------------------------------"
echo -e "$joined"
echo "-------------------------------------------------------------------"
if   cut -d: -f$colnu $filename| grep -q -w "$val"  
then 
list=`awk 'BEGIN {OFS=FS=":"} {if($'$colnu'=="'$val'") {loc=NR}{if(NR==loc) print}}' $filename  | column --table --separator ":" --output-separator "\t|\t"`
echo -e "$list"
fi
echo
echo
          
;;

4)
exit
;;
*) echo
       echo  -e "\e[41mInvalid choice \e[0m"
       echo
    ;;

esac
done


