#! /bin/bash
printf "DIGITE: "
read -s pass; echo $pass | md5sum | awk '{print $1}' | xclip -selection clipboard
echo ""
