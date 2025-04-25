#set title "graphene band structure"
set title ""
#    high-symmetry point:  0.0000 0.0000 0.0000   x coordinate   0.0000
#    high-symmetry point:  0.5000 0.2887 0.0000   x coordinate   0.5774
#    high-symmetry point:  0.3333 0.5774 0.0000   x coordinate   0.9107
#    high-symmetry point:  0.0000 0.0000 0.0000   x coordinate   1.5774
G1=0.0000
M=0.5774
K=0.9107
G2=1.5774
set xtics ("{/Symbol G}" G1,"M" M,"K" K,"{/Symbol G}" G2) nomirror
set xrange [*:*]
set yrange [-6:6]
set yrange [-10:10]
set ytics 2
set grid x
set grid y
set ylabel "Energy (eV)"
set nokey
EFermi=-1.8243
set term pngcairo
set out "graphene_bands.png"
set format y "%3.1f"
plot "graphene.bandspp.dat.gnu" u 1:($2-EFermi) with lines,\
	0 t "" w l lt 2
replot
