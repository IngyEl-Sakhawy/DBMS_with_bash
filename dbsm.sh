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
read -p "Enter DB to be Deleted: " name
rm -r ~/database/"$name" 2>>/dev/null

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
   read -p "Pick which DataBase: " name

   if [[ -f ~/database/"$name" ]]; then

                 cd ~/database/"$name"
		 ls ~/database/"$name"
		 tablesmenu "$name"
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


function tables()
{

data="|  "


 read -p "Enter Number of Tables:" num
  if [[ $num -le 0 ]]; then
	  echo "ReEnter A Positive Number!"
	  tables
  fi

#do an 'if' if num is integer or not
# already exised name choose another namedb 

 for (( i=1 ; i<=$num ; i++)); do 
        ls ~/database/"$namedb"
	pk="*"
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

         	if [[ $pk == "*" ]]; then
                  
                   echo "Primary key?"
                   read -p "[1. yes / 2.no] " choice

		   case $choice in
			1) data+=$colname":"$coltype":"$pk"  |  "
				;;
			2) data+=$colname":"$coltype"  |  "
				;;
				
		   esac

		  pk="?"
	   	else  
		   data+=$colname":"$coltype"  |  "	   
		fi
		
	 done
         echo $data >> ~/database/$namedb/$tname
	 
		
        
 		
done
tablesmenu "$namedb"
}




mainmenus