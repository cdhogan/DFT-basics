#plot Grafene_dos

set title 'Grafene DOS' font ',18'
set xlabel 'E [eV]' font ',14'
set ylabel 'DOS' font ',14'
set key font ',14'
set xtics font ',12'
set ytics font ',12'
plot '../bnd5/Grafene.dos.dat' u 1:2 t 'bnd5' w l dashtype 2 , '../bnd10/Grafene.dos.dat' u 1:2 w l lw 2 lc rgb 'red' t 'bnd10' , '../bnd15/Grafene.dos.dat' u 1:2 w l lw 2 lc rgb 'black' t 'bnd15' 

