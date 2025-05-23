#!/opt/homebrew/bin/gnuplot
####!/usr/bin/gnuplot
set term pngcairo enhanced size 800,400
set output "plot_charge.png"

set xlabel "z-coordinate (au)
set ylabel "Charge (au)"
set key above
#set arrow 1 from 20,0 to 15,0.1
#  A           = 2.8546 
#Al               0.0000000000        0.0000000000        0.0000000000    0   0   0
#Al               0.4999999986        0.4999999986        0.7071067670    0   0   0
#Al               0.0000000000        0.0000000000        1.4291457179
#Al               0.4971216339        1.4999999958        2.1725092986
#Al               1.4999999958        1.4999999958        2.0556244476
#O                1.4999999993        1.4999999993        2.6435558304    0   0   1
alat=2.8546/0.529177
set arrow 1 from 0.0,graph 0 to 0.0,graph 1 nohead dt 4 lc "black"
set arrow 2 from 0.70710*alat,graph 0 to 0.70710*alat,graph 1 nohead dt 4 lc "black"
set arrow 4 from 1.4291457179*alat,graph 0 to 1.4291457179*alat,graph 1 nohead dt 4 lc "black"
set arrow 5 from 2.1725092986*alat,graph 0 to 2.1725092986*alat,graph 1 nohead dt 4 lc "black"
set arrow 6 from 2.6435*alat,graph 0 to 2.6435*alat,graph 1 nohead dt 4 lc "red"
plot "avg_difference.dat" u 1:2 t "Al001/O" w l lc "black","" u 1:3 t "Al001" w l dt 2 lc "forest-green","" u 1:4 t "O" w l lw 2 lc "red",0 t "" w l lt 0,\
	"" u 1:($5*10-0.01) t "Difference (x10)" w l lc "blue",-0.01 t "" w l lt 0
set term x11
set out
replot
