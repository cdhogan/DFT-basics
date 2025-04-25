# Projected band structure calculation
One way to analyse the band structure is to project it onto specific atoms or atomic orbitals. In quantum-ESPRESSO there are a number of ways to do this, although they are all a little tricky to get working.


## Setup

  1. First, let's set up the calculation by computing the band structure again in the usual way: SCF + BANDS + BANDSPP.
      ```
      % pw.x < graphene.scf.in > graphene.scf.out
      % pw.x < graphene.bands.in > graphene.bands.out
      % cat graphene.bandspp.in    
      &bands
         prefix = "graphene",
         outdir='./tmp'
         filband='graphene.bandspp.dat'                <- FILBAND DEFINED HERE
         lsym=.true.
      /
      % bands.x < graphene.bandspp.in > graphene.bandspp.out
      ```
      Check everything worked by plotting 'graphene.bandspp.dat.gnu' as before.
      ```
      gnuplot> EFermi=-1.8243
      gnuplot> plot "graphene.bandspp.dat.gnu" u 1:($2-EFermi) w l
      ```

      Before continuing, you should learn to use `projwfc.x` code (see the 7_projected_DOS tutorial).

## Using plotproj.x     
  2. Here we run `projwfc.x` for the eigenvectors along the band structure path.
     Note that `lsym = .false.` inside `projwfc.in` (at difference to DOS).

     ```
     % projwfc.x < projwfc.in > projwfc.out
     ```
     This creates the `graphene.proj.projwfc_up` file.

     Now create a formatted file containing the eigenvalues. The required format is hidden inside the `plotproj.f90` source file (https://gitlab.com/QEF/q-e/-/blob/develop/PP/src/plotproj.f90). The following commands should work; otherwise prepare the file by hand.

     ```
     % echo "16 49" > eigenvalues.dat       
     % awk '/End of band structure calculation/{ f = 1; next } /Writing output data file/{ f = 0 } f' graphene.bands.out >> eigenvalues.dat
     % cat eigenvalues.dat
     16 49

               k = 0.0000 0.0000 0.0000 (  2239 PWs)   bands (ev):

        -21.4078  -9.7076  -4.8997  -4.8997   1.4307   2.5113   2.9174   4.8931
          5.7086   6.6108   6.6108   8.9740  10.1312  10.1825  10.9062  14.5371

               k = 0.0312 0.0180 0.0000 (  2243 PWs)   bands (ev):
     [...]
     ```
     The input file for `plotproj.x` has the following format. Here we choose to sum over all pz orbitals in the system. 
     You will need to play with the threshold parameter: if too low, it will plot everything; if too high it will miss the pz bands.
     ```
     % cat graphene.plotproj.in
     eigenvalues.dat                                 <- The file created above
     graphene.proj.projwfc_up                        <- The projections on the bands (not the DOS!)
     graphene.plotproj.dat_pz_only.dat               <- Output file name
     0.5                                             <- threshold
     2                                               <- number of ranges to sum over (=2)
     2 2                                             <- range 1: from atomic orbital 2 to 2 = pz, atom 1
     6 6                                             <- range 2: from atomic orbital 6 to 6 = pz, atom 2

     % plotproj.x < graphene.plotproj.in 
        Input file > Reading   16 bands at   49 k-points
        Input file > output file > 
     ```
     Finally, we can plot the E(k) datapoints that pass the threshold criterion, on top of the full band structure.

     ```
     gnuplot> plot "graphene.bandspp.dat.gnu" w l,"graphene.plotproj.dat_pz_only.dat" w p pt 7
     ```
     ![Graphene proj band](Ref/graphene_plotproj_thres.png?raw=true "graphene proj band")
     
 ## Using plotband.x

2.   Here we run `projwfc.x` for the eigenvectors along the band structure path.
     Note that `lsym = .false.` inside `projwfc.in` (at difference to DOS).
     ```
     % projwfc.x < projwfc.in > projwfc.out
     ```
     This creates the `graphene.proj.projwfc_up` file. 

     Now either copy, or make a symbolic link, to a new file 'FILBAND.proj', where FILBAND was defined inside 'graphene.bandspp.in'. 
     FILBAND is used as a basename for other files (FILBAND.rap, FILBAND.gnu, FILBAND.proj, etc). 
     Let's also rename the FILBAND.rap symmetry file to skip the symmetry analysis (it generates a lot of files).
     ```
     % ln -s graphene.proj.projwfc_up graphene.bandspp.dat.proj
     % mv graphene.bandspp.dat.rap graphene.bandspp.dat.rap_tmp
     ```

3.   Now we run `plotband.x`. This is an interactive program but you can also redirect a file to it:
     ```
     % cat graphene.plotband.in 
     graphene.bandspp.dat                 <- FILBAND
     2 6                                  <- List of orbitals we want to project onto (here: just the two pz orbitals)
     -21.4080   17.3580                   <- Range of energy to scan over (proposed if you first run interactively)
     graphene.plotband.dat_pz_only        <- Plottable file with projections
                                          <- Leave blank unless you want a postscript file
     graphene.plotband.gnuplot            <- A gnuplot script (that won't work)
     ```
     Run the code using this input (but you should also try running the code interactively)
     ```
     % plotband.x < graphene.plotband.in

     Input file > Reading   16 bands at     49 k-points
     List of atomic wavefunctions: Range:  -21.4080   17.3580eV  Emin, Emax, [firstk, lastk] > 
     high-symmetry point:  0.0000 0.0000 0.0000   x coordinate   0.0000
     high-symmetry point:  0.5000 0.2887 0.0000   x coordinate   0.5774
     high-symmetry point:  0.3333 0.5774 0.0000   x coordinate   0.9107
     high-symmetry point:  0.0000 0.0000 0.0000   x coordinate   1.5773
     output file (gnuplot/xmgr) > skipping ...
     output file (ps) > stopping ...
     output file for projected band (gnuplot script) > run "gnuplot graphene.plotband.dat_pz_only" to get "graphene.plotband.dat_pz_only_projected.ps"
     and/or run "ps2pdf graphene.plotband.dat_pz_only_projected.ps" to get "graphene.plotband.dat_pz_only_projected.pdf"
     ```
     Note the 'x-coordinate' of the high-symmetry points: these are useful for plotting vertical lines.     

4.   The output file now contains the projection (weight) of each (E,k) pair onto the selected list of orbitals in the third column. You can thus use it when plotting for defining a pointsize or for setting a threshold. Here are two possible ways to plot the data with gnuplot.
     ```
     gnuplot> plot "graphene.bandspp.dat.gnu" w l, "graphene.plotband.dat_pz_only" u 1:2:3 with points pointsize variable pointtype 7
     gnuplot> thres=0.9
     gnuplot> plot "graphene.bandspp.dat.gnu" w l, "graphene.plotband.dat_pz_only" u 1:($3 > thres ? $2 : 1/0) w p pt 7
     ```

![Graphene proj band](Ref/graphene_plotband_size.png?raw=true "graphene proj band")
![Graphene proj band](Ref/graphene_plotband_thres.png?raw=true "graphene proj band")

 ## Using projwfc_to_bands.awk 
2.  The so-called "fatband" plot can be made by resolving the DOS for each band and k-point.
   ```
   % cat projwfc_kpdos.in
   &PROJWFC
     prefix       = "graphene",
     outdir       = "./tmp",
     degauss = .0146997
     kresolveddos = .true.
     lsym=.false.
     filpdos='graphene.kpdos'
   /
   % projwfc.x < projwfc_kpdos.in > projwfc_kpdos.out
   ```
   Note that the PDOS file now has an extra (first column) with the k-point index:

   ```
   % head graphene.kpdos.pdos_tot
    # ik    E (eV)  dos(E)    pdos(E)
    1  -22.008  0.348E-03  0.343E-03
    1  -21.998  0.469E-03  0.461E-03
   ```

   Extract a range of projected bands from the 'projwfc_kpdos.out' file using the `projwfc_to_bands.awk` script (on OS/X install `gawk`). Here just pick state 2 (first C, pz):
   ```
   awk -v firststate=2 -v laststate=2 -v ef=-1.8243 -f projwfc_to_bands.awk projwfc_kpdos.out > graphene.kpdos_pz_only
   ```
   The output can be plotted with a density map plot.

 
  
## Bibliography
1.  Aroyo et al, Acta Cryst. (2014). A70, 126-137 [Link](https://doi.org/10.1107/S205327331303091X)
