#
set term png enh size 700,500
set out 'graphene.kpdos.png'
set xtics ("{/Symbol G}"0,"M"0.57735,"K"0.91068,"{/Symbol G}"1.57735)
set grid xtics
set xra [0:1.57735]
set yra [-12:5]
set ylabel "E - E_F (eV)"
set xzeroaxis
set key opaque box width 1.0
set style fill solid noborder
#radius(proj)=sqrt(proj)/40.
radius(proj)=proj/30.
p 'graphene.kpdos_pz_only'  u 2:3:(radius(\$5+\$7+\$8)) w circles lc rgb "green" t "{/Symbol s}",\
	'graphene.kpdos_pz_only' u 2:3:(radius(\$6)) w circles lc rgb "orange" t "{/Symbol p}"


