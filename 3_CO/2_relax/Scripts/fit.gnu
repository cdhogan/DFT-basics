#!/usr/bin/gnuplot

SAVE="Etot_vs_bond-script.dat"

set term x11 enhanced
set out

set xlabel 'Bond length (A)'
set ylabel 'E_{tot} (Ry)'
set xrange [1.0:1.3]

# Fit with a parabola:
f(x) = a*x**2 + b*x + c
fit [1.05:1.25] f(x) SAVE u 1:2 via a, b, c
plot SAVE u 1:2 t "Calculated values" w lp pt 7 lc "black",f(x) t "Parabolic fit" lc "red"

# Extract the minimum bond length and energy
r0=-b/(2*a)
e0=c-b*b/(4*a)

print "r0(parabolic) = ", r0
print "e0(parabolic) = ", e0

set term pngcairo enhanced size 600,400
set out "Etot_vs_bond_fit.png"
plot SAVE u 1:2 t "Calculated values" w lp pt 7 lc "black",f(x) t "Parabolic fit" lc "red"
