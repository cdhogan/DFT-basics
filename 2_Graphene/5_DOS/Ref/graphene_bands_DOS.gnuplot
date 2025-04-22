#set title "graphene band structure"
set title ""
#    high-symmetry point:  0.0000 0.0000 0.0000   x coordinate   0.0000
#    high-symmetry point:  0.5000 0.2887 0.0000   x coordinate   0.5774
#    high-symmetry point:  0.3333 0.5774 0.0000   x coordinate   0.9107
#    high-symmetry point:  0.0000 0.0000 0.0000   x coordinate   1.5774
G1=0.0000
X=0.5774
K=0.9107
G2=1.5774
set xtics ("{/Symbol G}" G1,"X" X,"K" K,"{/Symbol G}" G2) nomirror
set xrange [*:*]
set yrange [-6:6]
set ytics 1
set grid x
set grid y
set ylabel "Energy (eV)"
set nokey
EFermi=-1.8243
set term pngcairo
set out "graphene_bands_DOS.png"
set multiplot layout 1,2
set format y "%3.1f"
set rmargin at screen 0.6
plot "../../4_bands/Ref/graphene.bandspp.dat.gnu" u 1:($2-EFermi) with lines,\
	0 t "" w l lt 2
set ylabel ""
set format y ""
set xtics auto
set format x "%g"
set lmargin at screen 0.63
set rmargin at screen 0.95
unset grid 
set grid y
set xrange [0:1.5]
set xtics 0.5
set ytics out
plot "graphene_DOS_converged.dat" u 2:($1-EFermi) with filledcurves y1 lc "red" fc "red"
set nomulti
replot
