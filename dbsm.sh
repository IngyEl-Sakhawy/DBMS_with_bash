#!/bin/bash 

#THERE IS A DIRECTORY THAT HOLDS ALL DATABASES CALLED "database"
#
#
#
#-------------------------------------------------------------Ingy's Functions---------------------------------------------------------------------
clear
echo "welcome to Our DataBase Management System"
echo "-----------------------------------------"
echo "Made By Ziad Elganzory & Ingy Elsakhawy  "
echo "-----------------------------------------"
if [[ ! -d ~/database ]]; then
	mkdir ~/database
 	echo "System Intialized Successfully"
fi 


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
	while [ -d ~/database/"$namedb" ]; do
 		echo ""$namedb" already exits. "
   		read -p "Enter a Unique Name:" namedb
 	done  
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
  mainmenu
}

function deletedb
{
ls ~/database
read -p "Enter DB to be Deleted: " namedb
rm -r ~/database/"$namedb" 2>>/dev/null

if [[ $? = 0 ]]; then
echo " Successfully Deleted DataBase! "
ls  ~/database
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
echo "~~~~~~~~~~~~~Menu~~~~~~~~~~~~~"
echo "|1. Create New Table         |"
echo "|2. List Tables              |"
echo "|3. Delete Table             |"
echo "|4. Content of Table         |"
echo "|5. Insert in Table          |"
echo "|6. Delete Record from Table |"
echo "|7. UpDate Table             |"
echo "|8. Select From Table By Row |"
echo "|9. Select From Table By Col |"
echo "|0. Exit                     |"
echo "+~~~~~~~~~~~~~~~~~~~~~~~~~~~~+"

read -p "~> " choice

case $choice in

	1) tables "$namedb" 
           ;;
        2) ls ~/database/$namedb
           tablesmenu "$namedb"	
           ;;
        3) deletetable "$namedb"
           ;;
        4) displaycontent "$namedb"
           ;;
	5) insert "$namedb"
           ;;
	6) deleterec "$namedb"
           ;;
        7) update "$namedb"
           ;;
        8) selrow "$namedb"
           ;;
	9) selcol "$namedb"
	   ;;
        0) exit 0
           ;;
        *) echo "Please Choose from Menu!"
           sleep 3
           clear
           tablesmenu "$namedb"
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
        val=$(head -n "$i" ~/database/"$namedb"/"$tname" | tail -n 1 | cut -d '|' -f $j )
        
	if [[ "$val" -eq "$input" ]]; then
        echo "invaled primary key"
		retvalpk=1
        else
        
		retvalpk=0
        fi
	done
 fi
 done
data+=$input" | "
 done	 
echo $data >> ~/database/"$namedb"/"$tname"
 
tablesmenu "$namedb"
  
}

function deletetable()
{
ls ~/database/"$namedb"
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
read -p "Enter Number of Tables:" num
if [[ $num -le 0 ]]; then
echo "ReEnter A Positive Number!"
read -p "Enter Number of Tables:" num
fi
#do an 'if' if num is integer or not
# already exised name choose another namedb 
for (( i=1 ; i<=$num ; i++ )); do 
ls ~/database/"$namedb"
pk="pk"
data="|  "
read -p "Enter Table $i Name: " tname
while [ -f ~/database/"$namedb"/"$tname" ]; do	
echo " '$tname' already exits."
read -p "Enter a Unique Name: " tname		
done
touch ~/database/"$namedb"/"$tname"
read -p "Enter Number of Colums: " colnum
for(( counter=1 ; counter <= "$colnum" ; counter++)); do
read -p "Enter Name of Column $counter: " colname	 
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
		   data+=$colname":"$coltype":- |  "	   
		fi
		
	 done
         echo $data >> ~/database/$namedb/$tname
	 
		
        
 		
done
tablesmenu "$namedb"
}
#-------------------------------------------------------------Ziad's Functions---------------------------------------------------------------------
function displaycontent()
{ ls ~/database/"$namedb"
  read -p "Enter Tabel's Name: " tname
  if [ -e ~/database/"$namedb"/"$tname" ]; then
	  echo "Content of $tname: "
	  cat ~/database/"$namedb"/"$tname"
  else
	  echo "Table is not Existed!"
  fi
  tablesmenu "$namedb"
}



