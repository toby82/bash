#!/bin/bash
#echo -en "please input ip:"
read -p "please input ip: " ip 
echo $ip | awk -F"." '
{
	if (    ($1<=256 && $1>=0) &&
	        ($2<=256 && $2>=0) &&
                ($3<=256 && $3>=0) &&
	        ($4<=256 && $4>=0) &&
	        (NF=4) &&
	        ($1 ~ /^[0-9]+$/) &&
	        ($2 ~ /^[0-9]+$/) &&
		($3 ~ /^[0-9]+$/) &&
		($4 ~ /^[0-9]+$/))

	{
	print $0,"correct"
	}
	else
	{
	print $0,"error"
	}

}'
