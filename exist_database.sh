#!/usr/bin/ksh
set -x



while true
do 
	text="";
	
	cd DataBase;
 	get_all_databse=`ls -l | grep ^d | awk '{print $9}'`;
	for item in $get_all_databse
	do
		text=$text"$item"" ";
	done
	select_databse="";
	select_databse=`zenity --width=500 --height=500 --list --column "" $text --text "Choise what you want to need do" --title "Database-management" --cancel-label="Exit" `;
	
	
	if [[ $select_databse ]] 
	then
			get_tables=` ls -l $select_databse  | grep ^- | awk '{print $9}' | awk  '{print $1}' | awk '!/_MeteData.csv/ {print}' | awk -F".csv" '{print $1}' `;	
			echo $get_tables;
			span_tables="<span foreground='blue'> DataBase ($select_databse) </span>";
			i=1;
			for table in $get_tables
			do
				span_tables=$span_tables" \n\n <span>  $table </span>";
				get_metaData=`cat $select_databse/$table"_MeteData.csv"`;
				span_tables=$span_tables"<span>(";
				s=1;
				for field in $get_metaData
				do
					
					name_c=`echo $field | awk -F"," '{print $1}'`;
					type_c=`echo $field | awk -F"," '{print $2}'`;
					replace_char=`echo $type_c | sed -r 's/[|]/ /g' `;
					span_tables=$span_tables"$name_c : $replace_char";
					if [[ $s -eq 1 ]] then
						s=$(($s+1));
						span_tables=$span_tables" , ";
					fi
				done	
				span_tables=$span_tables")</span>";	
				i=$(($i+1));
			done

			
			while true 
			do
				text_info="<span foreground='red'> note: \n 1. write quiry following this: \n a. insert table-name (value1 , value2 , ..)  \n b. select @ from table-name  \n c. delete table-name  \n 2. click on execute query button to excute \n </span>"
				span_tables=$span_tables"\n\n\n <span foreground='black'>Choise What operation you need do </span> \n"
				
				operation_on_table=`zenity --width=500 --height=500 --title "Database-management" --info --text "$span_tables$text_info" --extra-button="New Query" --extra-button="Create Table" --extra-button="Drop Database" --extra-button="back" --ok-label "Exit" `;

				if [[ $operation_on_table != "" ]]; then
					case $operation_on_table in
						"New Query")
							
							../insert_operation.sh $select_databse
						;;

						"Create Table")
							../create_database.sh $select_databse
							
						;;
						"Drop Database")
							
							rmdir $select_databse
							./exist_database.sh
							break 1;
							
						;;
						"back")
							break 1;
							
						;;

					esac	

				else 
					if zenity --question --text="Do you want to exit program?"
					then 
						break 2;
					fi
				fi
		done
	else

		if zenity --question --text="Do you want to exit program?"
		then 
			break;
		fi
	fi
done
set +x
