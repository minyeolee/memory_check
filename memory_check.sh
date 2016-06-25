#!bin/bash
#This file was created on 06/22/2016

mem_usg=$( free | grep Mem: | awk '{ printf "%.2f%\n", $3*100/$2}' )

while getopts ":c:w:e:" opt
 do
  case $opt in
      c ) ct=$OPTARG
            echo "Critical Threshold $OPTARG%"
      ;;
      w ) wt=$OPTARG
            echo "Warning Threshold $OPTARG%"
      ;;
      e ) ea=$OPTARG
            echo "Email Address to send report $OPTARG"
      ;;
      \? ) 
            echo "Invalid option -$OPTARG"
      ;;
      : ) 
            echo "Required parameters are: -c Critical Threshold -w Warning Threshold -e Email Address to send report"
      ;;
 esac
done

shift $((OPTIND - 1))

  if [[ -n $ct ]] && [[ -n $wt ]] && [[ -n $ea ]] && [[ $ct -gt $wt ]]
    then
      echo "sample"
    else
      echo "Required parameters are:"
      echo "-c Critical Threshold"
      echo "-w Warning Threshold"
      echo "-e Email Address to send report"
      echo "**Critical Threshold should always be greater than Warning Threshold**"
  fi

