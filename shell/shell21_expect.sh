#!/bin/bash 
#rm  ‐rf  ~/.ssh/known_hosts 
expect  <<EOF 
spawn  ssh   xiongjianan@10.150.68.134 -p 2222 
expect  "password"    {send  "aini120405\r"} 
EOF

