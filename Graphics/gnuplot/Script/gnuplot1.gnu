#!/usr/bin/gnuplot

# x11 should work on any system
# try wxt (ubuntu) or aqua (mac) for nicer plots
set term x11 enhanced
set title "My first plot"
plot x**3,x**2

# Save the plot as a png for uploading to wiki
pause -1
set term pngcairo enhanced size 600,400
set output "gnuplot1.png"
replot
