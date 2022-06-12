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
TimeRegX="^[0-9]{2}:[0-9]{2}:[0-9]{2}$"
RegX="[a-zA-Z]"

FCVTIME() {
 INPUT=$1
 OTF=$2
 OF=$3

#############Input######################### 
 if [[ -z ${INPUT} ]]
 then
   INPUT=`date +'%d-%b-%Y %H:%M:%S'`
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
     INPUT2="00:00:00"
   fi
   INPUT="$INPUT1 $INPUT2"
 fi
 echo "INPUT is $INPUT"


############Output time format###############
 case $OTF in
        "ABSOLUTE")
            OUTPUT=`date -d "$INPUT" +'%d-%b-%Y %H:%M:%S:%C'`
            ;;
        "COMPARISON")
            OUTPUT=`date -d "$INPUT" +'%Y-%m-%d %H:%M:%S:%C'`
            ;;
        "DELTA")
            OUTPUT=`date -d "$INPUT" +'%d-%H:%M:%S:%C'`
            ;;
        *)  OUTPUT=`date -d "$INPUT" +'%Y-%m-%d %H:%M:%S:%C'`
            ;;
   esac
##########output format#####################
 case $OF in
        "DATE")
            echo "You choose choice1"
            ;;
        "MONTH")
            echo "you chose choice 2"
            ;;
        "SECOND")
            echo "you chose choice $REPLY which is $opt"
            ;;
	"DAY")
            echo "you chose choice $REPLY which is $opt"
            ;;
	"TIME")
            echo "you chose choice $REPLY which is $opt"
            ;;
	"HOUR")
            echo "you chose choice $REPLY which is $opt"
            ;;
	"WEEKDAY")
            echo "you chose choice $REPLY which is $opt"
            ;;
	"HUNDREDTH")
            echo "you chose choice $REPLY which is $opt"
            ;;
	"YEAR")
            echo "you chose choice $REPLY which is $opt"
            ;;
	"MINUTE")
            echo "you chose choice $REPLY which is $opt"
            ;;
	"DAYOFYEAR")
            echo "you chose choice $REPLY which is $opt"
            ;;
	"HOUROFYEAR")
            echo "you chose choice $REPLY which is $opt"
            ;;
	"MINUTEOFYEAR")
            echo "you chose choice $REPLY which is $opt"
            ;;
	"SECONDOFYEAR")
            echo "you chose choice $REPLY which is $opt"
            ;;
        *)  echo "OTPUT is $OUTPUT"
            ;;
    esac

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
