#!/bin/bash

read -e -p "which file you want to insert to : " filename
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
ispk=`awk -F: 'BEGIN {col}{ if ( $3 == "primarykey") col=$1} END {print col }' .$filename"meta"`
numberOfCols=`awk -F: 'END {print NR}' .$filename"meta"`
echo $numberOfCols
echo
echo the column that is primary  key is : $ispk
echo
# Now access elements of an array (change "1" to whatever you want)
#echo ${myarr[1]}

# Or loop through every element in the array
for i in "${colnames[@]}"
do
  echo $i
done

echo
echo
for i in "${coltypes[@]}"
do
  echo $i
done

record=()

typeset -i i
i=0
while [ $((numberOfCols)) -ne 0 ]
do
    read -e -p "Enter the valuse of column ${colnames[i]} > " value
    
    if [ ${coltypes[i]} = "int" ]
    then
       while [ -z "$value" ] || ! [[ $value =~ ^[0-9]+$ ]]
       do
           if [ -z "$value" ]
           then
               echo           
               echo  -e "\e[41mYou must enter a value \e[0m"
               echo           
               read -e -p "Enter value of integer : "  value
               echo   
           fi
           if ! [[ $value =~ ^[0-9]+$ ]]
           then
               echo           
               echo -e "\e[41mThis is not an integer  \e[0m"
               echo           
               read -e -p "Enter value of integer : "  value
               echo           
           fi
       done
    fi
    
    if [ ${coltypes[i]} = "string" ]
    then
       while [ -z "$value"  ] || [[ $value =~ ^[0-9]+$ ]]
       do
           if [ -z "$value" ]
           then
               echo           
               echo  -e "\e[41mYou must enter a value \e[0m"
               echo           
               read -e -p "Enter value of string : "  value
               echo   
           fi
           if [[ $value =~ ^[0-9]+$ ]]
           then
               echo           
               echo -e "\e[41mThis is not a string  \e[0m"
               echo           
               read -e -p "Enter value of string : "  value
               echo           
           fi
       done
    fi


    if [ ${colnames[i]} = $ispk ]
    then
       
       while grep -q -w "$value" $filename || [ -z "$value" ]
       do
         if [ -z "$value" ]
         then
               echo           
               echo -e "\e[41mYou must enter a value \e[0m"
               echo           
               read -e -p "Enter value of string : "  value
               echo  
         fi


         if grep -q -w "$value" $filename
         then
            echo
            echo -e "\e[41mYou must enter a unique value as this is primary key! \e[0m"
            echo
            read -e -p "Enter value of ${coltypes[i]} : " value
            echo
         fi

         if [ ${coltypes[i]} = "int" ]
         then
            while [ -z "$value" ] || ! [[ $value =~ ^[0-9]+$ ]]
            do
                if [ -z "$value" ]
                then
                    echo           
                    echo  -e "\e[41mYou must enter a value \e[0m"
                    echo           
                    read -e -p "Enter value of integer : "  value
                    echo   
                fi
                if ! [[ $value =~ ^[0-9]+$ ]]
                then
                    echo           
                    echo -e "\e[41mThis is not an integer  \e[0m"
                    echo           
                    read -e -p "Enter value of integer : "  value
                    echo           
                fi
            done
         fi
    
         if [ ${coltypes[i]} = "string" ]
            then
               while [ -z "$value"  ] || [[ $value =~ ^[0-9]+$ ]]
               do
                   if [ -z "$value" ]
                   then
                       echo           
                       echo  -e "\e[41mYou must enter a value \e[0m"
                       echo           
                       read -e -p "Enter value of string : "  value
                       echo   
                   fi
                   if [[ $value =~ ^[0-9]+$ ]]
                   then
                       echo           
                       echo -e "\e[41mThis is not a string  \e[0m"
                       echo           
                       read -e -p "Enter value of string : "  value
                       echo           
                   fi
               done
            fi
          
 
       done





    fi


    record+=("$value")
    i=$i+1
    numberOfCols=$((numberOfCols))-1
done

delim=""
joined=""
for item in "${record[@]}"; do
  joined="$joined$delim$item"
  delim=":"
done
echo "$joined" >> $filename