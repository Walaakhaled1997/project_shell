#!/usr/bin/ksh
set -x


execu_insert()
{
	valid_table=`echo $1 | awk -F"|" '{print $2}'`;
	
	get_tables=` ls -l $2  | grep ^- | awk '{print $9}' | awk  '{print $1}' | awk '!/_MeteData.csv/ {print}' | awk -F".csv" '{print $1}' `;	

	
	## check table exist ## 
	vlag_table=false;
	is_int="";
	for table in $get_tables
	do
		if [[ $valid_table == $table ]] then
			
			vlag_table=true;
			count_c=2;
			get_metaData=`cat $2/$table"_MeteData.csv" | awk -F"," '{print $2}' `;
			for field in $get_metaData
			do
				echo $field
				if [[ $field == "int" ]] then 
					is_int=$count_c;
					echo "$is_int"	
				fi	
				count_c=$(($count_c+2));
			done	
		fi	
		
	done
	## --##

	if [[ "$vlag_table" = true ]] ; then
	
		## syntax query ( )##
		valid_character=`echo $1 | grep -oP '(?<=\().*?(?=\))' `;
		if [[ $valid_character != "" ]] then 
			count_att=1;
			attribute_value=`echo $valid_character | awk -F"," '{print $0 }'`;
			for item in $attribute_value
			do
				count_att=$(($count_att+1));
			done
		else
		
	 		zenity --width=500 --height=500 --title "Database-management" --error --text="(1) Qyery not valid, \n syntax error!";
		fi
		## -- ##
	else
		zenity --width=500 --height=500 --title "Database-management" --error --text="table not exist";
	
	fi
	## syntax query num att##
	if [[ $((((($count_c-2))/2)-1)) -ne $count_att ]] then
		
		zenity --width=500 --height=500 --title "Database-management" --error --text="(2) Qyery not valid, \n syntax error!";
	fi
	
	if [[ $is_int!="" ]] then

		attribute_value=`echo $valid_character | awk -F"," '{print $'$(($is_int/2))'}'`
		if [[ "$attribute_value" = *([0-9]) ]] then
			
			##insert##
			increase_id=`cat $2/$table".csv" | awk -F"," '{print $1}' | awk '{a[NR]=$0} END{print a[NR]}' `; 
			
			new_id=$(($increase_id+1));
			if [[ $increase_id!="" ]] then
				echo $new_id","$valid_character >> $2/$table".csv"
				zenity --width=500 --height=500 --title "Database-management" --info --text="succssefull";
			else

				echo $new_id","$valid_character > $2/$table".csv"
				zenity --width=500 --height=500 --title "Database-management" --info --text="succssefull";
			fi
		else
			zenity --width=500 --height=500 --title "Database-management" --error --text="Qyery not valid, \n syntax error!";
		fi
	fi

}
execu_select()
{
	#select column-name/* from table-name
	valid_table=`echo $1 | awk -F"|" '{print $4}'`;
	get_tables=` ls -l $2  | grep ^- | awk '{print $9}' | awk  '{print $1}' | awk '!/_MeteData.csv/ {print}' | awk -F".csv" '{print $1}' `;	

	vlag_table=false;
	
	for table in $get_tables
	do
		if [[ $valid_table == $table ]] then
			
			vlag_table=true;
			column_name="";
			count_c=1;
			get_metaData=`cat $2/$table"_MeteData.csv" | awk -F"," '{print $1}' `;
			for field in $get_metaData
			do
				 
				column_name=$column_name" --column=$field";				
				count_c=$(($count_c+1));
		 	done		
		fi	
	done

	valid_astric=`echo $1 | awk -F"|" '{print $2}'`;
	echo $valid_astric
	if [[ "$valid_astric" == "@" ]] then

		valid_from=`echo $1 | awk -F"|" '{print $3}'`;
		if [[ $valid_from = [fF]rom ]] then
			if [[ "$vlag_table" = true ]] ; then
				
				#valid_where=`echo $1 | awk -F"|" '{print $5 }'`;
				#if [[ $valid_where!="" ]] then
		
					
				#else
					display_table=`cat $2/$valid_table".csv"  | sed -r 's/,/ /g' | awk -F" " '{print $0}'`;
				 	awk -F' ' '{ print $1 "\n" $2 "\n" $3 }' <<< $display_table  | zenity --list --title="Database-management" --text="$valid_table" $column_name ;
				#fi
			else
				zenity --width=500 --height=500 --title "Database-management" --error --text=" Qyery not valid, \n syntax error!";
			fi
				
			
		else
			zenity --width=500 --height=500 --title "Database-management" --error --text=" Qyery not valid, \n syntax error!";
			
			
		fi
		
	else
		zenity --width=500 --height=500 --title "Database-management" --error --text=" Qyery not valid, \n syntax error!";
	fi

	
	
}


