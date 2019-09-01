#!/bin/bash
FILEEOS42=/usr/local/nagios/unpaid_blocks_teloskitchen.temp
CLEOS=cleos

# Check if teloskitchen is in top21
BP=$(cleos system listproducers -j -l 51 | jq ".rows[].owner" | grep -c teloskitchen) 

if [ $BP -gt 0 ];
	then
		OLD=$(<$FILEEOS42)
		echo "Old unpaid_blocks: $OLD"
		UNPAID="$(/bin/bash $CLEOS get table eosio eosio producers -l 150 | /bin/grep -A 6 "teloskitchen" | /bin/grep unpaid_blocks | /bin/grep -oP '(?<= )[0-9]+')"
		echo $UNPAID > $FILEEOS42

		if [[ $UNPAID -eq $OLD ]];
		then
			echo "Not Producing"
			exit 2
		else
			echo "Successfully Producing" >&2
			exit 0
		fi
	else
		echo "Not in Top21" >&2
		exit 0
fi

