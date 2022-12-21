#!/bin/bash

echo 
read -e -p "Enter the name of the table : " filename
echo

while [ -z "$filename" ] || [[ $filename = *" "* ]] || ! [[ $filename =~ ^[a-zA-Z] ]] || [ -f $filename ] || [[ ^$filename =~ [1-9:!\|@\{#$%\&*\`~+=?.\>\<,\;:\_\-\ ] ]]
do
if [ -z "$filename" ]
then
   echo           
   echo  -e "\e[41mYou must enter a name \e[0m"
   echo           
   read -e -p "Enter the name of the table : " filename
   echo   
elif [[ $filename = *" "* ]]
then
    echo
		echo -e "\e[41mThe name can't contain spaces\e[0m"
    echo
    read -e -p "Enter the name of the table you want to create : " filename
    echo 
elif [[ ^$filename =~ [1-9:!\|@\{#$%\&*\`~+=?.\>\<,\;:\_\-\ ] ]]
then
    echo
		echo -e "\e[41mYou can't enter these characters \e[0m"
    echo
		read -e -p "Enter the name of the table you want to create : " filename
    echo
elif ! [[ $filename =~ ^[a-zA-Z] ]]
then
    echo
		echo -e "\e[41mYou can't enter these characters \e[0m"
    echo
		read -e -p "Enter the name of the table you want to create : " filename
    echo
else
    echo           
    echo  -e "\e[41mThis table name is already used. Try again! \e[0m"
    echo           
    read -e -p "Enter the name of the table : " filename
    echo 
fi        
done
     
                     echo
                     echo "Please enter the number of columns : " 
                     read cols 
                     echo
                     while [ -z "$cols" ] || ! [[ $cols =~ ^[0-9]+$ ]] || [ $cols -lt 1 ]
                     do
                         if [ -z "$cols" ]
                         then
                           echo           
                           echo  -e "\e[41mYou must enter a number \e[0m"
                           echo           
                           read -e -p "Enter the number of columns : " cols
                           echo                         
                         elif ! [[ $cols =~ ^[0-9]+$ ]]
                         then
                           echo           
                           echo -e "\e[41mThis is not a number  \e[0m"
                           echo           
                           read -e -p "Enter the column number : "  cols
                           echo 
                         else
                           echo           
                           echo -e "\e[41mTable must have at least one column \e[0m"
                           echo           
                           read -e -p "Enter the number of column 1 or greater than 1 : " cols
                           echo 
                         fi
                      done
                      
         if [ $cols -gt 0 ]
         then
             touch $filename
             touch .$filename"meta"
             echo
             echo -e "\e[42mTable is created sucessfully \e[0m"
             echo       
         fi
                   
                      
    typeset -i counter
    typeset -i signedpkey
    counter=1
    assignedpkey=0



while [ $counter -le $cols ]
do
  echo
  read -e -p "Enter the name of the column : " name
  echo

while [ -z "$name" ] || [[ $name = *" "* ]] || ! [[ $name =~ ^[a-zA-Z] ]] || [[ ^$name =~ [1-9:!\|@\{#$%\&*\`~+=?.\>\<,\;:\_\-\ ] ]] ||  cut -d: -f1 .$filename"meta" | grep -q -w "$name" > /dev/null
do
if [ -z "$name" ]
then
    echo           
    echo  -e "\e[41mYou must enter a name\e[0m"
    echo           
    read -e -p "Enter the name of column > " name
    echo   
elif [[ $name = *" "* ]]
then
    echo
		echo -e "\e[41mThe name can't contain spaces\e[0m"
    echo
    read -e -p "Enter the name of the column you want to create > " name
    echo 
elif [[ ^$name =~ [1-9:!\|@\{#$%\&*\`~+=?.\>\<,\;:\_\-\ ] ]]
then
    echo           
	  echo -e "\e[41mThe name can't contain spaces\e[0m"
    echo           
    read -e -p "Enter the name of the column : " name
    echo 
elif ! [[ $name =~ ^[a-zA-Z] ]]
then
    echo
		echo -e "\e[41mYou can't enter these characters \e[0m"
    echo
		read -e -p "Enter the name of the column you want to create > " name
    echo
else
    echo           
    echo -e "\e[41mThe column already exist. Choose another name! \e[0m"
    echo        
    read -e -p "Enter the name of the column : " name
    echo  
fi        
done



  if [ $assignedpkey -ne 1 ]
  then

     echo           
     echo would you like it to be primary key : 
     echo "  y) Yes"
     echo "  n) No"
     read pk

     while [[ $pk != *(y)*(n) || -z "$pk" ]] 
     do
      echo           
      echo -e "\e[41m Invalid choice! \e[0m" 
      echo           
      read -e -p "Please choose y or n " pk
      echo           
     done 

        echo choose :
        echo "  int"
        echo "  string"
        read choice 
        while [[ $choice != *(int)*(string) || -z "$choice" ]] 
        do
            echo           
            echo -e "\e[41m Invalid choice! \e[0m" 
            echo           
            read -e -p "Please choose int or string : " choice
            echo           
       done
     if [ $pk = "y" ]
     then 
       assignedpkey=1  
        echo $name:$choice:primarykey >> .$filename"meta"
        echo           
        echo -e "\e[42mColumn added sucessfully \e[0m"
        echo  
     fi
     if [ $pk = "n" ]
     then 
       assignedpkey=0  
        echo $name:$choice: >> .$filename"meta"
        echo           
        echo -e "\e[42mColumn added sucessfully \e[0m"
        echo  
     fi
     else
        echo choose :
        echo "   int"
        echo "   string"
        read choice 
        while [[ $choice != *(int)*(string) || -z "$choice" ]] 
        do
            echo           
            echo -e "\e[41m Invalid choice! \e[0m" 
            echo           
            read -e -p "Please choose int or string : " choice
            echo           
        done
        echo $name:$choice: >> .$filename"meta"
        echo           
        echo -e "\e[42mColumn added sucessfully \e[0m"
        echo           
  fi
  counter=$counter+1
done

if [ $assignedpkey -eq 0 ]
then
       awk 'BEGIN {OFS=FS=":"} {if(NR == 1) $3="primarykey"; print $0 > "'.$filename"meta"'" }' .$filename"meta"
fi
