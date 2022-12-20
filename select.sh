#!/bin/bash
read -e -p "which file you want to select from : " filename
while [ -z "$filename" ] ||  [ ! -f $filename ]
do
    if [ -z "$filename" ]
    then
          echo           
          echo  -e "\e[41mYou must enter a name \e[0m"
          echo           
          read -e -p "Enter the name of the table > " filename
          echo  
      fi
      if [ ! -f $filename ]
      then
          echo           
          echo  -e "\e[41mThis table name doesn't exist. Try again! \e[0m"
          echo           
          read -e -p "Enter the name of the table > " filename
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



echo 

select choice in "Select all columns" "select specific columns" "select columns where condition" "exit"
do
case $REPLY in
1)  awk -F: '{print}' $filename
;;
2) 
read -p "Enter Number of columns: " number;
    while [ -z "$number" ]
   do
          echo           
          echo  -e "\e[41mYou must enter a number\e[0m"
          echo           
          read -e -p "Enter Number of columns: " number
          done  
       for (( i = 1; i <= number; i++ )); 
          do
            echo "Enter column number: "
             read colNum
while [ -z "$colNum" ]
 do  
          echo  -e "\e[41mYou must enter a number\e[0m"
          read -e -p "Enter column number: " colNum
       done  
           if  [[ $colNum =~ ^[a-zA-Z] ]]; then
echo -e "\e[41mYour entry expected to be integer\e[0m"

            elif  [[ ^$colNum  =~ [:!\|@\{#$%\&*\`~+=?.\>\<,\;:\ ] ]]; then
echo -e "\e[41mYour entry expected to be integer \e[0m"


            elif [ $colNum -le $numberOfCols -a $colNum -gt 0 ] 
            then
dec=$colNum-1
echo "${colnames[$'$dec']}"
col=(`awk -F: '{ print $'$colNum' }' $filename`)

for l in "${col[@]}"
do 
echo  $l
done


else 
echo -e "\e[41m Invalid entery! \e[0m"
fi
done

;;


3)
			
read -p "Enter column number of the condition: " colnu;
while [ -z "$colnu" ]
       do
          echo  -e "\e[41mYou must enter a number\e[0m"
read -e -p "Enter column number of the condition:  > " colnu
done
while [[ $colnu =~ ^[a-zA-Z] ]] || [[ ^$colnu  =~ [:!\|@\{#$%\&*\`~+=?.\>\<,\;:\ ] ]] || [ $colnu -gt $numberOfCols -o $colnu -le 0 ]; 
do
echo -e "\e[41minvalid entery\e[0m"
read -e -p "Enter column number of the condition:  > " colnu

done



read -p "Enter condition value: " val;  
dec2=$colnu-1


while [ "${coltypes[$'$dec2']}" = int ] && [[ $val =~ ^[a-zA-Z] ]] ; 
do
echo -e "\e[41mYour entry expected to be integer\e[0m"
read -e -p "Enter condition value: > " val
done

while [ "${coltypes[$'$dec2']}" = string ] && [[ $val =~ ^[1-9] ]]; 
do
echo -e "\e[41mYour entry expected to be string\e[0m"
read -e -p "Enter condition value: > " val
done 
while [ -z "$val" ]
        do  
          echo  -e "\e[41mYou must enter a value\e[0m"
read -e -p "Enter condition value: > " val
  done
if ! grep -q -w "$val" $filename
then
echo -e "\e[41mYour value is not in the file\e[0m"
read -e -p "Enter condition value: > " val

  else  awk 'BEGIN {OFS=FS=":"} {if($'$colnu'=="'$val'") {loc=NR}
			
				{if(NR==loc) print
				}}' $filename
fi

          
;;

4)
exit
;;

esac
done


