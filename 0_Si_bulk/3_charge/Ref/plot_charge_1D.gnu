#set title "Si band structure from Sibands.dat.gnu"
set title "Charge density along Si-Si bond axis"
#set xtics ("L" L,"{/Symbol G}" G1,"X" X,"U,K" U,"{/Symbol G}" G2) nomirror
set yrange [0:4.5]
set yrange [0:0.1]
set ylabel "Charge density"
set xlabel "Distance (a.u.)"
set nokey
#EF = 6.377
#VBM = 6.214
set term pngcairo
set out "charge_plot1D.png"
set format y "%4.2f"
#set rmargin at screen 0.6
alat=10.21
plot "charge_plot1D.dat" u ($1*alat):2 with lines
replot
