#!/usr/bin/gnuplot

set xlabel "alat (A)"
set ylabel "E_{tot} (Ry)"

set term pngcairo enhanced
set output "2D_silicene.png"
set arrow 1 from 3.82,graph 0 to 3.82,graph 1 nohead dt 2 lc "red"
set mxtics 4
plot 	'Etot_vs_alat-script.dat_40Ry' u 1:2 w lp pt 7 lw 2  lc rgb "green" title "40Ry",\
	'Etot_vs_alat-script.dat_60Ry' u 1:2 w lp pt 7 lw 2  lc rgb "red" title "60Ry",\
	'Etot_vs_alat-script.dat_80Ry' u 1:2 w lp pt 7 lw 1 dt 2  lc rgb "blue" title "80Ry"

#set term x11 enhanced
#replot
#pause -1
