#!/bin/bash

#set -xv

ABSOLTE_FLAG=0
DELTA_FLAG=0

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
DeltaRegX="^[0-9]{4}$"

AbsoluteTimeRegX="^[0-9]{2}-[a-zA-Z]{3}-[0-9]{4} [0-9]{2}:[0-9]{2}:[0-9]{2}:[0-9]{2}$"
DeltaTimeRegX="^[0-9]{4}-[0-9]{2}:[0-9]{2}:[0-9]{2}:[0-9]{2}$"
#RegX="[a-zA-Z]"  
RegX="^[a-zA-Z]+$"

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
   if [[ ${INPUT} =~ ${AbsoluteTimeRegX}  ]]
   then
     ABSOLUTE_FLAG=1
     INPUT1=`echo $INPUT | cut -d " " -f1`
     INPUT2=`echo $INPUT | cut -d " " -f2 | cut -d ":" -f1,2,3`

   elif [[ ${INPUT} =~ ${DeltaTimeReg} ]]
   then
     DELTA_FLAG=1
     INPUT1=`echo $INPUT | cut -d "-" -f1`
     INPUT2=`echo $INPUT | cut -d "-" -f2 | cut -d ":" -f1,2,3`
   else
     echo "Input is not valid"
     exit 1
   fi
   if [[ ! ${INPUT2} =~ ${TimeRegX} ]]
   then
     INPUT2="00:00:00"
   fi
   INPUT="$INPUT1 $INPUT2"
 fi
 echo "INPUT is $INPUT"


if [ ${DELTA_FLAG} -eq 1 ] && [ "${OTF}" != "DELTA" ]
then
   echo "If input time is delta , you must specify output_time_format as delta"
   exit 2;
fi

############Output time format###############
 case $OTF in
        "ABSOLUTE")
            OUTPUT=`date -d "$INPUT" +'%d-%b-%Y %H:%M:%S:%C'`
            ;;
        "COMPARISON")
            OUTPUT=`date -d "$INPUT" +'%Y-%m-%d %H:%M:%S:%C'`
            ;;
        "DELTA")
            OUTPUT=`echo $INPUT`
            ;;
        *)  OUTPUT=`date -d "$INPUT" +'%Y-%m-%d %H:%M:%S:%C'`
            echo "output=$OUTPUT"
            ;;
   esac
##########output format#####################
 case $OF in
        "DATE")
            echo "OUTPUT is `echo $OUTPUT | cut -d " " -f1`"
            ;;
        "MONTH")
            echo "OUTPUT is `echo $OUTPUT | cut -d " " -f1 | cut -d "-" -f2`"
            ;;
        "SECOND")
            echo "OUTPUT is `echo $OUTPUT | cut -d " " -f2 | cut -d ":" -f3`"
            ;;
	"DAY")
            echo "OUTPUT is `echo $OUTPUT | cut -d " " -f1 | cut -d "-" -f1`"
            ;;
	"TIME")
            echo "OUTPUT is `echo $OUTPUT | cut -d " " -f2`"
            ;;
	"HOUR")
            echo "OUTPUT is `echo $OUTPUT | cut -d " " -f2 | cut -d ":" -f1`"
            ;;
	"WEEKDAY")
            echo "you chose choice $REPLY which is $opt"
            ;;
	"HUNDREDTH")
            echo "you chose choice $REPLY which is $opt"
            ;;
	"YEAR")
            echo "OUTPUT is `echo $OUTPUT | cut -d " " -f1 | cut -d "-" -f2`"
            ;;
	"MINUTE")
            echo "OUTPUT is `echo $OUTPUT | cut -d " " -f2 | cut -d ":" -f2`"
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
        *)  echo "OUTPUT is $OUTPUT"
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

FCVTIME "$input_time" "$output_time_format" "$output_field"
