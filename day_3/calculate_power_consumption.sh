#!/bin/bash

binary=$1

if [ ! -f $binary ]
then
  echo "Binary input file '${binary}' does not exist"
  exit 1 
fi

gamma=0
gamma_rate=""
ones_in_report=()
epsilon=0
epsilon_rate=""
code_len=0
report_values=0
# epsilon_count=()
result=0

function define_row_counter_array() {
  echo "code len: $1"
  for (( i=0; i<$1; i++ )); do 
    ones_in_report[$i]=0
  done 
}

function print_row_counter_array_values() {
  echo -en "Position: \t"
  for (( i=0; i<$1; i++ )); do 
    echo -en "$i\t "
  done 
  echo ""
  echo -en "Count: \t\t"
  for (( i=0; i<$1; i++ )); do 
    echo -en "${ones_in_report[$i]}\t "
  done 
  echo ""
}

function process_binary_code() {
  local code=$1
  local binary_len=${#code}

  if [[ "$binary_len" != "$code_len" ]]; then 
    echo "Sample binary code length ($code_len) differs from given ($binary_len)"
    exit 1
  fi
  
  for (( i=0; i<${code_len}; i++ )); do
    local bit=""
    bit=${code:$i:1}
    if [[ "$bit" == "0" || "$bit" == "1" ]]; then
      ones_in_report[$i]=$(( ones_in_report[$i] + $bit ))
    else
      echo "Undefined binary value: $bit"
    fi
  done
}

function process_report () {
  IFS=$'\n' read -d '' -r -a report < "$binary"

  report_values=${#report[@]}
  code_sample=${report[0]}
  code_len=${#code_sample}

  define_row_counter_array $code_len

  echo "Number of report entries: $report_values"
  # echo $report

  for (( j=0; j<${report_values}; j++ )); do 
    process_binary_code ${report[$j]}
    # echo "gamma_count: $gamma_count, epsilon_count: $epsilon_count"
  done
}

function calculate_rate() {
  local half=$(( $report_values / 2 ))
  for (( i=0; i<$code_len; i++ )); do 
    if [[ "${ones_in_report[$i]}" > "$half" ]]; then
      # echo "value: ${ones_in_report[$i]}, half: $half"
      gamma_rate+="1"
      epsilon_rate+="0"
    elif [[ "${ones_in_report[$i]}" < "$half" ]]; then
      # echo "value: ${ones_in_report[$i]}, half: $half"
      gamma_rate+="0"
      epsilon_rate+="1"
    else 
      echo "Number of ones are equal to zeros in report. Nothing to do"
    fi
  done 
}

function multiply () {
  result=$(($gamma * $epsilon))
}

process_report
print_row_counter_array_values $code_len
calculate_rate 
gamma=$((2#$gamma_rate))
epsilon=$((2#$epsilon_rate))

echo "gamma_rate: $gamma_rate, epsilon_rate: $epsilon_rate"
multiply

echo "gamma = $gamma, epsilon = $epsilon"
echo "result (gamma * epsilon): $result"
