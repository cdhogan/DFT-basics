#!/usr/bin/gnuplot

# x11 should work on any system
# try wxt (ubuntu) or aqua (mac) for nicer plots
set term x11 enhanced
set out

set title "Basic functions and styles"
set xlabel "X-axis label (Å,±,ρ)"
set ylabel "Y-axis label "
set y2label "Second Y-axis label "

set yrange [-5:10]
set ytics 4 nomirror
set y2range [-20:20]
set xrange [-10:5]
set mxtics 5

my_variable=-3
set key top left
plot sin(x)+exp(x) title "sine+exp" with lines dashtype 2 linecolor "black" ,x**2 t "x^2" w lp lt 1 lw 2 lc "red",my_variable 

pause -1
#set term pdfcairo enhanced
#set output "gnuplot1.pdf"
#replot
set term pngcairo enhanced size 600,400
set output "gnuplot1.png"
replot

