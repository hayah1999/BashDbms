#!/bin/bash
echo
read -e -p "Which table you want to select from : " filename
echo
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
echo
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
select choice in "Delete all columns" "Delete data by column"  "exit"
do
case $REPLY in
1) > $filename
			echo
      echo -e "\e[42mAll your records are deleted successfully\e[0m"
      echo
;;
2)
echo
read -p "Enter column number of the condition : " coldel
echo
while [ -z "$coldel" ] || ! [[ $coldel =~ ^[0-9]+$ ]] || [ $coldel -gt $numberOfCols -o $coldel -le 0 ]
do
  if [ -z "$coldel" ]
  then
      echo
      echo  -e "\e[41mYou must enter a number\e[0m"
      echo
      read -e -p "Enter column number of the condition : " coldel
      echo
  elif [ ^$coldel = -* ]
  then
      echo
      echo -e "\e[41minvalid entery\e[0m"
      echo
      read -e -p "Enter column number of the condition : " coldel 
      echo
  else
      echo
      echo -e "\e[41minvalid entery\e[0m"
      echo
      read -e -p "Enter column number of the condition : " coldel
      echo
  fi
done


echo
read -p "Enter condition value: " vldel; 
echo 
dec2=$coldel-1


while [ "${coltypes[$'$dec2']}" = int ] && [[ $vldel =~ ^[a-zA-Z] ]] ; 
do
echo
echo -e "\e[41mYour entry expected to be integer\e[0m"
echo
read -e -p "Enter condition value : " vldel
echo
done

while [ "${coltypes[$'$dec2']}" = string ] && [[ $vldel =~ ^[1-9] ]]; 
do
echo
echo -e "\e[41mYour entry expected to be string\e[0m"
echo
read -e -p "Enter condition value : " vldel
echo
done 
while [ -z "$vldel" ]
do 
echo
echo  -e "\e[41mYou must enter a value\e[0m"
echo
read -e -p "Enter condition value : " vldel
echo
done
while !  cut -d: -f$coldel $filename| grep -q -w "$vldel"  > /dev/null
do
echo
echo -e "\e[41mYour value is not in the file\e[0m"
echo
read -e -p "Enter condition value : " vldel
echo
done

if   cut -d: -f$coldel $filename| grep -q -w "$vldel"
then
	 awk 'BEGIN {OFS=FS=":"} {if($'$coldel'=="'$vldel'") {
				loc=NR
			}
		
		{if(NR!=loc)print 
		}
	}' $filename > tmp && mv tmp $filename;
echo
echo -e "\e[42mThe record is deleted successfully\e[0m"
echo
#awk -F: '{print}' $filename
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

fi
;;
3) exit
;;
*) echo
       echo  -e "\e[41mInvalid choice \e[0m"
       echo
    ;;
esac
done
