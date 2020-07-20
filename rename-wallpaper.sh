#!/bin/bash

#####################
# @author: Lucas Martins Mendes
# rename wallpapers numerically
####################

category=$1
input=$2
output=$3
path=$4

list=$(ls $input/$category) #get current list of unprocessed wallpapers
if [ -z "$list" ] #folder is empty
then
    echo -e "\t nothing to do here \n"
    exit 0
fi

#N="$(ls $path | grep "$(category)" | grep -o '[0-9]\{3\}' | sort -g | tail -n 1)"

if [[ -z $N ]]; then N=001; fi
echo "starting number is $N"

i=$N
echo -e "to process:\n$list\n" | column
for w in $list
do
    let i++
    convert -verbose "$input/$category/$w" "$output/$category-$(printf %03d $i).png"
done
