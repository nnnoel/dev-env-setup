#!/bin/bash
# author: Noel Colon
# description: Tests for scripts
# updated: May 23st, 2017

source `dirname $0`/utils.sh "test"
source `dirname $0`/setup.sh "test"

tests=0
passed=0
failed=0

test(){
  ((tests++))
  $1 >/dev/null 2>&1
  assert_true $1
}

assert_true(){
  if [ $? -eq 0 ]; then
    printf "${green}✔ %s function passed${normal}\n" "$1"
    ((passed++))
    return 0
  else
    printf "${red}✖ %s function failed${normal}\n" "$1"
    ((failed++))
    return 1
  fi
}

test message_s "Test"
test message_w "Test"
test message_e "Test"
test message_f "Test"
test create_dev_directory

printf "Tests ran: $tests\n"
printf "Passed: $passed\n"
printf "Failed: $failed\n"