function update() 
{
	ls ~/database/"$namedb"
	read -p "Enter Table Name: " tname
	if [ -e ~/database/"$namedb"/"$tname" ]; then
		read -r first_line < <(head -n 1 ~/database/"$namedb"/"$tname")
		IFS='|' read -ra columns <<< "$first_line"

		pk_col_index=-1
		for ((i=1;i<${#columns[@]};i++)); do
			if [[ "${columns[i]}" == *":pk"* ]]; then
				pk_col_index=$i
				break
			fi
		done

		if [ "$pk_col_index" -eq -1 ]; then
			echo "No Primary Key Found"
			tablesmenu "$namedb"
		fi

		numrow=$(wc -l < ~/database/"$namedb"/"$tname")

		numcol=$(awk 'NR==1{print NF}' ~/database/"$namedb"/"$tname")

		read -p "Enter The Record Primary Key: " pkey
		for ((j=2;j<=numrow;j++)); do
			precord=$(head -n $j < ~/database/"$namedb"/"$tname"|tail -n 1 | cut -d "|" -f 2  )
			if [[ "$precord" -eq "$pkey" ]]; then
				oldrow=$(head -n $j < ~/database/"$namedb"/"$tname" | tail -n 1)
				echo $oldrow
				break
			fi
		done
		
		read -p "Enter Name You Want to modify: " fname

		for ((i=2; i<=numcol-1; i++)); do
    			name=$(head -n 1 < ~/database/"$namedb"/"$tname" | tail -n 1 | cut -d "|" -f $i | cut -d ":" -f 1)

    			dt=$(head -n 1 < ~/database/"$namedb"/"$tname" | tail -n 1 | cut -d "|" -f $i | cut -d ":" -f 2)
    			if [[ "$(echo "$fname" | tr -d '[:space:]')" == "$(echo "$name" | tr -d '[:space:]')" ]]; then
        			read -rp "Enter Input According to $dt DataType: " inp_val

        			if [ -z "$inp_val" ]; then
            				continue
        			fi

        			if [ $i -eq 2 ] && grep -q "|$inp_val|" ~/database/"$namedb"/"$tname"; then
            				echo "Primary Key Must Be Unique"
            				break
        			fi

        			oldval=$(echo "$oldrow" | cut -d "|" -f $i)
				if [ "$dt" == "int" ]; then
            				if [[ "$inp_val" =~ ^[0-9]+$ ]]; then
              					sed -i "s/$oldval/ $inp_val /" ~/database/"$namedb"/"$tname"
                 				echo "Updated Table"
						cat ~/database/"$namedb"/"$tname"
					else
                 				echo "Data Type Doesn't Match. Expected: int"
             		   			break
					fi
		         	fi
 
 		        if [ "$dt" == "str" ]; then
				if [[ "$inp_val" =~ ^[a-zA-Z]+$ ]]; then
                        		sed -i "s/$oldval/ $inp_val /" ~/database/"$namedb"/"$tname"
                         		echo "Updated Table"
					cat ~/database/"$namedb"/"$tname"
                 		else
                         		echo "Data Type Doesn't Match. Expected: str"
                         		break
                 		fi
        		fi

    			fi
		done

	else
		echo "File Not Found!"
	fi

	tablesmenu "$namedb"
	
}


function selrow()
{
	ls ~/database/"$namedb"
        read -p "Enter Table Name: " tname
        if [ -e ~/database/"$namedb"/"$tname" ]; then
                read -r first_line < <(head -n 1 ~/database/"$namedb"/"$tname")
                echo "MetaData Of Table"
                echo $first_line
                IFS='|' read -ra columns <<< "$first_line"

                pk_col_index=-1
                for ((i=1;i<${#columns[@]};i++)); do
                        if [[ "${columns[i]}" == *":pk"* ]]; then
                                pk_col_index=$i
                                break
                        fi
                done

                if [ "$pk_col_index" -eq -1 ]; then
                        echo "No Primary Key Found"
                        tablesmenu "$namedb"
                fi

                numrow=$(wc -l < ~/database/"$namedb"/"$tname")

                numcol=$(awk 'NR==1{print NF}' ~/database/"$namedb"/"$tname")

                read -p "Enter The Primary Key TO Select Record: " pkey
                for ((j=2;j<=numrow;j++)); do
                        precord=$(head -n $j < ~/database/"$namedb"/"$tname"|tail -n 1 | cut -d "|" -f 2 )
                        if [[ "$precord" -eq "$pkey" ]]; then
                                oldrow=$(head -n $j < ~/database/"$namedb"/"$tname" | tail -n 1)
                                echo "Selected Row : " $oldrow
                                break
			fi
                done
        else
                echo "File Not Found!"
        fi

        tablesmenu "$namedb"

}

function selcol()
{
	ls ~/database/"$namedb"
        read -p "Enter Table Name: " tname
        if [ -e ~/database/"$namedb"/"$tname" ]; then
                read -r first_line < <(head -n 1 ~/database/"$namedb"/"$tname")
                echo "MetaData Of Table"
                echo $first_line
                
		numrow=$(wc -l < ~/database/"$namedb"/"$tname")

		numcol=$(awk 'NR==1{print NF}' ~/database/"$namedb"/"$tname")

		read -p "Enter The Name Of The Column you Want To Select: " fname
 		for ((i=2;i<=numcol-1;i++)); do
			name=$(head -n 1 < ~/database/"$namedb"/"$tname" | tail -n 1 | cut -d "|" -f $i | cut -d ":" -f 1)
   			if [[ "$(echo "$fname" | tr -d '[:space:]')" == "$(echo "$name" | tr -d '[:space:]')" ]]; then
				for (( j=1;j<=numrow;j++ )); do
					echo "| " $(head -n $j <~/database/"$namedb"/"$tname" | tail -n 1 | cut -d "|" -f $i) " |"
				done
				break
			fi
		done


        else
              echo "File Not Found!"
        fi

        tablesmenu "$namedb"

}

function deleterec()
{
        read -p "Enter Table Name: " tname
        if [ -e ~/database/"$namedb"/"$tname" ]; then
                read -r first_line < <(head -n 1 ~/database/"$namedb"/"$tname")
                echo "MetaData Of Table"
                echo $first_line
                IFS='|' read -ra columns <<< "$first_line"

                pk_col_index=-1
                for ((i=1;i<${#columns[@]};i++)); do
                        if [[ "${columns[i]}" == *":pk"* ]]; then
                                pk_col_index=$i
                                break
                        fi
                done

                if [ "$pk_col_index" -eq -1 ]; then
                        echo "No Primary Key Found"
                        tablesmenu "$namedb"
                fi

                numrow=$(wc -l < ~/database/"$namedb"/"$tname")

                numcol=$(awk 'NR==1{print NF}' ~/database/"$namedb"/"$tname")

                read -p "Enter The Row You Want TO Select: " pkey
                for ((j=2;j<=numrow;j++)); do
                        precord=$(head -n $j < ~/database/"$namedb"/"$tname"|tail -n 1 | cut -d "|" -f 2 )
                        if [[ "$precord" -eq "$pkey" ]]; then
                                oldrow=$(head -n $j < ~/database/"$namedb"/"$tname" | tail -n 1)
                                echo "Deleted Row : " $oldrow
				sed -i "/$oldrow/d" ~/database/"$namedb"/"$tname"
                                break
			else
				echo "Primary Key Is Not Found!"
			fi
                done

		echo "Table After Delete"
		echo " "
		cat ~/database/"$namedb"/"$tname"

        else
                echo "File Not Found!"
        fi

        tablesmenu "$namedb"

}


mainmenu
