#!/bin/bash 

#THERE IS A DIRECTORY THAT HOLDS ALL DATABASES CALLED "database"
#
#
#
clear
echo "welcome to Our DataBase Management System"



function mainmenu {
	
echo "~~Menu~~"
echo "|1. Create New DB|"
echo "|2. Open DB      |"
echo "|3. List All DB  |"
echo "|4. Delete DB    |"
echo "|0. Exit         |"
echo "+~~~~~~+"

read -p "~> " choice

case $choice in

	1) createdb
	   ;;
	2) opendb
       	   ;;
	3) listdb
	   ;;
	4) deletedb
	   ;;
	0) exit 0
	   ;;
        *) echo "Please Choose from Menu!"
	   sleep 5	
	   clear	
	   mainmenu
	   ;;   
esac
}



function createdb
{
	echo "Welcome In Create Your DATABASE"
	read -p "Choose a Name: " namedb
	mkdir -p ~/database/"$namedb"
       	             #'$?' holds the exit status of the lasted executed command 
	if [ $? = 0 ]; then 
          
		  echo " Successfully Created DataBase! "
		  tables "$namedb"
          else
		  echo " ERROR! "
	fi		

}

function listdb
{
  ls ~/database
}

function deletedb
{
read -p "Enter DB to be Deleted: " namedb
rm -r ~/database/"$namedb" 2>>/dev/null

       if [ $? = 0]; then

                  echo " Successfully Deleted DataBase! "
                  ls - ~/database
          else
                  echo " ERROR! "
        fi
mainmenu

}

function opendb
{
   ls ~/database
   read -p "Pick which DataBase: " namedb

   if [[ -d ~/database/"$namedb" ]]; then

                 cd ~/database/"$namedb"
		 ls ~/database/"$namedb"
		 tablesmenu "$namedb"
          else
                  echo "No DataBase with that Name!"
   fi

}

function tablesmenu()
{
echo "~~~~Menu~~~~"
echo "|1. Create New Table         |"
echo "|2. List Tables              |"
echo "|3. Delete Table             |"
echo "|4. Content of Table         |"
echo "|5. Insert in Table          |"
echo "|6. Delete Record from Table |"
echo "|7. UpDate Table             |"
echo "|8. Select Table             |"
echo "|0. Exit                     |"
echo "+~~~~~~~~~~+"

read -p "~> " choice

case $choice in

	1) tables "$namedb" 
           ;;
        2) ls ~/database/$namedb
           ;;
        3) deletetable
           ;;
        4) displaycontent
           ;;
	5) insert
           ;;
	6) deleterecord
           ;;
        7) update
           ;;
        8) seltable
           ;;
        0) exit 0
           ;;
        *) echo "Please Choose from Menu!"
           sleep 3
           clear
           tablesmenu
           ;;
esac

}

function insert()
{
 data="| "
 ls ~/database/"$namedb"

 read -p "Enter Table's Name:" tname
 cat ~/database/"$namedb"/"$tname"

fnumber=$(awk -F'|' 'NR==1{print NF}' ~/database/"$namedb"/"$tname")

#start from second field and end at the n-1 field 
#due to the decoraction purposes 
 for (( j=2 ; j<$fnumber ; j++ )); do

firstfield=$( head -n 1 ~/database/"$namedb"/"$tname" | cut -d "|" -f $j | cut -d ":" -f 1)

secondfield=$( head -n 1  ~/database/"$namedb"/"$tname" | cut -d "|" -f $j | cut -d ":" -f 2)

thirdfield=$( head -n 1 ~/database/"$namedb"/"$tname" | cut -d "|" -f $j | cut -d ":" -f 3)

 retvaltype=1


 while [[ "$retvaltype" -eq 1 || "$retvalpk" -eq 1 ]]; do
read -p "Enter $firstfield:" input

 if [[ "$secondfield" == "str" && "$input" =~ ^[a-zA-Z]+$ ]]; then
   	echo "valid Input datatype"
        retvaltype=0 
 	fi
 if [[ "$secondfield" == "int" && "$input" =~ ^[0-9]+$ ]]; then
   	echo "valid Input datatype"
        retvaltype=0
 	fi

 if [[ "$thirdfield" == "pk " ]]; then
	lines=$(wc -l < ~/database/"$namedb"/"$tname")
	for (( i=2 ; i<=$lines ; i++)); do
val=$(head -n "$i" ~/database/"$namedb"/"$tname" | tail -n 1 | cut -d '|' -f 1 )
        
	if [[ "$val" -eq "$input" ]]; then
        echo "invaled primary key"
		retvalpk=1
        else
        echo "valed primary key "
		retvalpk=0
        fi
	done
 fi
 done
data+=$input" |"
 done	 
echo $data >> ~/database/"$namedb"/"$tname"
 

  
}

function deletetable()
{
 read -p "Enter Table's Name: " tname

 if [ -e ~/database/"$namedb"/"$tname" ]; then
         rm ~/database/"$namedb"/"$tname"
         echo "Successfully DELETED!" 
 else
         echo "Failed to delete !"

 fi

 tablesmenu "$namedb"
}

function deleterecord()
{
read -p "Enter Table's Name: " tname
cat ~/database/"$namedb"/"$tname"
read -p "Enter Data About Record You want To Delete: " input
sed -i "/$input/d" ~/database/"$namedb"/"$tname"
cat ~/database/"$namedb"/"$tname"
}

function tables()
{

 read -p "Enter Number of Tables:" num
  if [[ $num -le 0 ]]; then
	  echo "ReEnter A Positive Number!"
	  tables
  fi

#do an 'if' if num is integer or not
# already exised name choose another namedb 

 for (( i=1 ; i<=$num ; i++)); do 
        ls ~/database/"$namedb"
	pk="pk"
 	data="|  "
	read -p "Enter Table $i Name: " tname
        while [ -f ~/database/"$namedb"/"$tname" ];
	do	
 		echo " '$tname' already exits."
		read -p "Enter a Unique Name: " tname	
	
	done
                touch ~/database/"$namedb"/"$tname"
	read -p "Enter Number of Colums: " colnum
	
	

	for(( counter=1 ; counter <= "$colnum" ; counter++)); do
         read -p "Enter Name of Column $counter:  " colname
	 
	 retval=1 
	 echo "Type:"
	 echo "     1.Intger"
	 echo "     2.String"

	 while [ $retval = 1 ]; do
		 retval=0
	 read  -p "Enter Value: " ch
	 case $ch in
	  1) coltype="int"
			 ;;
	  2) coltype="str"
			 ;;
	  *) echo " Wrong Choice Enter A Valid Number!"
 	 	retval=1 
			 ;;
	 esac
  	 done

         	if [[ $pk == "pk" ]]; then
                  
                   echo "Primary key?"
                   read -p "[1. yes / 2.no] " choice

		   case $choice in
			1) data+=$colname":"$coltype":"$pk"  |  "
   				pk="?"
				;;
			2) data+=$colname":"$coltype":- |  "
				;;
				
		   esac

		  
	   	else  
		   data+=$colname":"$coltype"  |  "	   
		fi
		
	 done
         echo $data >> ~/database/$namedb/$tname
	 
		
        
 		
done
tablesmenu "$namedb"
}




mainmenu
