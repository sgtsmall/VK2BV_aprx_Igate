#!/bin/sh
for f in `ls -1 origfiles`
do
 RFILE=`echo $f| tr '_' '/' `
 echo $RFILE
 diff $RFILE origfiles/$f
done
