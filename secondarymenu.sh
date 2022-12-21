#!/bin/bash

echo
echo
border()
{
    COLUMNS=$(tput cols) 
    title="| $1 |"
    edge=$(echo "$title" | sed 's/./-/g')
    printf "%*s\n" $(((${#title}+$COLUMNS)/2)) "$edge"
    printf "%*s\n" $(((${#title}+$COLUMNS)/2)) "$title"
    printf "%*s\n" $(((${#title}+$COLUMNS)/2)) "$edge"
}
border "Welcome to database $1!"
echo
echo

entry=`echo -e "\e[36m$1\e[0m"`
PS3=''$entry' db >> Enter your choice : '
 cd ./dbs/$1

COLUMNS=0
select choice in "Create Table" "List Tables" "Drop Table" "Insert into Table" "Select From Table" "Delete From Table" "Update Table" "Exit"
do
	case $REPLY in 
		1) echo
		   echo Here you can create your table:
		   echo
 
                  ./../../createtable.sh 
            
            ;;
		2)  echo
		    echo The tables are:
		    echo
                   ./../../borderlist.sh
            echo
			echo     
			;;
		3) echo 
		   read -e -p "Enter the neame of the table you want to delete : " fname
		   echo
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
					  echo
                      echo -e "\e[44mTable is deleted sucessfully \e[0m"
					  echo
                    else
					  echo
		              echo -e "\e[41mThe table doesn't exist\e[0m"
					  echo
                    fi
			;;
		4) echo
		   echo Here you can insert into a table : 
		   echo
		        ./../../inserttb.sh
           echo
			;;
		5) echo
		   echo Here you can select from a table : 
		   echo
                       ./../../select.sh
		   echo
 			;;
		6) echo
		   echo Here you can delete from a table :
		   echo
                        ./../../delete.sh
		   echo
			;;
		7) echo
		   echo Here you can update a table :
		   echo
		        ./../../updatetb.sh
		   echo
			;;
		8) exit
			;;
		*) echo
		   echo invalid choice 
		   echo
			;;
	esac
done
