#!/bin/sh

dir_path="./*/"

for dir in $dir_path;

do
  (
    echo $dir
    cd $dir && git pull
	echo
  )
done

