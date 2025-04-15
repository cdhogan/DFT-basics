#!/usr/bin/gnuplot
# x11 should work on any system
# try wxt (ubuntu) or aqua (mac) for nicer plots
set term x11 enhanced

set xtics 1 out nomirror
set grid x
set mxtics 2
set ytics 1 in nomirror
set mytics 4
set border 3
set yrange [-4:4]
#Tics style
#labels
#tic format
#variable pointsize
#index
FILENAME="gnuplot5.dat"
plot FILENAME index 0 using 1:2 with lp lc "black" pt 6 ps 2.0,\
	"" i 1 with filledcurves y=-1 fillstyle lc "red" fillcolor "forest-green",\
	"" i 0 u 1:($1 <= 1 ? $2 : 1/0) with filledcurve x1 fillstyle transparent solid 0.5 fillcolor "orange"


#"" i 1 u 1:2:($3) w lp pointsize variable pt 6

pause -1
set term pngcairo enhanced size 600,400
set output "gnuplot5.png"
replot

