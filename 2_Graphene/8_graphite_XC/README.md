## XC functional (UNDER CONSTRUCTION)

In this tutorial we will study the choice of exchange correlation (XC) functional on the lattice parameters of a layered material, graphite. 
Graphite is a good model system as it combines in-plane covalent bonding with interlayer weak bonding (van der Waals interaction).

### Nomenclature

Below we will make use of some internal conventions on XC names and on pseudopotential names. For reference:

1) Names for functionals available inside quantum-ESPRESSO are defined in the `Modules/funct.f90` Fortran file. This Fortran file is obviously present in the QE distribution or can be viewed online at e.g. https://gitlab.com/QEF/q-e/-/blob/develop/Modules/funct.f90. An edited snippet is presented at the bottom of this page; the functionals use in this tutorial are:
   ```
    "pz"            = "sla+pz"            = Perdew-Zunger   (LDA)
    "pw"            = "sla+pw"            = Perdew-Wang     (LDA)
    "pw91"          = "sla+pw+ggx+ggc"    = Perdew-Wang91   (GGA) 
    "pbe"           = "sla+pw+pbx+pbc"    = PBE             (GGA)
    "pbesol"        = "sla+pw+psx+psc"    = PBEsol          (GGA)
    "tpss"          = "sla+pw+tpss+tpss"  = TPSS Meta-GGA   (mGGA)
    "vdw-df-ob86"   = "sla+pw+ob86+vdw1"  = vdW-DF-ob86 (optB86b-vdW)   (vdW-DF)
    "vdw-df-obk8"   = "sla+pw+obk8+vdw1"  = vdW-DF-obk8 (optB88-vdW)    (vdW-DF)
    "vdw-df2"       = "sla+pw+rw86+vdw2"  = vdW-DF2                     (vdW-DF2)
    "vdw-df2-b86r"  = "sla+pw+b86r+vdw2"  = vdW-DF2-B86R (rev-vdw-df2)  (vdW-DF2)
    "vdw-df3-opt2"  = "sla+pw+w32x+w32c"  = vdW-DF3-opt2                (vdW-DF3)
    ```
For local/semilocal functionals this long string represents: 
"LDA exchange + LDA correlation + GGA exchange + GGA correlation"

In the output, a 7-integer string is reported corresponding to internal variables (see below):
"LDA exchange + LDA correlation + GGA exchange + GGA correlation + non-local-vdW + meta-GGA exchange + meta-GGA correlation", e.g.
   ```
   Exchange-correlation= VDW-DF3-OPT2
                    (   1   4  46   0   4   0   0)
   ```
This information can be used to double check that the correct XC functional is being used.


2) Acronyms used for the pseudopotentials 

| Acronym | Pseudo library/link |
| --- | --- |
| psl | pslibrary |
| dojo | pseudo-dojo library |
| oncv | |
| sssp | |
| sg15 | |


| Acronym | Meaning |
| --- | --- |
| vbc | von Barth/Car (LDA) |
| vwn | Vosko-Wi;l-Nusair (LDA) |
| nc | norm-conserving (NC) |
| uspp | ultrasoft pseudopotential | 
| rrkj | Rappe-Rabe-Kaxiras-Joannopoulos (NC) |
| rrkjus | Rappe-Rabe-Kaxiras-Joannopoulos (Ultrasoft) |
| paw | projector augmented wave (PAW) |
| kjpaw | Kresse-Joubert PAW | 


### Input files

A selection of pseudopotentials and input files are provided directly. 
Where possible, pseudopotential files for C have been taken from the pseudo-DOJO library and used at the recommended cutoff of 80 Ry for carbon. Since pseudo-DOJO files have the same name (C.upf) for different XC, we have renamed them in the following (it would be better in practice to change `pseudo_dir`). 
We perform a vc-relax calculation in each case, with otherwise the same computational parameters (12x12x6 unshifted k-point set, 0.02 Ry smearing). The initial lattice parameters are set to those of the experiment (A = 2.46 A, C=6.71 A). For the vc-relax calculation we allow A and C to vary but keep the geometry (axes, angles) consistent.
   ```
   % cat graphite.in_LDA_PZ
     calculation = 'vc-relax'
   [...]
     ecutwfc = 80
     ibrav = 4
     A = 2.46
     C = 6.71
   [...]
   &CELL
    press_conv_thr=0.001
    cell_dofree="ibrav"
   /
   ```
