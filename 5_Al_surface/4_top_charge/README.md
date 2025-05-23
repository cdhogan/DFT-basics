# Chemical bonding analysis: charge and potential

In this tutorial we examine some ways to analyse the chemical bond between the O atom and the Al(001) surface. In particular we will focus on analysing the electronic charge density.

Before continuing, let's regenerate the ground state charge density for the converged geometry and parameters.
We use a 6x6x1 k-point grid corresponding to 6 k-points, thus on a 16-core machine:
   ```
   % mpirun -np 12 pw.x -npool 6 < al001_3x3_O-top.in >& al001_3x3_O-top.out &
   % ls tmp/Ag.save
   Al.pbe-n-kjpaw_psl.1.0.0.UPF	paw.txt		    wfc1.dat ... wfc6.dat   
   O.pbe-n-kjpaw_psl.0.1.UPF	
   charge-density.dat		data-file-schema.xml		
   ```
This SCF run can take 5-10 minutes. Make sure the calculation is complete before continuing.

### Electrostatic potential

Let's start by looking at the planar-averaged electrostatic potential. As before, use `pp.x` and `average.x`.
   ```
   % pp.x < pp_pot.in
   % average.x < average_pot.in
   % mv avg.dat avg_pot_Al001_O.dat        <- NB later runs of average.x will overwrite "avg.dat"
   % gnuplot
   gnuplot> plot "avg_pot_Al001_O.dat" t "Average" w l,"" u 1:3 t "Macroscopic average" w l
   ```

![potential](Ref/plot_pot.png?raw=true "potential")

We note several things:

- There is a gradient in the vacuum region. This is because the slab with oxygen on one side is now polar, and there is a long range dipolar interaction between images. This could effect some properties! We could mitigate it by increasing the vacuum size (with a penalty of slower calculation), by using a (thicker) symmetric slab with O on both sides, or by implementing a dipole correction in the vacuum (see keyword `dipfield`).
- The potential from the O atom is hardly visible (see the arrow) due to the averaging process across 3x3 cells.
- The potential in the Al layers is not precisely constant, indicating our slab is not really thick enough.
- By applying a second averaging step (the window size is defined in the last line of `average_pot.in`) we can determine the average value of the electrostatic potential (i.e. the macroscopic potential) inside the slab. This can be useful for aligning slab and bulk calculations.
- By comparing with the electrostatic potential of the clean surface, we can compute the work function change due to O adsorption (at 0.11ML coverage).

However, this analysis doesn't really help with understanding the chemical bonding.

### Charge density difference (CDD)

This is a very powerful technique for analysing and understanding bonding. In particular, it allows us to analyse the charge redistribution after a chemical bond or interaction is formed.

<img src="Ref/CDD.png" height="60"/>

It is based on calculating the charge densities of the relaxed Al(001)/O system and of the A(001) and O atom in the same frozen geometries they have in the Al(001)/O case. The latter are called "peeled-off" geometries. In other words, for the peeled off Al(001) system, we take the converged Al(001)/O geometry, remove the O atom, and recompute the charge density (without relaxation).

For the difference calculation to work, the three calculations must be done in exactly the same way (cell, cutoff, k-points, etc). The atoms must be in the same positions, otherwise the Delta rho will just show huge spikes due to the shift in the total atomic charge density!

It is highly important to do things neatly: use separate folders for the separate systems.

This process is subtly different from the adsorption energy calculation, which used the _relaxed_ Al(001) surface and an O atom (or O2 molecule) in a _cubic box_ as reference.

Let's calculate then the CDD as a difference in the planar averages and as a difference in the 2D densities: both are useful to understand the results. For reasons that will be clear later, we will call the input for `pp.x` "charge0.in", where 0 corresponds to the value of `plot_num` (valence charge density).

   ```
   % cat charge0.in
   &INPUTPP
      prefix       = "Al",
      outdir       = "./tmp",
      plot_num     = 0
      filplot      = "Al001_O_charge.dat"
   /
   &plot
     iflag=3
     output_format=6
     fileout="Al001_O_charge.cube"
   /
   % pp.x < charge0.in
   [...]
   Writing data to file  Al001_O_charge.dat
   Reading data from file  Al001_O_charge.dat

   Writing data to be plotted to file Al001_O_charge.cube
   Plot Type: 3D                     Output format: Gaussian cube
   ```
The _unformatted_ charge density is written to "Al001_O_charge.dat", and the _formatted_ charge density is written to "Al001_O_charge.cube". The latter is an alternative file format to XSF, it can be opened for instance with VESTA (`% VESTA Al001_O_charge.cube`)

Using `average.x` we compute the planar average of the _charge density_, reading the "Al001_O_charge.dat" file.
   ```
   % average.x < average_charge.in
   % mv avg.dat avg_Al001_O.dat
   ```
Now, we do the same for the two peeled off systems. Obviously, we have to do an SCF run first in each case.
   ```
   % cd O_peeled
   % mpirun -np 4 pw.x < O_peeled.in > O_peeled.out
   % pp.x < charge0.in
   % average.x < average.in
   % mv avg.dat avg_O.dat
   %
   % cd ../Al001_peeled
   % mpirun -np 6 pw.x -npool 6 < al001_peeled.in > al001_peeled.out
   % pp.x < charge0.in
   % average.x < average.in
   % mv avg.dat avg_Al001.dat
   ```
Yes - it's bit tedious, just take your time. Now we collect the data and compute the difference. Let's do this in a separate folder. Use the UNIX command `paste` to collect the three avg.dat files together, and use `awk` to select the columns we want:
   ```
   % cd ../Charge_difference
   % paste ../avg_Al001_O.dat ../Al001_peeled/avg_Al001.dat ../O_peeled/avg_O.dat | awk '{print $1,$2,$5,$8,$2-$5-$8}' > avg_difference.dat
   % gnuplot
   gnuplot>
   ```

What we can expect to find:

Top site:
- Charge depletion just above the Al atom.
- Charge accumulation between Al and O, suggesting covalent bonding (see adsorption energy).

Bridge or hollow site:
- Accumulation may appear between multiple Al atoms and O, indicating shared bonding.

Charge transfer direction:
- If electrons accumulate around O, and deplete near Al, this means O is accepting electrons from Al (this is expected for electronegative atoms like O).


1. Average plot

2. 3D plot

### Charge transfer and Bader charges

    We can use the `bader` code to compute the atomic charges.
    ```
    % pp.x < charge0.in 
    % pp.x < charge21.in 
    % bader charge0.cube -ref charge21.cube 
    % cat ACF.dat 
           #         X           Y           Z       CHARGE      MIN DIST   ATOMIC VOL
    --------------------------------------------------------------------------------
       1   16.183237   16.183237   43.155298    2.858544     2.377244   497.997653
       2   16.183237    5.394412   43.155298    2.971628     2.377255   501.735615
    [...]
      32    8.091618    8.091618   11.088886    2.080497     0.649342    80.792968    <- Al (top)
    [...]
      36   13.479400   13.479400   11.633543    2.978900     2.426442   433.333846
      37    8.091618    8.091618   14.260430    7.629474     2.176960  1904.246603    <- O
       --------------------------------------------------------------------------------
       VACUUM CHARGE:               0.0000
       VACUUM VOLUME:               0.0000
       NUMBER OF ELECTRONS:       113.9994
    ```
(O is #37, the Al underneath is #32).

Thus O has accepted 1.63 electrons from the surface, most of which is coming from the Al atom bonded to it.

