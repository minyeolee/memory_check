#!bin/bash
#This file was created on 06/22/2016

mem_usg=$( free | grep Mem: | awk '{ printf "%.0f%\n", $3*100/$2}' )

while getopts ":c:w:e:" opt
 do
  case $opt in
      c ) ct=$OPTARG
      ;;
      w ) wt=$OPTARG
      ;;
      e ) ea=$OPTARG
      ;;
      \? ) 
            echo "Invalid option -$OPTARG"
      ;;
      
 esac
done

shift $((OPTIND - 1))

  if [[ -n $ct ]] && [[ -n $wt ]] && [[ -n $ea ]]
    then
      echo "Memory Usage: $mem_usg"
      echo "Critical Threshold: $ct"
      echo "Warning Threshold: $wt"
      echo "Email Address: $ea"
      
     if [[ $ct -gt $wt ]]
       then
       
         if [ "$mem_usg" -ge "$ct" ]
          then
            TO=$ea
            SUBJECT="Subject: $( date '+%Y%m%d %H:%M' ) memory check - critical"
            MEM_REPORT=$( ps axo %mem,comm,pid | sort -nr | head -n 10 )
             (
              echo "To: $TO"
              echo "Subject: $SUBJECT"
              echo "Message: $MEM_REPORT"
             ) | sendmail -t $ea
             
           exit 2
         fi
         
         if [ "$mem_usg" -ge "$wt" ]
          then
           if [ "$mem_usg" -lt "$ct" ]
            then
              exit 1
           fi
         fi
         
         if [ "$mem_usg" -lt "$wt" ]
          then
            exit 0
         fi
         
     else
         echo "Critical Threshold should always be greater than the Warning Threshold!"
     fi
     
  else
      echo "Required parameters are:"
      echo "-c Critical Threshold"
      echo "-w Warning Threshold"
      echo "-e Email Address to send report"
     
  fi

