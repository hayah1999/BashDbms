#!/bin/bash

 cd ./dbs/$1
  pwd
COLUMNS=0
select choice in "Create Table" "List Tables" "Drop Table" "Insert into Table" "Select From Table" "Delete From Table" "Update Table" "Exit"
do
	case $REPLY in 
		1) echo Here you create table:
                     read -e -p "Enter the name of the file > " filename
                    #./../../tcharcheck.sh  $filename
                     
                     if [[ $filename = *" "* ]]; then
                     		echo -e "\e[41mTable name can't have spaces. Try again! \e[0m"
                     
                     	elif  [[ ^$filename =~ [1-9:!\|@\{#$%\&*\`~+=?.\>\<,\;:\ ] ]]; then
                     		echo -e "\e[41mYou can't enter these characters. Try again! \e[0m"
                     		
                     	elif [[ -f $filename ]]; then
                     		echo  -e "\e[41mThis table name is already used. Try again! \e[0m"
                     	
                     	elif  [[ $filename =~ ^[a-zA-Z] ]]; then
                     		          touch $filename
                                        touch .$filename"meta"
                           echo -e "\e[42mTable created sucessfully \e[0m"
                     	
                     	else
                     		echo -e "\e[41mTable name can't start with numbers or special characters. Try again! \e[0m"
                     	fi
            ;;
		2) echo The tables are:
                   

                   ./../../borderlist.sh
                 
			;;
		3)  read -e -p "Enter the neame of the table you want to delete > " fname
                    if [ -f $fname ]
                    then
                          rm $fname
                    else
		    echo -e "\e[41mThe table doesn't exist\e[0m"
  
                    fi
			;;
		4) echo insert
			;;
		5) echo select
			;;
		6) echo delete
			;;
		7) echo update
			;;
		8) exit
			;;
		*) echo invalid choice 
			;;
	esac
done
