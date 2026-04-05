#!/usr/bin/gnuplot

set xlabel "a (A)"
set ylabel "E_{tot} (Ry)"

set term pngcairo enhanced
set output "3D_graphite-c.png"
set arrow 1 from 2.47,graph 0 to 2.47,graph 1 nohead dt 2 lc "red"
set mxtics 5
plot 	\
	'Etot_vs_a.vc-relax-c_script.dat_60Ry' u 1:3 w lp pt 7 lw 2  lc rgb "red" title "60Ry",\
	'Etot_vs_a.vc-relax-c_script.dat_80Ry' u 1:3 w lp pt 7 lw 2  lc rgb "green" title "80Ry",\
	'Etot_vs_a.vc-relax-c_script.dat_100Ry' u 1:3 w lp pt 7 lw 1  lc rgb "orange" title "100Ry",\
	'Etot_vs_a.vc-relax-c_script.dat_120Ry' u 1:3 w lp pt 7 lw 1 lc rgb "black" title "120Ry"

#set term pngcairo enhanced
#set output "2D_graphene.png"
#replot

#set term x11 enhanced
#replot
#pause -1
