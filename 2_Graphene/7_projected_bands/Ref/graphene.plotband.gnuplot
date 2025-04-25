#!gnuplot
set terminal postscript portrait  enhanced color dashed lw 1 ",12"
set output "graphene.plotband.gnuplot_projected.ps"
set xrange [0.0:    1.5773]
unset xtics
#set yrange [  -21.408001:   17.358000]
set ytics   -21.408001,    0.000000,   17.358000 
set ylabel "E - E_{ref} (eV)"
set border lw 0.5
set style arrow 1 nohead front lw 0.5 lc rgb 'black'
set arrow from     0.0000,graph 0 to     0.0000,graph 1 as 1
set arrow from     0.5774,graph 0 to     0.5774,graph 1 as 1
set arrow from     0.9107,graph 0 to     0.9107,graph 1 as 1
set title 'graphene.plotband.gnuplot_projected' noenhanced
plot 'graphene.plotband.dat_pz_only' u 1:($2 -     0.000000):3 w l palette lw 1 notitle, \
   -0.000000 lt 2 lw 0.5 lc rgb 'grey50' notitle
