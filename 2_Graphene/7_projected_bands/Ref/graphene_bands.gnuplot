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
thres=0.5
set format y "%3.1f"
set term pngcairo
set out "graphene_plotproj_thres.png"
set title "Using plotproj.x, thres = 0.5"
plot "graphene.bandspp.dat.gnu" u 1:($2-EFermi) w l lt 0,\
	"graphene.plotproj.dat_pz_only.dat" u 1:($2-EFermi) w p pt 7 lc "black",0 t "" w l lt 2

set out "graphene_plotband_size.png"
set title "Using plotband.x, pointsize variable"
plot "graphene.bandspp.dat.gnu" u 1:($2-EFermi) w l lt 0,\
	"graphene.plotband.dat_pz_only" u 1:($2-EFermi):($3**0.5) with points pointsize variable pointtype 7,0 t "" w l lt 2

set out "graphene_plotband_thres.png"
set title "Using plotband.x, thres = 0.5"
plot "graphene.bandspp.dat.gnu" u 1:($2-EFermi) w l lt 0,\
	"graphene.plotband.dat_pz_only" u 1:($3 > thres ? $2-EFermi : 1/0) w linespoints pt 7 lc "red",0 t "" w l lt 2
replot
