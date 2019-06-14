#!/bin/bash


die(){
  echo $1
  echo $0
  local error=${1:-Undefined error}
  echo "$0: $LINE $error" 
}
die "File not found"
die
