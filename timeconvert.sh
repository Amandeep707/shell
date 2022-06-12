#!/bin/bash

#set -xv

usage() {
   cat 1>&2 <<EOF
Usage: $(basename $0) -c [CITY] -s [STATE]

-i input_time
-o output_time_format
-f output_field

EOF
   exit 1;
}

DateRegX="^[0-9]{2}-[a-zA-Z]{3}-[0-9]{4}$"
TimeRegX="^[0-9]{2}:[0-9]{2}:[0-9]{2}:[0-9]{2}$"
RegX="[a-zA-Z]"

FCVTIME() {
 INPUT=$1
 OTF=$2
 OF=$3
 
 if [[ -z ${INPUT} ]]
 then
   INPUT=`date +'%d-%b-%Y %H:%M:%S:%C'`
#   break
 elif [[ ${INPUT} =~ ${RegX} ]]
 then
   :
 else   
   INPUT1=`echo $INPUT | cut -d " " -f1`
   INPUT2=`echo $INPUT | cut -d " " -f2`
   if [[ ! ${INPUT1} =~ ${DateRegX} ]]
   then
     INPUT1=`date +'%d-%b-%Y'`
   fi
   if [[ ! ${INPUT2} =~ ${TimeRegX} ]]
   then
     INPUT2="00:00:00:00"
   fi
   INPUT="$INPUT1 $INPUT2"
 fi

 echo "INPUT is $INPUT"


}

while getopts i:o:f: flag
do
    case "${flag}" in
        i) input_time=${OPTARG};;
        o) output_time_format=${OPTARG};;
        f) output_field=${OPTARG};;
        *) usage 0 ;;
    esac
done

FCVTIME "$input_time" "$output_time_format" $output_field
