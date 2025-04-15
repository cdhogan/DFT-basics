#set title "Si band structure from Sibands.dat.gnu"
set title ""
#high-symmetry point:  0.5000 0.5000 0.5000   x coordinate   0.0000
#high-symmetry point:  0.0000 0.0000 0.0000   x coordinate   0.8660
#high-symmetry point:  0.0000 1.0000 0.0000   x coordinate   1.8660
#high-symmetry point:  0.2500 1.0000 0.2500   x coordinate   2.2196
#high-symmetry point:  0.7500 0.7500 0.0000   x coordinate   2.2196
#high-symmetry point:  0.0000 0.0000 0.0000   x coordinate   3.2802
L=0.0000
G1=0.8660
X=1.8660
U=2.2196
G2=3.2802
set xtics ("L" L,"{/Symbol G}" G1,"X" X,"U,K" U,"{/Symbol G}" G2) nomirror
set xrange [*:*]
set yrange [-13:4]
set grid x
set grid y
set ylabel "Energy (eV)"
set nokey
EF = 6.377
VBM = 6.214
set term pngcairo
set out "Sibands_DOS.png"
set multiplot layout 1,2
set format y "%3.1f"
set rmargin at screen 0.6
plot "../../4_bandstructure/Ref/Sibands.dat.gnu" u 1:($2-VBM) with lines,\
	0 t "" w l lt 2
set ylabel ""
set format y ""
set xtics auto
set format x "%g"
set lmargin at screen 0.63
set rmargin at screen 0.95
unset grid 
set grid y
plot "DOS_converged.dat" u 2:($1-VBM) with filledcurves y1 lc "red" fc "red"
set nomulti
replot
