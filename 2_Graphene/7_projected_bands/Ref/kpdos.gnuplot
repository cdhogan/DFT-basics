#
set term pngcairo size 1000,500
set pm3d
set view 0,0
#
f(z)=z**(0.7)  # tune image contrast
ef=-1.8243
#
unset xtics
set xtics out nomirror ("G" 1,"M" 17,"K" 33, "G" 49)
set xrange [1:49]
set label 1 "E-E_F(eV)" at 60,-2 rotate by 90
set ytics out nomirror
set yrange [-10:10]
unset ztics
unset key
unset colorbox
#
set out 'graphene.kpdos.png'
set origin 0,0
set size 1,1
set multiplot
dx=.1 ; dy=.30   # reduce margins
set title offset 0,-8
set size 1./3+1.4*dx,1.+2*dy
set origin 0./3-dx,0-dy
set title "Total PDOS"
splot 'graphene.kpdos.pdos_tot' u 1:($2-ef):(f($3)) w pm3d
set origin 1./3-dx,0-dy
set title "p_z-only"
splot 'graphene.kpdos.pdos_atm#1(C)_wfc#2(p)' u 1:($2-ef):(f($4*2)) w pm3d
set origin 2./3-dx,0-dy
set title "p_y-only"
splot 'graphene.kpdos.pdos_atm#1(C)_wfc#2(p)' u 1:($2-ef):(f($5*4)) w pm3d
unset multiplot
