#!/bin/bash

 cd ./dbs/$1
  pwd
COLUMNS=0
select choice in "Create Table" "List Tables" "Drop Table" "Insert into Table" "Select From Table" "Delete From Table" "Update Table" "Exit"
do
	case $REPLY in 
		1) echo Here you create table:
 
                  ./../../createtable.sh 
            
            ;;
		2) echo The tables are:
                   

                   ./../../borderlist.sh
                 
			;;
		3)  read -e -p "Enter the neame of the table you want to delete > " fname
                    if [ -f $fname ]
                    then
                          rm $fname
                          rm .$fname"meta"
                          echo -e "\e[44mTable is deleted sucessfully \e[0m"
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
