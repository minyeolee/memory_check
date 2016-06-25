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
      
 esac
done

shift $((OPTIND - 1))

  if [[ -n $ct ]] && [[ -n $wt ]] && [[ -n $ea ]] && [[ $ct -gt $wt ]]
    then
      echo "Memory Usage: $mem_usg"
      echo "Critical Threshold: $ct"
      echo "Warning Threshold: $wt"
      echo "Email Address: $ea"
    
    if [[ $mem_usg -ge $ct ]]
     then
      exit 2
    fi
    
    if [[ $mem_usg -ge $wt ]]
     then
      if [[ $mem_usg -lt $ct ]]
       then
         exit 1
      fi
    fi
    
    if [[ $mem_usg -lt $wt ]]
     then
       exit 0
    fi
    
  else
      echo "Required parameters are:"
      echo "-c Critical Threshold"
      echo "-w Warning Threshold"
      echo "-e Email Address to send report"
      echo "**Critical Threshold should always be greater than Warning Threshold**"
  fi

