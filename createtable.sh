#!/bin/bash

    
                      read -e -p "Enter the name of the table > " filename
                    #./../../tcharcheck.sh  $filename
                     while [ -z "$filename" ]
                     do
                       echo           
                       echo  -e "\e[41mYou must enter a name \e[0m"
                       echo           
                       read -e -p "Enter the name of the file > " filename
                       echo           
                     done
                     while [ -f $filename ]
                     do
                       echo           
                       echo  -e "\e[41mThis table name is already used. Try again! \e[0m"
                       echo           
                       read -e -p "Enter the name of the table > " filename
                       echo           
                     done

                     while [[ $filename = *" "* ]]
                     do
                     		  echo           
                              echo -e "\e[41mTable name can't have spaces. Try again! \e[0m"
                              echo           
                              read -e -p "Enter the name of the table > " filename
                              echo           
                     done
                     
                     while  [[ ^$filename =~ [1-9:!\|@\{#$%\&*\`~+=?.\>\<,\;:\ ] ]] 
                     do
                              echo           
                     		  echo -e "\e[41mYou can't enter these characters. Try again! \e[0m"
                     	      echo           
                              read -e -p "Enter the name of the table > " filename	
                              echo           
                     done
                     
                     echo "Please enter the number of columns : " 
                     read cols 

                     while ! [[ $cols =~ ^[0-9]+$ ]]
                     do 
                        echo           
                        echo -e "\e[41mThis is not a number  \e[0m"
                        echo           
                        read -e -p "Enter the column number : "  cols
                        echo           
                     done
                    
                     while [ $cols -lt 1 ]
                     do
                          echo           
                          echo -e "\e[41mTable must have at least one column \e[0m"
                          echo           
                          read -e -p "Enter the number of column 1 or greater than 1 : " cols
                          echo           
                          while ! [[ $cols =~ ^[0-9]+$ ]]
                          do
                               echo           
                               echo -e "\e[41mThis is not a number  \e[0m"
                               echo           
                               read -e -p "Enter the column number : "  cols
                               echo           
                          done
                     done

                     if [ $cols -gt 0 ]
                     then
                        touch $filename
                        touch .$filename"meta"
                        
                        echo -e "\e[42mTable is created sucessfully \e[0m"
                        echo       
                     fi
                      
    typeset -i counter
    typeset -i signedpkey
    counter=1
    assignedpkey=0



while [ $counter -le $cols ]
do
  read -e -p "Enter the name of the column : " name
    while  cut -d: -f1 .$filename"meta" | grep -w "$name" > /dev/null
    do 
        echo           
        echo -e "\e[41mThe column already exist. Choose another name! \e[0m"
        echo        
        read -e -p "Enter the name of the column : " name
        echo          
    done
    while [[ $name = *" "* ]]
    do
        echo           
	    echo -e "\e[41mThe name can't contain spaces\e[0m"
        echo           
        read -e -p "Enter the name of the column : " name
        echo           
    done
	while [[ ^$name =~ [1-9:!\|@\{#$%\&*\`~+=?.\>\<,\;:\ ] ]]
    do
        echo           
	    echo -e "\e[41mYou can't enter these characters \e[0m"
        echo           
        read -e -p "Enter the name of the column : " name
        echo           
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

     if [ $pk = "y" ]
     then 
       assignedpkey=1
       echo "Column type is int"
       echo           
       echo $name:int:primarykey >> .$filename"meta"
       echo -e "\e[42mColumn added sucessfully \e[0m"
       echo           
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
        echo $name:$choice >> .$filename"meta"
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
        echo $name:$choice >> .$filename"meta"
        echo           
        echo -e "\e[42mColumn added sucessfully \e[0m"
        echo           
  fi
  counter=$counter+1
done