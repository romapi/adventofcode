#!/bin/bash

route=$1

if [ ! -f $route ]
then
  echo "Route instruction file '${route}' does not exist"
  exit 1 
fi

range=0
depth=0
result=0

function add_to_range () {
  range=$(($range + $1))
  # echo " - range: $range"
}

function add_to_depth () {
  depth=$(($depth + $1))
  # echo " - depth: $depth"
}

function substract_from_depth () {
  depth=$(($depth - $1))
  # echo " - depth: $depth"
}

function multiply_depth_by_range () {
  result=$(($depth * $range))
}

function navigate () {
  local len

  IFS=$'\n' read -d '' -r -a instructions < "$route"

  len=${#instructions[@]}
  echo "Number of instructions: $len"
  # echo $instructions

  for (( j=0; j<${len}; j++ )); do 
    local direction=0
    local value=0
    # echo "Instruction #$j: ${instructions[$j]}"
    direction=$(echo ${instructions[$j]} | cut -d " " -f 1)
    value=$(echo ${instructions[$j]} | cut -d " " -f 2)
    # echo -n "Instruction #$j: direction: $direction, value: $value"
    if [[ "$direction" == "forward" ]]; then 
      add_to_range $value
    elif [[ "$direction" == "down" ]]; then
      # echo -n "Instruction #$j: direction: $direction, value: $value" 
      add_to_depth $value
    elif [[ "$direction" == "up" ]]; then  
      # echo -n "Instruction #$j: direction: $direction, value: $value"
      substract_from_depth $value
    else 
      echo "Unknown direction: $direction"
    fi 
  done
}

navigate
multiply_depth_by_range

echo "depth = $depth, range = $range"
echo "result = $result"