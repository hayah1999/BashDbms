#!/bin/bash

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