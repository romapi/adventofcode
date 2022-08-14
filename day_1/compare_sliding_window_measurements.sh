#!/bin/bash

measurements=$1

if [ ! -f $measurements ]
then
  echo "Measurements ${measurements} file does not exist"
  exit 1 
fi

sot_increased=0

function compare_sot_measurements () {
  local previous=$1
  local current=$2
  local group=$3
  local msg="Group $group: $current -"
  if [ "$current" -gt "$previous" ] ; then 
    msg="$msg increased" 
    sot_increased=$(($sot_increased + 1))
  elif [ "$current" -eq "$previous" ]; then 
    msg="$msg no change"
  elif [ "$current" -lt "$previous" ]; then 
    msg="$msg decreased" 
  fi
  echo "$msg"
}

function compute_sum_of_three () {
  local first
  local sot_prev
  local sot_cur
  first=true
  
  IFS=$'\n' read -d '' -r -a numbers < "$measurements"
  len=${#numbers[@]}

  # minus 2 because length starts from 1, but array index starts from 0
  local loop_len=$(($len - 2))

  # echo "Numbers: $len"
  for (( j=0; j<${loop_len}; j++ )); do 
    # echo "Group $j: ${numbers[$j]}, ${numbers[$(($j + 1))]}, ${numbers[$(($j + 2))]}"
    sot_cur=$((${numbers[$j]} + ${numbers[$(($j + 1))]} + ${numbers[$(($j + 2))]}))
    if [ $first == false ] 
    then 
      compare_sot_measurements $sot_prev $sot_cur $j 
      sot_prev=$sot_cur
    else 
      first=false
      sot_prev=$sot_cur
    fi 
  done

  echo "Sum of 3 neighbouring measurements increased: $sot_increased"
}

compute_sum_of_three
