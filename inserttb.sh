#!/bin/bash

read -e -p "Which table you want to insert into : " filename
while [ -z "$filename" ] ||  [ ! -f $filename ]
do
    if [ -z "$filename" ]
    then
          echo           
          echo  -e "\e[41mYou must enter a name \e[0m"
          echo           
          read -e -p "Enter the name of the table > " filename
          echo  
      else
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

echo
echo -e "\e[45mThe column that is primary key is : $ispk \e[0m"
echo




record=()

typeset -i i
i=0

while [ $((numberOfCols)) -ne 0 ]
do
    read -e -p "Enter the value of column ${colnames[i]} > " value
    

            if [ ${coltypes[i]} = "int" ]
            then
               if [ ${colnames[i]} = $ispk ]
               then
                  while [ -z "$value" ] || ! [[ $value =~ ^[0-9]+$ ]] || grep -q -w $value $filename 
                  do
                  if [ -z "$value" ]
                  then
                    echo           
                    echo  -e "\e[41mYou must enter a value \e[0m"
                    echo           
                    read -e -p "Enter the value of ${colnames[i]} > " value
                    echo 
                  elif ! [[ $value =~ ^[0-9]+$ ]]
                  then
                    echo           
                    echo  -e "\e[41mYou must enter a value of ${coltypes[i]} \e[0m"
                    echo           
                    read -e -p "Enter value of int : " value
                    echo 
                  else
                    echo  
                    echo -e "\e[41mThis has to be unique value\e[0m"
                    echo  
                    read -e -p "Enter a unique value : " value
                    echo
                  fi
                  done
               else
                  while ! [[ $value =~ ^[0-9]+$ ]] || [ -z "$value" ]
                  do
                     if [ -z "$value" ]
                     then
                       echo           
                       echo  -e "\e[41mYou must enter a value\e[0m"
                       echo           
                       read -e -p "Enter the value of ${colnames[i]} > " value
                       echo
                     else
                       echo           
                       echo  -e "\e[41mYou must enter a value of ${coltypes[i]} \e[0m"
                       echo           
                       read -e -p "Enter value of int : " value
                       echo 
                     fi
                  done
               fi
            fi


            if [ ${coltypes[i]} = "string" ]
            then
               if [ ${colnames[i]} = $ispk ]
               then
                  while [ -z "$value" ] || [[ $value =~ ^[0-9]+$ ]] || grep -q -w $value $filename 
                  do
                  if [ -z "$value" ]
                  then
                    echo           
                    echo  -e "\e[41mYou must enter a value\e[0m"
                    echo           
                    read -e -p "Enter the value of ${colnames[i]} > " value
                    echo 
                  elif [[ $value =~ ^[0-9]+$ ]]
                  then
                    echo           
                    echo  -e "\e[41mYou must enter a value of ${coltypes[i]}\e[0m"
                    echo           
                    read -e -p "Enter value of string : " value
                    echo 
                  else
                    echo  
                    echo -e "\e[41mThis has to be unique value\e[0m"
                    echo  
                    read -e -p "Enter a unique value : " value
                    echo
                  fi
                  done
               else
                  while [[ $value =~ ^[0-9]+$ ]] || [ -z "$value" ]
                  do
                     if [ -z "$value" ]
                     then
                        echo           
                        echo  -e "\e[41mYou must enter a value\e[0m"
                        echo           
                        read -e -p "Enter the value of ${colnames[i]} > " value
                        echo 
                     else
                        echo           
                        echo  -e "\e[41mYou must enter a value of ${coltypes[i]}\e[0m"
                        echo           
                        read -e -p "Enter value of string : " value
                        echo  
                     fi
                  done
               fi
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
echo  
echo -e "\e[42mRecord is inserted successfully\e[0m"
echo 
