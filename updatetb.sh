#!/bin/bash

read -e -p "which table you want to update : " filename
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
ispk=`awk -F: 'BEGIN {col}{ if ( $3 == "primarykey") col=$1} END {print col }' .$filename"meta"`
coltypes=(`awk -F: '{ print $2 }' .$filename"meta"`)
PS3=''$filename' table >> Enter your update choice : '

COLUMNS=0
select choice in "Update a specific record" "Update records based on a pattern" "Exit"
do
	case $REPLY in 
    1) echo only a record:
       read -e -p "Which column you want to update: " colname

            while [ -z "$colname" ] ||  ! cut -d: -f1 .$filename"meta" | grep -q -w "$colname" 
            do
            if [ -z "$colname" ] 
            then
                   echo           
                   echo  -e "\e[41mYou must enter a name\e[0m"
                   echo           
                   read -e -p "Enter the name of column > " colname
                   echo     
            else   
                   echo           
                   echo -e "\e[41mThe column doesn't exist. Choose another name! \e[0m"
                   echo        
                   read -e -p "Enter the name of the column : " colname
                   echo          
            fi
            done

            index=-1
            for i in "${!colnames[@]}";
            do 
              if [[ "${colnames[$i]}" = "$colname" ]];
              then
              index=$i
              break
              fi
              done
        
        echo
        echo -e "\e[45mThe column that is primary key is : $ispk \e[0m"
        echo



        read -e -p "what is the value of column $ispk you want to change : " value

         while [ -z "$value" ] ||  ! grep -q -w "$value" $filename
            do
            if [ -z "$value" ] 
            then
                   echo           
                   echo  -e "\e[41mYou must enter a value\e[0m"
                   echo           
                   read -e -p "Enter the value that exist > " value
                   echo     
            else   
                   echo           
                   echo -e "\e[41mThe value doesn't exist. Choose another value! \e[0m"
                   echo        
                   read -e -p "Enter the value that exist >  " value
                   echo          
            fi
            done
        

            

        read -e -p "what is the new value you want in column $colname  : " newvalue
           

            if [ ${coltypes[$index]} = "string" ]
            then
               if [ $colname = $ispk ]
               then
                  while grep -q -w $newvalue $filename || [[ $newvalue =~ ^[0-9]+$ ]] || [ -z "$newvalue" ]
                  do
                  if [[ $newvalue =~ ^[0-9]+$ ]]
                  then
                    echo           
                    echo  -e "\e[41mYou must enter a value of ${coltypes[$index]}\e[0m"
                    echo           
                    read -e -p "Enter value of string : "  newvalue
                    echo 
                  elif [ -z "$newvalue" ]
                  then
                    echo           
                    echo  -e "\e[41mYou must enter a value\e[0m"
                    echo           
                    read -e -p "Enter the value of $colname > " newvalue
                    echo  
                  else
                    echo  
                    echo -e "\e[41mThis has to be unique value\e[0m"
                    echo  
                    read -e -p "Enter a unique value : " newvalue
                    echo
                  fi
                  done
               else
                  while [[ $newvalue =~ ^[0-9]+$ ]] || [ -z "$newvalue" ]
                  do
                     if [[ $newvalue =~ ^[0-9]+$ ]]
                     then
                       echo           
                       echo  -e "\e[41mYou must enter a value of ${coltypes[$index]}\e[0m"
                       echo           
                       read -e -p "Enter value of string : "  newvalue
                       echo 
                     else
                       echo           
                       echo  -e "\e[41mYou must enter a value\e[0m"
                       echo           
                       read -e -p "Enter the value of $colname > " newvalue
                       echo  
                     fi
                  done
               fi
            fi

    

            if [ ${coltypes[$index]} = "int" ]
            then
               if [ $colname = $ispk ]
               then
                  while grep -q -w $newvalue $filename || ! [[ $newvalue =~ ^[0-9]+$ ]] || [ -z "$newvalue" ]
                  do
                  if ! [[ $newvalue =~ ^[0-9]+$ ]]
                  then
                    echo           
                    echo  -e "\e[41mYou must enter a value of ${coltypes[$index]} \e[0m"
                    echo           
                    read -e -p "Enter value of int : "  newvalue
                    echo 
                  elif [ -z "$newvalue" ]
                  then
                    echo           
                    echo  -e "\e[41mYou must enter a value \e[0m"
                    echo           
                    read -e -p "Enter the value of $colname > " newvalue
                    echo  
                  else
                    echo  
                    echo -e "\e[41mThis has to be unique value\e[0m"
                    echo  
                    read -e -p "Enter a unique value : " newvalue
                    echo
                  fi
                  done
               else
                  while ! [[ $newvalue =~ ^[0-9]+$ ]] || [ -z "$newvalue" ]
                  do
                     if ! [[ $newvalue =~ ^[0-9]+$ ]]
                     then
                       echo           
                       echo  -e "\e[41mYou must enter a value of ${coltypes[$index]} \e[0m"
                       echo           
                       read -e -p "Enter value of int : "  newvalue
                       echo 
                     else
                       echo           
                       echo  -e "\e[41mYou must enter a value\e[0m"
                       echo           
                       read -e -p "Enter the value of $colname > " newvalue
                       echo  
                     fi
                  done
               fi
            fi
    indexofpk=-1
            for j in "${!colnames[@]}";
            do 
              if [[ "${colnames[$j]}" = "$ispk" ]];
              then
              indexofpk=$j
              break
              fi
            done
            let indexofpk=$indexofpk+1
      

            indexofcol=-1
            for j in "${!colnames[@]}";
            do 
              if [[ "${colnames[$j]}" = "$colname" ]];
              then
              indexofcol=$j
              break
              fi
            done

            let indexofcol=$indexofcol+1


    awk 'BEGIN {OFS=FS=":"} {if($'$indexofpk'=='$value') $'$indexofcol'="'$newvalue'"; print $0 > "'$filename'" }' $filename 
    ;;
    2) echo update when finding certain pattern:

        read -e -p "Which column you want to update: " colname

            while [ -z "$colname" ] ||  ! cut -d: -f1 .$filename"meta" | grep -q -w "$colname" || [ $colname = $ispk ]
            do
            if [ -z "$colname" ] 
            then
                   echo           
                   echo  -e "\e[41mYou must enter a name\e[0m"
                   echo           
                   read -e -p "Enter the name of column > " colname
                   echo  
            elif [ $colname = $ispk ]
            then
                   echo           
                   echo  -e "\e[41mYou can't base the update on this column it's primary key. It's value is unique!\e[0m"
                   echo           
                   read -e -p "Enter the name of column > " colname
                   echo  
            else   
                   echo           
                   echo -e "\e[41mThe column doesn't exist. Choose another name! \e[0m"
                   echo        
                   read -e -p "Enter the name of the column : " colname
                   echo          
            fi
            done


            index=-1
            for i in "${!colnames[@]}";
            do 
              if [[ "${colnames[$i]}" = "$colname" ]];
              then
              index=$i
              break
              fi
              done




        read -e -p "what is the value of column $colname you want to change : " value

         while [ -z "$value" ] ||  ! grep -q -w "$value" $filename
            do
            if [ -z "$value" ] 
            then
                   echo           
                   echo  -e "\e[41mYou must enter a value\e[0m"
                   echo           
                   read -e -p "Enter the value that exist > " value
                   echo     
            else   
                   echo           
                   echo -e "\e[41mThe value doesn't exist. Choose another value! \e[0m"
                   echo        
                   read -e -p "Enter the value that exist >  " value
                   echo          
            fi
            done




        
        read -e -p "what is the new value you want in column $colname  : " newvalue
           

            if [ ${coltypes[$index]} = "string" ]
            then
                  while [[ $newvalue =~ ^[0-9]+$ ]] || [ -z "$newvalue" ]
                  do
                     if [ -z "$newvalue" ]
                     then
                       echo           
                       echo  -e "\e[41mYou must enter a value\e[0m"
                       echo           
                       read -e -p "Enter the value of $colname > " newvalue
                       echo 
                     else
                       echo           
                       echo  -e "\e[41mYou must enter a value of ${coltypes[$index]}\e[0m"
                       echo           
                       read -e -p "Enter value of string : "  newvalue
                       echo 
                     fi
                  done
            fi

            if [ ${coltypes[$index]} = "int" ]
            then
                  while ! [[ $newvalue =~ ^[0-9]+$ ]] || [ -z "$newvalue" ]
                  do
                     if [ -z "$newvalue" ]
                     then
                       echo           
                       echo  -e "\e[41mYou must enter a value\e[0m"
                       echo           
                       read -e -p "Enter the value of $colname > " newvalue
                       echo  
                     else
                       echo           
                       echo  -e "\e[41mYou must enter a value of ${coltypes[$index]}\e[0m"
                       echo           
                       read -e -p "Enter value of int : "  newvalue
                       echo   
                     fi
                  done
            fi

         sed -i 's/'$value'/'$newvalue'/g' $filename

    ;;
    3) exit
    ;;
    *) echo  -e "\e[41mInvalid choice \e[0m"
    ;;
esac
done