#!/bin/bash

measurements=$1

if [ ! -f $measurements ]
then
  echo "Measurements ${measurements} file does not exist"
  exit 1 
fi

first=1
increased=0
measurement=0
cur=0
prev=0

function compare_measurements () {
  local previous=$1
  local current=$2
  if [ "$current" -gt "$previous" ] ; then 
    echo "$current - increased" 
    increased=$(($increased + 1))
  elif [ "$current" -eq "$previous" ]; then 
    echo "$current - equal"
  elif [ "$current" -lt "$previous" ]; then 
    echo "$current - decreased" 
  fi
}

while IFS= read -r measurement
do
  if [ ! $first == 1 ] 
  then 
    # echo "$measurement"
    compare_measurements $prev $cur 
    prev=$measurement
  else 
    first=0
    prev=$measurement
  fi 
done < "$measurements"

echo "Incremented measurements: $increased"
