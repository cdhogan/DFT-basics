#!/usr/bin/gnuplot
# try wxt (ubuntu) or aqua (mac) for nicer plots
set term x11 enhanced
set out
test
pause -1
set term pngcairo enhanced size 600,400
set output "gnuplot6.png"
test
set term jpeg enhanced size 600,400
set output "gnuplot6.jpg"
test
set term gif enhanced size 600,400
set output "gnuplot6.gif"
test
set term png enhanced size 600,400
set output "gnuplot6normal.png"
test
