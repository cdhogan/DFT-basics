# Surface Al(001) convergence

Here we test convergence for a (3x3) supercell of the Al(001) surface.

     ![Al(001) slab](Ref/al001_O_geometry.png?raw=true "Al(001) slab")

al001_O_geometry.png

## Input file

To create the atomic positions for a surface slab, it is easy if you have the right software. Even common free AI tools will prepare an input for you. In principle, one can use VESTA, or the CrystalToolKit at Materials Project.

A sample input file of a (3x3) surface supercell formed from bulk-truncated Al(001) is presented in `al001_3x3_unrelaxed.in`. It is a thin slab with four atomic layers.
For simplicity we will use `ibrav=0` and CELL_PARAMETERS.
Most other parameters will be those we determined for bulk Al: pseudopotential, cutoff, dual, smearing, lattice constant. 

For the (001) surface, the surface lattice constant is 1/sqrt(2) times the bulk one (demonstrate this!). Thus, we use A = 2.8546 = 4.0371/1.41421 to define `alat`. It is particular convenient to define the atomic positions in the slab in terms of this factor: note the z-values of Al planes are multiples of sqrt(2), and the CELL_PARAMETERS and (x,y) coordinates are integers.

   ```
   &CONTROL
     calculation = "relax",
     pseudo_dir  = "../../Pseudo",
     prefix      = "Al"
     outdir      = "./tmp",
   /
   &SYSTEM
     nosym       = .false.
     ibrav       = 0,
     A           = 2.8546 
     nat         = 36,
     ntyp        = 1,
     ecutwfc     = 20.D0,
     ecutrho     = 160.D0,
     occupations = "smearing",
     smearing    = "marzari-vanderbilt",
     degauss     = 0.05D0,
   /
   &ELECTRONS
     conv_thr    = 1.D-7,
     mixing_beta = 0.5D0,
     mixing_mode = 'local-TF' ,
   /
   &IONS
     bfgs_ndim         = 3,
   /
   CELL_PARAMETERS {alat}
    3.000000   0.000000   0.000000 
    0.000000   3.000000   0.000000 
    0.000000   0.000000   8.000000 
   ATOMIC_SPECIES
   Al  1.0  Al.pbe-n-kjpaw_psl.1.0.0.UPF
   ATOMIC_POSITIONS alat
    Al    0.00000000       0.00000000       0.00000000      0 0 0
    Al    0.00000000       1.00000000       0.00000000      0 0 0
    [...]
    Al    1.50000000       1.50000000      0.707106769      0 0 0
    Al    1.50000000       2.50000000      0.707106769      0 0 0
    [...]
    Al    2.50000000       1.50000000      0.707106769      0 0 0
    Al    2.50000000       2.50000000      0.707106769      0 0 0
    Al    0.00000000       0.00000000       1.41421354      0 0 1
    Al    0.00000000       1.00000000       1.41421354      0 0 1
    [...]
    Al    2.50000000      0.500000000       2.12132025      0 0 1
    Al    2.50000000       1.50000000       2.12132025      0 0 1
    Al    2.50000000       2.50000000       2.12132025      0 0 1
   K_POINTS {automatic}
   4 4 1 1 1 0
   ```
   Notice we also add a few new keywords, such as: `mixing_mode = 'local-TF'`, which is good for surfaces.

## Geometry optimization

When a surface is cleaved, the atoms will reconstruct or relax into new positions. For the Ag(001) case, the outer layers of the slab shift slightly outwards into the vacuum. We can perform a geometry optimization with `relax` to determine the equilibrium positions.

In principle it would be more efficient to do this for a (1x1) cell, and then construct a (3x3) cell from the relaxed positions. For the sake of brevity we will run the relaxation on the (3x3) cell. 

For surface simulations it is very common to keep some atomic layers fixed at their 'bulk' positions. Here we have fixed the backmost two layers (0 0 0), and allow the topmost layers to move along z only (0 0 1). 

One convergence parameter we have to check are the k-points. Again in principle one could work out the equivalent grid as used for the bulk Al calculations. However, it's just as easy to check convergence in a systematic manner as before.

Lets run the relaxation for a small k-point grid. Launch the job in the background (&), redirect the output to a file (in the background >&), and check it periodically without using an editor.
   ```
   % mpirun -np 4 pw.x < al001_3x3_unrelaxed.in >& al001_3x3.out_221 &
   % tail -f al001_3x3.out_221		<- show last lines of file in real time
   % grep scf al001_3x3.out_221         <- see how the SCF runs are going
     [...]
   % grep "Total force" al001_3x3.out_221  <- see how the forces are changing
     Total force =     0.057686     Total SCF correction =     0.000066
     Total force =     0.050226     Total SCF correction =     0.000076
     Total force =     0.042034     Total SCF correction =     0.000040
     Total force =     0.029918     Total SCF correction =     0.000006
     Total force =     0.011782     Total SCF correction =     0.000025
     Total force =     0.008026     Total SCF correction =     0.000031
     Total force =     0.011228     Total SCF correction =     0.000050
     Total force =     0.009587     Total SCF correction =     0.000036
     Total force =     0.007216     Total SCF correction =     0.000041
     Total force =     0.003680     Total SCF correction =     0.000003
     Total force =     0.000098     Total SCF correction =     0.000018
     Total force =     0.000092     Total SCF correction =     0.000002
   % grep -B1 "End final" al001_3x3.out_221
   Al    2.4999998497  2.4999998497  2.1490018710    0   0   1
   End final coordinates
   ```
   Thus the outermost layer expands from z=2.12 (initial position) to 2.149 (alat units).


   Repeat the process for denser k-point grids. Here, we can save a lot of time by restarting from a previous calculation.
   ```
   restart_mode = 'restart'
   [...]
   startingpot = 'file'
   startingwfc = 'atomic'
   ```

   At some point, the BFGS relaxations will terminate immediately at 0 steps, indicating that convergence with respect to k-points is reached.


### When you have completed this tutorial, you can move on to [2_O_atom: O atom](../2_O_atom)
