#!/bin/bash

entry=`echo -e "\e[36mYOLE\e[0m"`
PS3=''$entry' >> Enter your update choice : '


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
border "Welcome to YOLE DBMS"
echo
echo

if [ ! -d dbs ]
then
  mkdir dbs
  echo -e "\e[42mThe folder for databases is created successfully\e[0m"
fi
echo 
echo
COLUMNS=0
select choice in "Create Database" "List Database" "Connect To Database" "Drop Database" "Exit"
do
case $REPLY in
1) echo
   echo "Enter your database name : "
       read answer
 while [ -z "$answer" ]
      do
           echo           
           echo  -e "\e[41mYou must enter a name\e[0m"
           echo           
           read -e -p "Enter the name of the database you want to create > " answer
           echo           
      done
while [[ $answer = *" "* ]]; do
          echo
		echo -e "\e[41mThe name can't contain spaces\e[0m"
          echo
          read -e -p "Enter the name of the database you want to create > " answer
          echo           
      done

	while  [[ ^$answer =~ [1-9:!\|@\{#$%\&*\`~+=?.\>\<,\;:\_\-\ ] ]]; do
		echo
          echo -e "\e[41mYou can't enter these characters \e[0m"
		echo
          read -e -p "Enter the name of the database you want to create > " answer
          echo           
      done
	while  [[ -e ./dbs/$answer ]]; do
		echo
          echo  -e "\e[41mThis database name is already used\e[0m"
	     echo
          read -e -p "Enter the name of the database you want to create > " answer
          echo           
      done
	   if  [[ $answer =~ ^[a-zA-Z] ]]; then
		mkdir ./dbs/$answer
         echo
         echo -e "\e[42mDatabase created sucessfully \e[0m"
         echo
	
	
	else
          echo
		echo -e "\e[41mDatabase name can't start with numbers or special characters\e[0m"
          echo
	fi



;;
2) echo  
   echo The databases are :
                   cd ./dbs
                     ./../borderlist.sh
                  
                      cd ..
			;;
3) echo
   read -e -p "Enter the database you want to connect with : " dbname
   echo
      while [ -z "$dbname" ]
      do
           echo           
           echo  -e "\e[41mYou must enter a name\e[0m"
           echo           
           read -e -p "Enter the name of the database you want to connect to > " dbname
           echo           
      done

     while [ ! -d ./dbs/$dbname ]
    do
          echo
          echo -e "\e[41mThis database doesn't exist\e[0m"
          echo
          read -e -p "Enter the name of the database you want to connect to > " dbname
          echo           
      done

     if [ -d ./dbs/$dbname ]
     then
          gnome-terminal -- bash -c "./secondarymenu.sh $dbname; bash" > /dev/null

	fi
;;
4)    echo
      echo "Enter database name you want to delete : "
      read name
      while [ -z "$name" ]
      do
           echo           
           echo  -e "\e[41mYou must enter a name\e[0m"
           echo           
           read -e -p "Enter the name of the database you want to delete > " name
           echo           
      done
while [[ $name = *" "* ]]; do
		echo
          echo -e "\e[41mThe name can't contain spaces\e[0m"
          echo
          read -e -p "Enter the name of the database you want to create > " name
          echo           
      done
	while [[ ^$name =~ [1-9:!\|@\{#$%\&*\`~+=?.\>\<,\;:\_\] ]]; do
		echo
          echo -e "\e[41mYou can't enter these characters \e[0m"
		echo
          read -e -p "Enter the name of the database you want to create > " name
          echo           
      done
while ! [[ -d ./dbs/$name ]]; do
			echo
               echo -e "\e[41mthis database doesn't exist\e[0m"
               echo	
	          read -e -p "Enter the name of the database you want to create > " name
               echo  
done
    if [[ -e ./dbs/$name ]]; then
                rm -r ./dbs/$name
          echo
		echo -e "\e[44mYour database is deleted  sucessfully \e[0m"
          echo
		
      fi
   
;;
5) exit
esac
done





