



plot "pw2gw_k16/epsTOT.dat" u 1:($2/100) smooth kdensity bandwidth 0.1 w l lw 3,"" u ($1+0):2 w l,"" smooth sbezier w l lw 4
