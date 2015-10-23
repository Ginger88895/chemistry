#!/bin/bash
base="textures"
mkdir $base
while read element; do
  elementCode=`echo $element | grep -oP "(\s|^)[a-zA-Z]{1,3}"`
  elementNumb=`echo $element | grep -oP "[0-9]{1,3}"`
  #elementGrou=`echo $element | grep -oP "(?<=[0-9] ).+"`
  
  convert -font "Impact" base.png +antialias -gravity SouthEast -pointsize 16 -annotate +3+3 "$elementCode" +antialias -gravity NorthWest -pointsize 10 -annotate +0+0 "$elementNumb" "$base/$elementCode.png"
done < "elements.txt"
