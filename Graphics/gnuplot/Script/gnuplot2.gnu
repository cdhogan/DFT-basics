#!/usr/bin/gnuplot

# x11 should work on any system
# try wxt (ubuntu) or aqua (mac) for nicer plots
set term x11 enhanced
set out


set title "Basic functions and styles"
set encoding utf8
set xlabel "X-axis label"
set ylabel "Y-axis label"
set y2label "Second Y-axis label "

set yrange [-5:10]
set ytics 4 nomirror
set y2range [-20:20]
set xrange [-10:5]
set mxtics 5

# User defined variables and functions
my_variable=-3
f(x)=x
set key top left
plot sin(x)+exp(x) title "sine+exp" with lines dashtype 2,\
	x**2 t "x^2" w lp lt 1 linewidth 2 linecolor "red",\
	f(x-2),\
	my_variable 

pause -1
#set term pdfcairo enhanced
#set output "gnuplot2.pdf"
#replot
set term pngcairo enhanced size 600,400
set output "gnuplot2.png"
replot

