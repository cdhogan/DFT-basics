#!/usr/bin/gnuplot

# x11 should work on any system
# try wxt (ubuntu) or aqua (mac) for nicer plots
set term x11 enhanced
set out
FILENAME="gnuplot3.dat"

set title "Plotting datafiles"
set xlabel "Default number style: 1 or 1.5"

#set yrange [-5:10]
#set ytics 4 nomirror
#set y2range [-20:20]
#set xrange [-10:5]
#set mxtics 5

#my_variable=-3
#set key top left
#set label 1 "hello" at 3,3
plot "gnuplot3.dat" with lines,\
	"gnuplot3.dat" using 3:1,\
	"" u 1:2:($3*3) with points pointsize variable pointtype 6,\
	FILENAME u 1:($2*2+0.2*$1) w lp pt 7 ps 2.0

pause -1
set term pngcairo enhanced size 600,400
set output "gnuplot3.png"
replot

