# Projected band structure calculation
One way to analyse the band structure is to project it onto specific atoms or atomic orbitals. In quantum-ESPRESSO there are a number of ways to do this. 
![Graphene BZ](Ref/graphene-BZ.png?raw=true "graphene BZ")

## Setup

  1. First, let's set up the calculation by computing the band structure again in the usual way: SCF + BANDS + BANDSPP.
      ```
      % pw.x < graphene.scf.in > graphene.scf.out
      % pw.x < graphene.bands.in > graphene.bands.out
      % bands.x < graphene.bandspp.in > graphene.bandspp.out
      ```
      Check everything worked by plotting 'graphene.bandspp.dat.gnu' as before.
      ```
      gnuplot> EFermi=-1.8243
      gnuplot> plot "graphene.bandspp.dat" u 1:($2-EFermi) w l
      ```

## Using plotproj.x     
  2. Before continuing, you should learn to use `projwfc.x` code (see the 7_projected_DOS tutorial).

     Here we run again `projwfc.x` for the eigenvectors along the band structure path.
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
 ## Using plotband.x

 ## Using plot_states.awk

  7. ADVANCED: You can also use the script 'run_bands' which will automate all the steps (the k-path need to be put manually when building the script) and also makes use of the `plotband.x` code. The gnuplot script 'bands.gnuplot' will create the image shown above from the 'bands.dat.gnu' file. 
      ```
      gnuplot> load "Scripts/bands.gnuplot"
      ```
## Bibliography
1.  Aroyo et al, Acta Cryst. (2014). A70, 126-137 [Link](https://doi.org/10.1107/S205327331303091X)
