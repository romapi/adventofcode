#!/bin/bash

route=$1

if [ ! -f $route ]
then
  echo "Route instruction file '${route}' does not exist"
  exit 1 
fi

range=0
depth=0
aim=0
result=0

function add_to_range () {
  range=$(($range + $1))
  # echo -n " - range: $range"
}

function multiply_depth_by_range () {
  result=$(($depth * $range))
}

function increase_aim () {
  # echo -n " (aim: $aim + $1 = "
  aim=$(($aim + $1))
  # echo "$aim)"
}

function decrease_aim () {
  # echo -n " (aim: $aim - $1 = "
  aim=$(($aim - $1))
  # echo "$aim)"
}

function increase_depth_by_aim () {
  # echo -n " (depth: $depth + ($1 * $aim) = "
  depth=$(($depth + ($1 * $aim)))
  # echo "$depth)"
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
      increase_depth_by_aim $value
    elif [[ "$direction" == "down" ]]; then
      increase_aim $value
    elif [[ "$direction" == "up" ]]; then
      decrease_aim $value
    else 
      echo "Undefined direction: $direction"
    fi 
  done
}

navigate
multiply_depth_by_range

echo "depth = $depth, range = $range, aim = $aim"
echo "result (depth * range): $result"
