#!/opt/homebrew/bin/gnuplot
####!/usr/bin/gnuplot
set term pngcairo enhanced size 800,400
set output "plot_pot.png"

set xlabel "z-coordinate (au)
set ylabel "Potential (Ry)"
set key above
set arrow 1 from 20,0 to 15,0.1
plot "avg_pot_Al001_O.dat" t "Average" w l lw 2 lc "black",\
	"" u 1:3 t "Macroscopic average" w l lw 1 dt 2 lc "red",\
	"" u ($1+43.112142302):2 t "" w l lw 2 lc "black",\
	"" u ($1+43.112142302):3 t "" w l lw 1 dt 2 lc "red"

set term x11
set out
replot