### Local XC functionals
For LDA, the XC functional is simply chosen via the pseudopotential. The relevant input files and pseudopotentials are
   ```
   % grep -e upf -e UPF *graphite.in_LDA*
   graphite.in_LDA_PW_DOJO    :  C      12.0107 C_DOJO_LDA.upf
   graphite.in_LDA_PZ         :  C      12.0107 C.pz-vbc.UPF
   ```
To understand which functional or parameterization is being used, we need to check the comments and user-readable data or header in the pseudopotential files. This can appear in different ways for different pseudo 'families'.
   ```
   % grep "functional" C.pz-vbc.UPF C_DOJO_LDA.upf
   C.pz-vbc.UPF: SLA  PZ   NOGX NOGC   PZ   Exchange-Correlation functional
   C_DOJO_LDA.upf:functional="SLA  PW   NOGX NOGC"
   ```
These are reflected also in the output:
   ```
   Exchange-correlation= SLA  PW   NOGX NOGC
                          (   1   4   0   0   0   0   0)
   [and]
   Exchange-correlation=  SLA  PZ   NOGX NOGC
                          (   1   1   0   0   0   0   0)
   ```
Thus, we have Slater exch + PZ correlation; and Slater exch + PW correlation; respectively, with no GGA or meta-GGA terms.
Referring to the full table in funct.f90 we can understand the two files use Perder-Zunger (PZ) and Perdew-Wang (PW) type LDA functionals (clearly, the two kinds differ only in the parameterization of the correlation). 

Run vc-relax calculations for each XC choice and tabulate the a and c lattice parameters.
   ```
   % pw.x < graphite.in_LDA_PW_DOJO > graphite.out_LDA_PW_DOJO
   % pw.x < graphite.in_LDA_PZ > graphite.out_LDA_PZ
   ```

### Semi-local functionals

graphite.in_PBE_DOJO
graphite.in_PBE_SSSP
graphite.in_PBEsol_DOJO	

### meta-GGA functionals

Unfortunately, meta-GGAs can be notoriously difficult to work with, and often give convergence problems. For this reason they are not widely used. Nonetheless for completeness we try one meta-GGA here, the TPSS for which pseudopotential for C is available.
Care with NLCC!

Note that newer mGGAs like R2SCAN are more reliable. To use them, quantum-ESPRESSO must be compiled with libXC support.

### Semi-empirical vdW 

graphite.in_PBE_D3BJ_DOJO
graphite.in_PBEsol_D3BJ_DOJO

### Ab-initio vdW

graphite.in_vdw-DF2
graphite.in_vdw-df2-b86r
graphite.out_optB88-vdW
graphite.in_optB88-vdW

### Hybrid functionals

More useful for band gaps, thus not relevant here.

### Results

![XC](Ref/XC_chart.png?raw=true "XC")
![XC](Ref/XC_table.png?raw=true "XC")

Some XC tests on common elemental crystals

