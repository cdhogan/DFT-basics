#!/usr/bin/gnuplot
# x11 should work on any system
# try wxt (ubuntu) or aqua (mac) for nicer plots
set term x11 enhanced
set xlabel "Label with Times,16pt font" font "Times,20"
set ylabel "Label with Helvetica,12pt font" font "Helvetica,12"
set label 1 "Rotated\n text" at 3,2 rotate by 30
set label 2 "UTF8 special chars (Å,±,ρ)" at 1,-5
set label 3 "Hide me!"
unset label 3
set arrow 1 from -2.5,-2.5 to screen 0.25,0.75 lc "red" lw 2
min=-10
max=10
set yrange [min:max]
set xtics 2.5
set arrow 10 from 0,min to 0,max nohead
set label 4 "Vertical line" at -0.5,(max+min)/2 rotate by 90 
set format x "%4.1f"
set format y "%g"
set key above Right 
set key box samplen 10 
plot x t "f(x)=x" dt 5 lw 2

pause -1
set term pngcairo enhanced size 600,400
set output "gnuplot4.png"
replot

