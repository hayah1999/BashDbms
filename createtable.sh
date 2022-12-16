#!/bin/bash

function  createTable () {
    read -e -p "Please enter the number of columns : " cols 
    typeset -i counter
    typeset -i signedpkey
    counter=1
    assignedpkey=0
    
    while [ cols -le counter ]
    do
     read -e -p "Enter the name of the column : " name
     

}