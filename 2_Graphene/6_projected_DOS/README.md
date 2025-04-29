# Projected DOS
We can obtain more information about the density of states and band structure by projecting the states onto atomic orbitals. To do this we use a post-processing code called `projwfc.x`.

  1. The input for `projwfc.x` is similar to that for `dos.x`: full details can be found at [INPUT_PROJWFC](https://www.quantum-espresso.org/Doc/INPUT_PROJWFC.html)    
     ```
     % cat projwfc.in
     &PROJWFC
     prefix       = "graphene",
     outdir       = "./tmp",
     degauss = .0146997			<- 0.2eV
     lsym=.true.
     filproj='graphene.proj'
     /
     ```
     We can use gaussian or tetrahedron method as for the DOS. For the latter, the tetrahedron method must be used in the NSCF calculation. Here we will use a gaussian smearing.
     
     As before, we must run three calculations: SCF, NSCF, and PROJWFC.
     ```
     pw.x < graphene.scf.in > graphene.scf.out
     pw.x < graphene.nscf.in > graphene.nscf.out
     projwfc.x < projwfc.in > projwfc.out
     ```

 2.  The `projwfc.x` code generates quite a lot of information:
     - `projwfc.out`	Contains a user-readable list of the atomic basis and the projections of each eigenvector (n,k) onto the atomic orbitals; Lowdin charges and spilling parameter.
     - `graphene.pdos_tot` Plottable file containing the total DOS (column 2) and total PDOS (column 3).
     - `graphene.pdos_atm#1(C)_wfc#1(s)` Plottable file containing the PDOS for each atom (1-4) and angular momentum (s,p), can be summed using `sumpdos.x` (but see below) 
     - `graphene.proj.projwfc_up`  A formatted datafile containing the projections, to be read by `plotproj.x`
     - `tmp/graphene.save/atomic_proj.xml` An XML-formatted datafile containing the projections, to be read by `molecularpdos.x`. 

     Let's have a look first at `projwfc.out`

     ```
     Problem Sizes 
     natomwfc =            8
     nbnd     =           20
     nkstot   =          469
     npwx     =         2245
     nkb      =            2
     ```
     The KS states will thus be projected onto 8 atomic orbitals. The order they appear in is defined at [INPUT_PROJWFC](https://www.quantum-espresso.org/Doc/INPUT_PROJWFC.html):
     ```
     Order of m-components for each l in the output:
     for l=1:
     1 pz     (m=0)
     2 px     (real combination of m=+/-1 with cosine)
     3 py     (real combination of m=+/-1 with sine)
     ```
     Thus in our output

     ```
     Atomic states used for projection
     (read from pseudopotential files):

     state #   1: atom   1 (C  ), wfc  1 (l=0 m= 1)     <- 2s
     state #   2: atom   1 (C  ), wfc  2 (l=1 m= 1)     <- 2pz
     state #   3: atom   1 (C  ), wfc  2 (l=1 m= 2)     <- 2px
     state #   4: atom   1 (C  ), wfc  2 (l=1 m= 3)     <- 2py
     state #   5: atom   2 (C  ), wfc  1 (l=0 m= 1)     <- 2s
     state #   6: atom   2 (C  ), wfc  2 (l=1 m= 1)     [etc]
     state #   7: atom   2 (C  ), wfc  2 (l=1 m= 2)
     state #   8: atom   2 (C  ), wfc  2 (l=1 m= 3)

     k =   0.0000000000  0.0000000000  0.0000000000
     ==== e(   1) =   -21.40692 eV ==== 
     psi = 0.492*[#   1]+0.492*[#   5]
     |psi|^2 = 0.984
     ```
     The first eigenvalue appears at the gamma point, at -21.4eV, and is composed of 49% of 2s (atom 1) + 49% of 2s (atom 2).

     ```
     Spilling Parameter:   0.0108
     ```
     The spilling parameter quantifies how successful the atomic projection onto the full DOS is - the lower the better. 

 4.  Let's now plot the total DOS and the total projected DOS.   
  
     ![PDOS](Ref/PDOS.png?raw=true "PDOS")

     It looks fine until a few eV above the conduction band edge. Why is this?

 5.  When analysing PDOS, one typically wants to group together orbitals from certain atoms or of a certain type. Here we would like to sum our 8 partial PDOS into three components: 2s, 2pz (out of plane), and 2px+2py (in-plane). We can use a combination of `paste` and `awk` to achieve this:
     ```
     % paste 'graphene.pdos_atm#1(C)_wfc#2(p)' 'graphene.pdos_atm#2(C)_wfc#2(p)' | awk 'NR>1 {print $1,$3 + $8 }' > sum_pz
     % paste 'graphene.pdos_atm#1(C)_wfc#1(s)' 'graphene.pdos_atm#2(C)_wfc#1(s)' | awk 'NR>1 {print $1,$3 + $8 }' > sum_s 
     % paste 'graphene.pdos_atm#1(C)_wfc#2(p)' 'graphene.pdos_atm#2(C)_wfc#2(p)' | awk 'NR>1 {print $1,$4+$5+$9+$10}' > sum_pxy
     ```
     Explanation: paste attaches files together side-by-side; put filenames in single quotes to avoid problems with special characters/escapes; NR>1 skips the first line (header); columns 3 and 8 correspond to the pz data from the first and second files in the pasted file.

     Note: typically one can use the `sumpdos.x` command, e.g.
     ```
     % sumpdos.x -h
     % ls -1 *pdos_atm* | grep "(p)" > list_of_p
     % sumpdos.x -f list_of_p
     ```
     but it does not allow you to separate pz from px/py, hence the use of paste+awk.
     
     The projected DOS is shown in the figure above (labeled) and below alongside the band structure.

     ![PDOS and bands](Ref/graphene_bands_DOS.png?raw=true "PDOS and bands")

     You should now be able to relate the Van Hove singularities in the DOS to the critical points of the Brillouin zone.  

  6. ADVANCED USERS: The shell scripts 'run_pdos' and 'run_plots' in the 'Script' directory will do everything automatically.
      ```
      ./Script/run_pdos
      ./Script/run_plots
      ```
      NB: Do not use the scripts for your own projects unless you understand well how they work!

  7.  ADVANCED USERS: An alternative to `sumpdos.x` which may be obsolete is `sum_states.py`. Use at your own risk. The instructions are something like:
      ```
      sum_states.py -o ni.dos.out -s ni.pdos_atm#1\(Ni\)_wfc#2\(d\) -t "Example PP/02" -xr -6 2

      -o QE output file name (for grepping Fermi E)
      -s Selection of atoms for summing the DOSes. "*" for all, *1*Fe*d* for first Fe atom " (def. "*")
      -p Print output to a file and aditionaly provide an output name (def. no output and "sum_dos.out")
      -t set title in the head of the graph
      -xr set min and max x value for the axes in the graph
      -yr set min and max y value for the axes in the graph
      -h print this help
      -v print version
      Example: sum_states.py --s sys.pdos_atm#4\(Fe2\)_wfc#2\(d\) -t "Wustite LDA+U single Fe" -xr -9 4 
      '''

      
### When you have completed this tutorial, you can move on to another system [3_CO: Carbon monoxide molecule](../../3_CO)
