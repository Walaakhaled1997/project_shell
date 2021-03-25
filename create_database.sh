#!/usr/bin/ksh

set -x
function_name_column_name_and_type()
{
	item=1;
	value_zenity="zenity --width=500 --height=500 --title=Database-management\
	--forms --text=Columns ";
	name_column='Column';
	list_com='int|string|float'
 	num_column=$1;
	while [ $item -le $num_column ]
	do
		
		value_zenity=$value_zenity' --add-entry='"$name_column""$item"' --add-combo=Type --combo-values='"$list_com";
		item=$(($item+1));
		
	done
	values=`$value_zenity`;
	echo $values;
}

function_validation()
{
	
	i=0;
	while true
	do
		
		column_name=`echo $1 | awk -F"|" '{print $('$i+1')}'`;
		column_type=`echo $1 | awk -F"|" '{print $('$i+2')}'`;

		if [[ $column_name != "" && $column_type != "" ]] then
			show_info_name+=($column_name);
			show_info_type+=($column_type);
			i=$(($i+2));
			
		else
			break;
		fi
	done
	
	
	if [[ $i -eq $(($2*2)) ]] then
		


		cd ~/Desktop/project_shell/DataBase/$database_name;
		
		if [[ -f $table_name ]]; then
 
			zenity --info --text "DataBase $table_name is exist  \!"
		else 

			touch $table_name.csv
			touch $table_name"_MeteData".csv
			chmod +x 777 $table_name.csv
			chmod +x 777 $table_name"_MeteData".csv
			echo "id,int|pk|auto" > $table_name"_MeteData".csv
			
			j=0;
			while [[ $j -lt $2 ]]
			do
				save_info_table=${show_info_name[$j]}","${show_info_type[$j]}
				echo $save_info_table >> $table_name"_MeteData".csv
				j=$(($j+1));
			done
			
				 
						
			echo 1;
		fi
   	else
		
		echo 0;	
	fi
	

}

#### -MAIN- ######
database_name=$1;
while true
do
	data_info=`zenity --width=500 --height=500 --title "Database-management" \
		--forms --text="Table" \
	   	--add-entry="Table Name" \
		--add-entry="Number Columns"`;

	table_name=`echo $data_info | awk -F"|" '{print $1}'`;
	number_field=`echo $data_info | awk -F"|" '{print $2}'`;

	vlag_name=true;
	
 	valid_name=`echo $table_name | awk -F" " '{print $2}'`;

	if [[ $valid_name != "" ]] then
		vlag_name=false;
	else
		vlag_name=true;
	fi


	if [[ $table_name != "" && $number_field != "" && $vlag_name = true ]] then

		return_columns=`function_name_column_name_and_type $number_field`; # get columns with type
		return_validation=`function_validation $return_columns $number_field`; # create Table

		echo $return_validation
		if [[ $return_validation = "1" ]] then
			
			zenity --width=500 --height=500 --title "Database-management" \
			--info --text="Success Create Table $table_name" ;
			break;

		else
			
			false_return=`zenity --width=500 --height=500 --title "Database-management" \
			--error --text="Please Enter require Data " `;
			if [[ $false_return = "cancel" ]] then
				break;
			fi
		fi

		
	else
		zenity  --title "Database-management" \
		--error --text="Please , Enter valid Data require !!" ;   		
	fi
	
done


set +x
