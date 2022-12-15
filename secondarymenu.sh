#!/bin/bash

 cd ./dbs/$1
  pwd
COLUMNS=0
select choice in "Create Table" "List Tables" "Drop Table" "Insert into Table" "Select From Table" "Delete From Table" "Update Table" "Exit"
do
	case $REPLY in 
		1) echo Here you create table:
                     read -e -p "Enter the name of the file > " filename
                     touch $filename
			;;
		2) echo The tables are:
                    function PP () {
                       local longest=0
                       local string_array=("${@}")
                       for i in "${string_array[@]}"; do
                       if [[ "${#i}" -gt "${longest}" ]]; then
                       local longest=${#i}
                       local longest_line="${i}"
                       fi
                       done

                       local edge=$(echo "$longest_line" | sed 's/./#/g' | sed 's/^#/###/' | sed 's/#$/###/')
                       local middle_edge=$(echo "$longest_line" | sed 's/./\ /g' | sed 's/^\ /#\  /' | sed 's/\ $/\ \ #/')

                       echo -e "\n${edge}"
                       echo "${middle_edge}"

                       for i in "${string_array[@]}"; do
                       local length_i=${#i}
                       local length_ll="${#longest_line}"
                       if [[ "${length_i}" -lt "${length_ll}"  ]]; then
                       printf "# "
                       local remaining_spaces=$((length_ll-length_l))
                       printf "${i}"
                       while [[ ${remaining_spaces} -gt ${#i} ]]; do
                       printf " "
                       local remaining_spaces=$((remaining_spaces-1))
                       done
                       printf " #\n"
                       else
                       echo "# ${i} #"
                       fi
                       done

                       echo "${middle_edge}"
                       echo -e "${edge}\n"
                      }
                      PP `ls`
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
