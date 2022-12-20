#!/bin/bash
PS3=''$1' db >> Enter your choice : '
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
		          while [ -z "$fname" ]
				  do 
				    echo           
                    echo  -e "\e[41mYou must enter a table to delete \e[0m"
                    echo           
                    read -e -p "Enter a table name : "  fname
                    echo 
				  done
					
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

		        ./../../inserttb.sh

			;;
		5) echo select
                       ./../../select.sh
 			;;
		6) echo delete
                        ./../../delete.sh
			;;
		7) echo update
		        ./../../updatetb.sh
			;;
		8) exit
			;;
		*) echo invalid choice 
			;;
	esac
done
