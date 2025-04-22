# Projected DOS
We can obtain more information about the density of states and band structure by projecting the states onto atomic orbitals. To do this we use a post-processing code called `projwfc.x`.

  1. The input for projwfc.x is similar to that for `dos.x`: full details can be found at 
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

 2.  The projwfc.x code generates quite a lot of information:
     - projwfc.out	Contains a user-readable list of the atomic basis and the projections of each eigenvector (n,k) onto the atomic orbitals; Lowdin charges and spilling parameter.
     - graphene.proj.projwfc_up  A formatted datafile containing the projections, to be read by plotproj.x
     - tmp/graphene.save/atomic_proj.xml An XML-formatted datafile containing the projections, to be read by molecularpdos.x. 
     - graphene.pdos_tot The total DOS (column 2) and total PDOS (column 3).
     - graphene.pdos_atm#1(C)_wfc#1(s) The PDOS for each atom and angular momentum. 

     Let's have a look first at projwfc.out

     ```
     Problem Sizes 
     natomwfc =            8
     nbnd     =           20
     nkstot   =          469
     npwx     =         2245
     nkb      =            2
     ```


     ```
     Atomic states used for projection
     (read from pseudopotential files):

     state #   1: atom   1 (C  ), wfc  1 (l=0 m= 1)
     state #   2: atom   1 (C  ), wfc  2 (l=1 m= 1)
     state #   3: atom   1 (C  ), wfc  2 (l=1 m= 2)
     state #   4: atom   1 (C  ), wfc  2 (l=1 m= 3)
     state #   5: atom   2 (C  ), wfc  1 (l=0 m= 1)
     state #   6: atom   2 (C  ), wfc  2 (l=1 m= 1)
     state #   7: atom   2 (C  ), wfc  2 (l=1 m= 2)
     state #   8: atom   2 (C  ), wfc  2 (l=1 m= 3)

     k =   0.0000000000  0.0000000000  0.0000000000
     ==== e(   1) =   -21.40692 eV ==== 
     psi = 0.492*[#   1]+0.492*[#   5]
     |psi|^2 = 0.984
     ```


     ```
     Spilling Parameter:   0.0108
     ```

 3.  Thats enough for now
     ![PDOS](Ref/PDOS.png?raw=true "PDOS")
     ![PDOS and bands](Ref/graphene_bands_DOS.png?raw=true "PDOS and bands")

  6. ADVANCED USERS: The shell scripts 'run_pdos' and 'run_plots' in the 'Script' directory will do everything automatically.
      ```
      ./Script/run_ecut
      ./Script/run_plots
      ```
      NB: Do not use the scripts for your own projects unless you understand well how they work!
      
### When you have completed this tutorial, you can move on to [1_ksmear: Convergence with k-points and smearing](../1_ksmear)