![XC](Ref/tran.png?raw=true "XC")


  ```
   CHARACTER(LEN=37) :: dft = 'not set'
  ! "dft" is the exchange-correlation functional label, as set by the user...
  ! It can contain either the short names or a series of the keywords listed below.
  ! All operations on names are case-insensitive.
  !
  !           short name       complete name       Short description
  !              "pz"    = "sla+pz"            = Perdew-Zunger LDA
  !              "bp"    = "b88+p86"           = Becke-Perdew grad.corr.
  !              "pw91"  = "sla+pw+ggx+ggc"    = PW91 (aka GGA)
  !              "blyp"  = "sla+b88+lyp+blyp"  = BLYP
  !              "pbe"   = "sla+pw+pbx+pbc"    = PBE
  !              "revpbe"= "sla+pw+revx+pbc"   = revPBE (Zhang-Yang)
  !              "pbesol"= "sla+pw+psx+psc"    = PBEsol
  !              "sogga" = "sla+pw+sox+pbec"   = SOGGA
  !              "optbk88"="sla+pw+obk8+p86"   = optB88
  !              "optb86b"="sla+pw+ob86+p86"   = optB86
  !              "tpss"  = "sla+pw+tpss+tpss"  = TPSS Meta-GGA
  !              "m06l"  = "nox+noc+m6lx+m6lc" = M06L Meta-GGA
  !              "pbe0"  = "pb0x+pw+pb0x+pbc"  = PBE0
  !              "hse"   = "sla+pw+hse+pbc"    = Heyd-Scuseria-Ernzerhof (HSE 06, see note below)
  !              "b3lyp"                        = B3LYP
  !              "vdw-df"       ="sla+pw+revx+vdw1"      = vdW-DF1
  !              "vdw-df2"      ="sla+pw+rw86+vdw2"      = vdW-DF2
  !              "vdw-df-obk8"  ="sla+pw+obk8+vdw1"      = vdW-DF-obk8 (optB88-vdW)
  !              "vdw-df-ob86"  ="sla+pw+ob86+vdw1"      = vdW-DF-ob86 (optB86b-vdW)
  !              "vdw-df2-b86r" ="sla+pw+b86r+vdw2"      = vdW-DF2-B86R (rev-vdw-df2)
  !              "vdw-df3-opt1" ="sla+pw+w31x+w31c"      = vdW-DF3-opt1
  !              "vdw-df3-opt2" ="sla+pw+w32x+w32c"      = vdW-DF3-opt2
  !              "rvv10" = "sla+pw+rw86+pbc+vv10"        = rVV10
  !
  ! Any nonconflicting combination of the following keywords is acceptable:
  !
  ! Exchange:    "nox"    none                           iexch=0
  !              "sla"    Slater (alpha=2/3)             iexch=1 (default)
  !              "pb0x"   (Slater*0.75+HF*0.25)          iexch=6 for PBE0 and vdW-DF-cx0 and vdW-DF2-0 etc
  !              "b3lp"   B3LYP(Slater*0.80+HF*0.20)     iexch=7
  !
  ! Correlation: "noc"    none                           icorr=0
  !              "pz"     Perdew-Zunger                  icorr=1 (default)
  !              "vwn"    Vosko-Wilk-Nusair              icorr=2
  !              "lyp"    Lee-Yang-Parr                  icorr=3
  !              "pw"     Perdew-Wang                    icorr=4
  !              "b3lp"   B3LYP (0.19*vwn+0.81*lyp)      icorr=12
  
  ! Gradient Correction on Exchange:
  !              "nogx"   none                           igcx =0 (default)
  !              "b88"    Becke88 (beta=0.0042)          igcx =1
  !              "ggx"    Perdew-Wang 91                 igcx =2
  !              "pbx"    Perdew-Burke-Ernzenhof exch    igcx =3
  !              "revx"   revised PBE by Zhang-Yang      igcx =4
  !              "pb0x"   PBE0 (PBE exchange*0.75)       igcx =8
  !              "b3lp"   B3LYP (Becke88*0.72)           igcx =9
  !              "psx"    PBEsol exchange                igcx =10
  !              "hse"    HSE screened exchange          igcx =12
  !              "rw86"   revised PW86                   igcx =13
  !              "pbe"    same as PBX, back-comp.        igcx =14
  !              "pw86"   Perdew-Wang (1986) exchange    igcx =21
  !              "b86b"   Becke (1986) exchange          igcx =22
  !              "obk8"   optB88  exchange               igcx =23
  !              "ob86"   optB86b exchange               igcx =24
  !              "b86r"   revised Becke (b86b)           igcx =26
  !              "b86x"   B86b exchange * 0.75           igcx =41
  !              "b88x"   B88 exchange * 0.50            igcx =42
  !              "w31x"   vdW-DF3-opt1 exchange          igcx =45
  !              "w32x"   vdW-DF3-opt2 exchange          igcx =46
  !              "ahbr"   vdW-DF2-ahbr exchange          igcx =47 ! for vdW-DF2-ahbr 
  !
  ! Gradient Correction on Correlation:
  !              "nogc"   none                           igcc =0 (default)
  !              "p86"    Perdew86                       igcc =1
  !              "ggc"    Perdew-Wang 91 corr.           igcc =2
  !              "blyp"   Lee-Yang-Parr                  igcc =3
  !              "pbc"    Perdew-Burke-Ernzenhof corr    igcc =4
  !              "b3lp"   B3LYP (Lee-Yang-Parr*0.81)     igcc =7
  !              "psc"    PBEsol corr                    igcc =8
  !              "pbe"    same as PBX, back-comp.        igcc =9
  !
  ! Meta-GGA functionals
  !              "tpss"   TPSS Meta-GGA                  imeta=1
  !              "m6lx"   M06L Meta-GGA                  imeta=2
  !              "tb09"   TB09 Meta-GGA                  imeta=3
  !              "+meta"  activate MGGA even without MGGA-XC   imeta=4
  !              "scan"   SCAN Meta-GGA                  imeta=5
  !              "sca0"   SCAN0  Meta-GGA                imeta=6
  !              "r2scan" R2SCAN Meta-GGA                imeta=7
  !
  ! van der Waals functionals (nonlocal term only)
  !              "nonlc"  none                           inlc =0 (default)
  !--------------inlc = 1 to inlc = 25 reserved for vdW-DF--------------
  !              "vdw1"   vdW-DF1                        inlc =1
  !              "vdw2"   vdW-DF2                        inlc =2
  !              "w31c"   vdW-DF3-opt1                   inlc =3
  !              "w32c"   vdW-DF3-opt2                   inlc =4
  !              "wc6"    vdW-DF-C6                      inlc =5
  !---------------------------------------------------------------------
  !              "vv10"   rVV10                          inlc =26
  !
  ! Meta-GGA with van der Waals
  !              "rvv10-scan" rVV10 (with b=15.7) and scan inlc=26 (PRX 6, 041005 (2016))
  !
  ! Note: as a rule, all keywords should be unique, and should be different
  ! from the short name, but there are a few exceptions.
  !
  ! References:
  !              pz      J.P.Perdew and A.Zunger, PRB 23, 5048 (1981)
  !              pw      J.P.Perdew and Y.Wang, PRB 45, 13244 (1992)
  !              pw91    J.P.Perdew and Y. Wang, PRB 46, 6671 (1992)
  !              b88     A.D.Becke, PRA 38, 3098 (1988)
  !              p86     J.P.Perdew, PRB 33, 8822 (1986)
  !              pw86    J.P.Perdew, PRB 33, 8800 (1986)
  !              b86b    A.D.Becke, J.Chem.Phys. 85, 7184 (1986)
  !              ob86    Klimes, Bowler, Michaelides, PRB 83, 195131 (2011)
  !              b86r    I. Hamada, Phys. Rev. B 89, 121103(R) (2014)
  !              w31x    D. Chakraborty, K. Berland, and T. Thonhauser, JCTC 16, 5893 (2020)
  !              w32x    D. Chakraborty, K. Berland, and T. Thonhauser, JCTC 16, 5893 (2020)
  !              pbe     J.P.Perdew, K.Burke, M.Ernzerhof, PRL 77, 3865 (1996)
  
  !              blyp    C.Lee, W.Yang, R.G.Parr, PRB 37, 785 (1988)
  !              revPBE  Zhang and Yang, PRL 80, 890 (1998)
  !              pbesol  J.P. Perdew et al., PRL 100, 136406 (2008)
  !              pbe0    J.P.Perdew, M. Ernzerhof, K.Burke, JCP 105, 9982 (1996)
  !              hse     Heyd, Scuseria, Ernzerhof, J. Chem. Phys. 118, 8207 (2003)
  !                      Heyd, Scuseria, Ernzerhof, J. Chem. Phys. 124, 219906 (2006).
  !              b3lyp   P.J. Stephens,F.J. Devlin,C.F. Chabalowski,M.J. Frisch
  !                      J.Phys.Chem 98, 11623 (1994)
  !              vdW-DF       M. Dion et al., PRL 92, 246401 (2004)
  !                           T. Thonhauser et al., PRL 115, 136402 (2015)
  !              vdW-DF2      Lee et al., Phys. Rev. B 82, 081101 (2010)
  !              rev-vdW-DF2  I. Hamada, Phys. Rev. B 89, 121103(R) (2014)
  !              vdW-DF-obk8  Klimes et al, J. Phys. Cond. Matter, 22, 022201 (2010)
  !              vdW-DF-ob86  Klimes et al, Phys. Rev. B, 83, 195131 (2011)
  !              vdW-DF3-opt1 D. Chakraborty, K. Berland, and T. Thonhauser, JCTC 16, 5893 (2020)
  !              vdW-DF3-opt2 D. Chakraborty, K. Berland, and T. Thonhauser, JCTC 16, 5893 (2020)
  !              c09x    V. R. Cooper, Phys. Rev. B 81, 161104(R) (2010)
  !              tpss    J.Tao, J.P.Perdew, V.N.Staroverov, G.E. Scuseria,
  !                      PRL 91, 146401 (2003)
  !              scan    J Sun, A Ruzsinszky and J Perdew, PRL 115, 36402 (2015)
  !              scan0   K Hui and J-D. Chai, JCP 144, 44114 (2016)
  !              r2scan  J. W. Furness, A. D. Kaplan, J. Ning, J. P. Perdew,
  !                      and J. Sun, JPCL 11, 8208 (2020)
  !              sogga   Y. Zhao and D. G. Truhlar, JCP 128, 184109 (2008)
  !              m06l    Y. Zhao and D. G. Truhlar, JCP 125, 194101 (2006)
  !              rVV10   R. Sabatini et al. Phys. Rev. B 87, 041108(R) (2013)
  ```


Ref:  10.1103/PhysRevB.79.085104 Calculation of the lattice constant of solids with semilocal functionals  Philipp Haas, Fabien Tran, and Peter Blaha
