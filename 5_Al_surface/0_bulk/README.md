# Bulk Al convergence

Before we focus on the Al surface we have first to determine the correct cutoff and lattice parameters for bulk Al. 
The order of operations is the same as for bulk Si or 2D graphene:
- Set up an input file with "reasonable" parameters
- Kinetic energy cutoff
- K-points and smearing
- Determine the lattice parameter

## Input file

A sample input file is given in `al.scf.in`. We choose a soft GGA (PBE) pseudopotential from the SSSP 1.3.0 library, `Al.pbe-n-kjpaw_psl.1.0.0.UPF`. Bulk aluminium has a one-atom FCC structure, so we choose 'ibrav=2` like for silicon. We take the experimental lattice parameter of 4.05 A and a small 4x4x4 k-point grid shifted from the origin (advised for metals), with a moderate smearing parameter of 0.01Ry.
   ```
   &CONTROL
   calculation  = "scf",
   prefix       = "Al_bulk",
   pseudo_dir   = "../../Pseudo",
   outdir       = "./tmp",
   verbosity    = "high"
   /
   &SYSTEM
   ibrav     = 2,
   celldm(1) = 7.652448
   nat       = 1,
   ntyp      = 1,
   ecutwfc   = 20 
   ecutrho   = 200
   nbnd      = 5
   occupations = "smearing",
   smearing    = "marzari-vanderbilt",
   degauss     = 0.01D0,
   /
   &ELECTRONS
   conv_thr    = 1.D-8,
   mixing_beta = 0.7D0	,
   /
   ATOMIC_SPECIES
   Al  26.98  Al.pbe-n-kjpaw_psl.1.0.0.UPF
   ATOMIC_POSITIONS {alat}
   Al 0.00 0.00 0.00
   K_POINTS {automatic}
   4 4 4 1 1 1
   ```

## Kinetic energy cutoff
 
Since we already know how to compute `ecutwfc` by hand, we will just run a simple script. Note that since the pseudopotential is PAW type, we also have to explicitly define `ecutrho`, which is typically about 4-12 times `ecutwfc`. This multiplicative factor is called the "dual". Let's run convergence tests for ecutwfc at several values of the dual, i.e. `ecutrho = dual*ecutwfc`.

   ```
   % ./Scripts/run_ecut
   % ./Scripts/run_plots
   ```
   If the `run_plots` doesn't create the plots directly, load the generated gnuplot scripts inside `gnuplot`
   ```
   % gnuplot
   % gnuplot> load "plot-energy-script.gnu"
   ```
   ![Total energy vs kinetic energy cutoff](Ref/Etot_vs_Ecut-script.dat.png?raw=true "Total energy vs kinetic energy cutoff")

   From the convergence plot we identify a well converged value for `ecutwfc=20` Ry, and a dual of 8.

## K-point convergence
   Here we follow the same scheme as for 2D graphene. Note that the convergence with smearing and k-points is somewhat different for this simple metal in comparison with the semi-metal graphene.
   ```
   % ./Scripts/run_kpoints
   % ./Scripts/run_smearing
   % ./Scripts/run_smearing_plots
   ```
   ![Total energy vs k-points shift](Ref/Etot_vs_kgrid-script.dat.png?raw=true "Total energy vs k-points shift")
   
   First  we verify that a shifted grid gives better convergence behaviour.

   ![Total energy vs k-points and smearing](Ref/smearing-script-new.png?raw=true "Total energy vs k-points and smearing")

   Second, we identify a (shifted) grid of 8x8x8 and smearing of 0.05Ry as being well converged for bulk Al if we use the marzari-vanderbilt smearing. 

## Variable cell relaxation

Finally, we compute the lattice constant, using the converged parameters. The most convenient way to do this is with `vc-relax`. Modify the 'al.scf.in' file to run a vc-relax calculation for a bulk FCC cell. Since we only want to modify alat, and keep angles fixed, it would be useful to choose `cell_dofree = 'volume'`; however this is not allowed for `ibrav=2`. Let's choose `cell_dofree = 'ibrav'` instead. This has the added benefit of printing the updated celldm(1) at each step.
   ```
   % cp al.scf.in al.vc-relax.in0
   % vi al.vc-relax.in0			# update parameters and add vc-relax
   % cat al.vc-relax.in0
   &CONTROL
     calculation  = "vc-relax",
   [...]
   &SYSTEM
     ibrav     = 2,
     celldm(1) = 7.652448  ! first attempt
     ecutwfc   = 20 
     ecutrho   = 160
     occupations = "smearing",
     smearing    = "marzari-vanderbilt",
     degauss     = 0.05D0,
   [...]
   &IONS
   /
   &CELL
     cell_dofree='ibrav'
   /
   [...]
   K_POINTS {automatic}
   8 8 8 1 1 1
   ```
   Run the calculation and determine the new lattice parameter:
   ```
   % pw.x < al.vc-relax.in0 > al.vc-relax.out0
   % grep "celldm(1)" al.vc-relax.out0
     celldm(1)=   7.652448  celldm(2)=   0.000000  celldm(3)=   0.000000
       celldm(1) =      7.64303940
       celldm(1) =      7.62892650
       celldm(1) =      7.62892650
     celldm(1)=   7.652448  celldm(2)=   0.000000  celldm(3)=   0.000000
   ```
   In case `celldm(1)` is not written in the output, you could also determine the final value of "celldm(1)" by looking at the CELL_PARAMETERS:
   ```
   % grep -A4 CELL_PARAMETERS al.vc-relax.out0
   [...]
   CELL_PARAMETERS (alat=  7.65244800)
     -0.498463139   0.000000000   0.498463139
      0.000000000   0.498463139   0.498463139
     -0.498463139   0.498463139   0.000000000
   % bc -l
   >>> 7.65244800*0.498463139*2
   7.6289265
   ```
   or by calculating the cell length graphically within xcrysden
   ```
   % xcrysden --pwo al.vc-relax.out0
   ```
   In any case, we arrive at a value of `celldm(1) =      7.6289265`.

   It is good practice with `vc-relax` to run it again 1-2 times to make sure the value is converged. Plug this new value into the input file and run it again:
   ```
   % cp al.vc-relax.in0 al.vc-relax.in1   # update celldm(1)=7.6289265
   % pw.x < al.vc-relax.in1 > al.vc-relax.out1
   % grep "celldm(1)" al.vc-relax.out1
     celldm(1)=   7.628927  celldm(2)=   0.000000  celldm(3)=   0.000000
       celldm(1) =      7.62892650
     celldm(1)=   7.628927  celldm(2)=   0.000000  celldm(3)=   0.000000
   ```
   The calculation is thus converged at a value of alat = 7.6289 au = 4.0371 A.

   In summary, for bulk aluminium and Al.pz-vbc.UPF :
   ```
   ecutwfc      = 20 Ry
   k-point grid = 8x8x8 shifted
   smearing     = 0.05 Ry, Marzari-Vanderbilt
   alat         = 4.0371 A, 7.6289 bohr
   ```


### When you have completed this tutorial, you can move on to [1_surface: Al(001) surface](../1_surface)
