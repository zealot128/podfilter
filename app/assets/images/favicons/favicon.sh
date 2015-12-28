#!/bin/bash

arr=(57 72 76 114 120 144 152 70 150 310)
cur=$PWD
for i in "${arr[@]}"
do
  filename="icon${i}.png"
  command="convert favicon_logo_big.png -resize ${i}x${i}> -size ${i}x${i} xc:none +swap -gravity center -composite $filename"
  echo $command
  `${command}`
  pngquant -f $filename --output $filename
done

convert favicon_logo_big.png -resize "32x32>" -size 32x32 xc:none +swap -gravity center -composite icon.ico
