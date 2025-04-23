# Band structure calculation
The procedure for computing the band structure in graphene is very similar to that you followed for bulk silicon.
The main difference is in the choice of k-point path. Here you want select a path that contains both Gamma and K points. Again, identify the coordinates using XCrysDen or the seek-path app, and prepare the path using `crystal_b` coordinates (see [K_POINTS](http://https://www.quantum-espresso.org/Doc/INPUT_PW.html)).

![Graphene BZ](Ref/graphene-BZ.png?raw=true "graphene BZ")

  1. Run the self-consistent (SCF) calculation using the provided input 'graphene.scf.in' to generate the ground state electronic charge density. 
      ```
      % tail -2 graphene.scf.in 
      K_POINTS {automatic}
      12 12 1 0 0 0

      % pw.x < graphene.scf.in > graphene.scf.out
      ```
      By inspecting the output file, we see we have 8 electrons and 4 filled bands, and the Fermi level is at -1.8243 eV.

  2.  Run the non-self-consistent (BANDS) calculation using the provided input 'graphene.bands.in'. Since we have 8 electrons and 4 filled bands, we increase the requested bands to 20. We specify 4 points in order to define 3 "symmetry lines" in k-space that contain 16 points per line. 
            
      ```
      % tail -8 graphene.bands.in
      K_POINTS {crystal_b}
      4
      0.0000000000     0.0000000000     0.0000000000 16  ! Gamma
      0.5000000000     0.0000000000     0.0000000000 16  ! M 
      0.3333333333     0.3333333333     0.0000000000 16  ! K
      0.0000000000     0.0000000000     0.0000000000 1   ! Gamma

      % pw.x < graphene.bands.in > graphene.bands.out
      ```
  3.  Finally we generate a plottable file with the `bands.x` post-processing tool using the provided input 'graphene.bandspp.in'
      ```
      % bands.x < graphene.bandspp.in > graphene.bandspp.out
      ```
      This run analyses the symmetries of the eigenfunctions and writes the eigenvalues into a file called 'graphene.bandspp.dat.gnu' (the filename is defined in 'graphene.bandspp.in'). Plot it, shifting the Fermi level to zero.
      ```
      gnuplot> EFermi=-1.8243
      gnuplot> plot "graphene.bandspp.dat" u 1:($2-EFermi) w l
      ```
      ![Graphene BZ](Ref/graphene-BZ.png?raw=true "graphene BZ")

  6.  The graphene band structure is of much interest due to the Dirac cones at the K points. Let's have a look at the wavefunctions at the top of the valence band at the Gamma and K points. You need to look at the full list of k-points to work out the correct k-point index for the K point.
      ```
      % cat graphene.pp-pi.in
      kpoint       = 33
      kband        = 4
      fileout = "psi2_k33_b4.xsf"
      % pp.x < graphene.pp-pi.in 
      % pp.x < graphene.pp-sigma.in 
      % xcrysden --xsf psi2_k33_b4.xsf
      % xcrysden --xsf psi2_k1_b4.xsf
      ```

  6. ADVANCED: If you have learned to use the `projwfc.x` code (see the 7_PROJWFC tutorials) you can also project the bands onto specific orbitals. The process is a little tricky, but worthwhile.

     First, make sure to run the SCF and BANDS calculations. Then run `projwfc.x` for the eigenvectors along the band structure path.
     Note that `lsym = .false.` inside `projwfc.in` (at difference to DOS).

     ```
     % projwfc.x < projwfc.in > projwfc.out
     ```
     This creates the `graphene.proj.projwfc_up` file.

     Now create a formatted file containing the eigenvalues. The required format is hidden inside the `plotproj.f90` source file (https://gitlab.com/QEF/q-e/-/blob/develop/PP/src/plotproj.f90). The following commands should work; otherwise prepare the file by hand.

     ```
     % echo "16 49" > eigenvalues.dat       
     % awk '/End of band structure calculation/{ f = 1; next } /Writing output data file/{ f = 0 } f' graphene.bands.out >> eigenvalues.dat
     ```
     The input file for `plotproj.x` has the following format. Here we choose to sum over all pz orbitals in the system. 
     You will need to play with the threshold parameter.
     ```
     % cat plotproj.in
     eigenvalues.dat                                 <- The file created above
     graphene.proj.projwfc_up                        <- The projections on the bands (not the DOS!)
     graphene.bandspp.proj.pz-only.dat               <- Output file name
     0.2                                             <- threshold
     2                                               <- number of ranges to sum over (=2)
     2 2                                             <- range 1: from atomic orbital 2 to 2 = pz, atom 1
     6 6                                             <- range 2: from atomic orbital 6 to 6 = pz, atom 2

     % plotproj.x < plotproj.in 
        Input file > Reading   16 bands at   49 k-points
        Input file > output file > 
     ```
     Finally, we can plot the E(k) datapoints that pass the threshold criterion, on top of the full band structure.

     ```
     gnuplot> plot "graphene.bandspp.dat.gnu" w l,"graphene.bandspp.proj.pz-only.dat" w p pt 7
     ```


  7. ADVANCED: You can also use the script 'run_bands' which will automate all the steps (the k-path need to be put manually when building the script) and also makes use of the `plotband.x` code. The gnuplot script 'bands.gnuplot' will create the image shown above from the 'bands.dat.gnu' file. 
      ```
      gnuplot> load "Scripts/bands.gnuplot"
      ```
## Bibliography
1.  Aroyo et al, Acta Cryst. (2014). A70, 126-137 [Link](https://doi.org/10.1107/S205327331303091X)