execu_delete()
{

	valid_table=`echo $1 | awk -F"|" '{print $3}'`;
	get_tables=` ls -l $2  | grep ^- | awk '{print $9}' | awk  '{print $1}' | awk '!/_MeteData.csv/ {print}' | awk -F".csv" '{print $1}' `;	

	vlag_table=false;
	
	for table in $get_tables
	do
		if [[ $valid_table == $table ]] then
			
			vlag_table=true;
				
		fi	
	done
	valid_where=`echo $1 | awk -F"|" '{print $4}'`;
	valid_from=`echo $1 | awk -F"|" '{print $2}'`;
	if [[ $valid_astric=[fF]rom ]] then
		if [[ "$vlag_table" = true ]] ; then
			
			
				echo "" > $2/$valid_table".csv"
			
			
		fi
			
	else
		zenity --width=500 --height=500 --title "Database-management" --error --text=" Qyery not valid, \n syntax error!";
			
			
	fi
}

execu_drop()
{
	valid_table=`echo $1 | awk -F"|" '{print $2}'`;
	get_tables=` ls -l $2  | grep ^- | awk '{print $9}' | awk  '{print $1}' | awk '!/_MeteData.csv/ {print}' | awk -F".csv" '{print $1}' `;	

	vlag_table=false;
	
	for table in $get_tables
	do
		if [[ $valid_table == $table ]] then
			
			vlag_table=true;
				
		fi	
	done
	
		if [[ "$vlag_table" = true ]] ; then
			
			
			rm $2/$valid_table".csv"
			rm $2/$valid_table"_MeteData.csv"
		else
			zenity --width=500 --height=500 --title "Database-management" --error --text=" Qyery not valid, \n syntax error!";
			
		fi
	
}


while true
do
#insert table-name (value1 , value2 , ..)


	get_query=`zenity --width=500 --height=500 --title "Database-management" \
		 --entry  --text="Query" --extra-button="Exit" --extra-button="back" --ok-label "Execute query"  `;
	echo $get_query

	if [[ $get_query!="" ]] then

		arrange_query=`echo $get_query | tr -s ' ' `;
		check_op=`echo $arrange_query | awk -F" " '{print $1}'`;
		case $check_op in
				"insert" | "Insert" )
					replace_char=`echo $arrange_query | sed -r 's/ /\|/g' `;
					return_columns=`execu_insert $replace_char $1`; 
				;;
				"select" | "Select" )
					replace_char=`echo $arrange_query | sed -r 's/ /\|/g' `;
					return_columns=`execu_select $replace_char $1`;
				;;

				"delete" | "Delete" )
					replace_char=`echo $arrange_query | sed -r 's/ /\|/g' `;
					return_columns=`execu_delete $replace_char $1`; 
				;;

				"drop" | "Drop" )
					replace_char=`echo $arrange_query | sed -r 's/ /\|/g' `;
					return_columns=`execu_drop $replace_char $1`; 
				;;
				
				"back")
					break;
					
				;;

				
		esac
		

	fi    	
done
set +x
