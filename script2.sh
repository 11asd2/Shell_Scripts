#!/bin/bash
echo  "Main Files:" > /tmp/temp_main.txt
echo  "Module Files:" > /tmp/temp_mod.txt
echo  "Other Files:" > /tmp/temp_other.txt
main=0
mod=0
other=0
for file in $(find $1 -type f -name '*.c');
do
	if grep -q ' main(' "$file"; then
		echo "$file:$(grep -o 'printf(' "$file" | wc -l),$(grep -o 'fprintf(' "$file" | wc -l)" >> /tmp/temp_main.txt
		main=1
	elif grep -q 'init_module(' "$file"; then
		echo -n "$file:" >> /tmp/temp_mod.txt
		grep -n 'printk(' "$file" | sed -e 's/:.*//' | tr '\n' ',' | sed -e 's/,$/\n/' >> /tmp/temp_mod.txt
		mod=1
	else 
		echo "$file" >> /tmp/temp_other.txt
		other=1
	fi
done

if (($main==1)); then
	cat /tmp/temp_main.txt
else 
	echo "No main file"
fi
if (($mod==1)); then
	cat /tmp/temp_mod.txt
else
	echo "No module file"
fi
if (($other==1)); then
	cat /tmp/temp_other.txt
else
	echo "No other file"	
fi


rm /tmp/temp_main.txt /tmp/temp_mod.txt /tmp/temp_other.txt

