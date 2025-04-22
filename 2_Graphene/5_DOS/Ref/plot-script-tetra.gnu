#!/opt/local/bin/gnuplot

set term x11 enhanced

set title "DOS using tetrahedron method"
set xlabel "Energy (eV)"
set ylabel "DOS (states/eV)"
set key top left
EFermi=-1.834
set yrange [0:1.5]
set xrange [-10:5]
set arrow 1 from EFermi,graph 0 to EFermi, graph 1 nohead

plot 	'graphene_script.dos-tetra-kgrid12.dat' u 1:2 title "12x12x1" w l lt 0 lc rgb "black",	'graphene_script.dos-tetra-kgrid24.dat' u 1:2 title "24x24xx1" w l lt 1 lc rgb "forest-green",	'graphene_script.dos-tetra-kgrid48.dat' u 1:2 title "48x48x1" w l lt 1 lc rgb "red",	'graphene_script.dos-tetra-kgrid72.dat' u 1:2 title "72x72x1" w l lt 1  lw 2 lc rgb "black"

pause -1
set term pdfcairo enhanced
set output "DOS-tetra-script.pdf"
replot
set term pngcairo enhanced size 800,400
set output "DOS-tetra-script.png"
replot
