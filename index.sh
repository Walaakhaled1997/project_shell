#!/usr/bin/ksh
set -x

while true
do
	select_operation=`zenity --width=500 --height=500 --list --column "" "Create New DataBase" "Choise Exist DataBase"  --text "Choise what you want to need do" --title 				"Database-management" --cancel-label "Exit" `;
	echo $select_operation;
	if [[ $select_operation != "" ]]; then
		case $select_operation in
			"Create New DataBase")
				name_database=`zenity --width=500 --height=500 --entry --text "Please enter Your Database Name"  --title "Database-Management" `

				if [[ $name_database != "" ]]; then
					cd DataBase;
					if [[ -d $name_database ]]; then 
						zenity --info --text "DataBase $name_database is exist  \!"
					else 

						mkdir $name_database;
						../create_database.sh $name_database
						

					fi
					
				fi		
			;;
			"Choise Exist DataBase")
				./exist_database.sh	
			;;
			
			
		esac
		 
	else
		if zenity --question --text="Do you want to exit program?"
		then 
			break;
		fi
		
	fi

done
set +x
