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
set yrange [-10:10]
set ytics 2
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
plot "../4_bands/Ref/graphene.bandspp.dat.gnu" u 1:($2-EFermi) with lines,\
	0 t "" w l lt 2
set ylabel ""
set format y ""
set xtics auto
set format x "%g"
set lmargin at screen 0.63
set rmargin at screen 0.95
unset grid 
set grid y
set xrange [0:1.2]
set xtics 0.5
set ytics out
plot	"graphene.pdos_tot" u 3:($1-EFermi) t "Total PDOS" w filledcurves y1 lc "grey90" fc "grey90",\
	"graphene.pdos_atm#1(C)_wfc#1(s)" u ($2*2):($1-EFermi) t "C 2s" w l lc "blue",\
	"graphene.pdos_atm#1(C)_wfc#2(p)" u ($3*2):($1-EFermi) t "C 2p_z" w l lw 2 lc "black",\
	"graphene.pdos_atm#1(C)_wfc#2(p)" u ($4*4):($1-EFermi) t "C 2p_x+2p_y" w l lw 2 lc "red"


set nomulti
replot
