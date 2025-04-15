#!/usr/bin/gnuplot

# x11 should work on any system
# try wxt (ubuntu) or aqua (mac) for nicer plots
set term x11 enhanced
set out

set xlabel "X-axis label (Å,±,ρ)"
set ylabel "Y-axis label "
set y2label "Second Y-axis label "

my_variable=0.5
plot sin(x) title "sine" with lines linetype 1 linecolor "black" ,x**2 t "x^2" w lp dt 2 lw 2 lc "red",my_variable 

pause -1
#set term pdfcairo enhanced
#set output "Etot_vs_Ecut-script.dat.pdf"
#replot
set term pngcairo enhanced size 600,400
set output "Etot_vs_Ecut-script.dat.png"
replot

