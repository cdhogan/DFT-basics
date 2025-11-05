# Geometry optimization

In this tutorial we will compute the optimized geometry of the water molecule.

<img src="Ref/geometries.png" height="150"/>

### Outline
1. Optimize the geometry of H2O
2. Converge the kinetic energy cutoff with respect to the geometry
3. Constrained optimization

### Running the exercise

1. Let's inspect the file 'H2O.relax_symmetric.in'. There are some new additions with respect to the previous run:
```
&CONTROL
  calculation  = "relax",         <-- New calculation type
  prefix       = "H2O",
  pseudo_dir   = "../../Pseudo",
  outdir       = "./tmp",
  verbosity    = 'high'
  tprnfor = .true.                <-- Print forces
/
&SYSTEM
  ibrav     = 0,
  nat       = 3,
  ntyp      = 2,
  nbnd      = 6,
  ecutwfc   = 60                <-- Set to 60 Ry
/
&ELECTRONS
/
&IONS                            <-- new NAMELIST
/

CELL_PARAMETERS {angstrom}
 8.0  0.0  0.0
 0.0  8.0  0.0
 0.0  0.0  8.0
ATOMIC_SPECIES
H  1.00  H_ONCV_PBE-1.2.upf
O  6.00  O_ONCV_PBE-1.2.upf 
ATOMIC_POSITIONS {angstrom}
H  3.3  4.0  3.3    
O  4.0  4.0  4.0   0 0 0          <-- oxygen atom is fixed
H  4.7  4.0  3.3 
K_POINTS {Gamma}
```

* The calculation type is now 'relax', rather than 'scf', meaning that atoms are now allowed to move. This corresponds to a second, outer loop (ions), around the SCF loop (electrons).
The calculation will proceed until the forces fall below some threshold as defined by the parameter `forc_conv_thr` (here we use the default value).
The line `tprnfor = .true.` requests that the forces are written to the output file at each step.
* We run the calculation at 60 Ry, following the suggestions in the previous tutorial.
* There is a new NAMELIST called `&IONS` (the default parameters are fine)
* We fix the cartesian (x,y,z) values, respectively, of the O atom, by adding the string '0 0 0' after its coordinates. This should not change the results, but allows us to inspect more easily the atomic positions.

The geometry is the same as before, and called "symmetric" in the above figure, being aligned symmetrically (albeit offset) about the z-axis.

2. Run the optimization calculation. Note that it takes longer than the SCF one, so it is a good idea to run in parallel.
```
% mpirun -np 2 pw.x < H2O.relax-symmetric.in > H2O.relax-symmetric.out 
```
When it is done, you can confirm the convergence of the forces:
```
% grep "Total force" H2O.relax-symmetric.out
     Total force =     0.067829     Total SCF correction =     0.000064
     Total force =     0.050925     Total SCF correction =     0.000179
     Total force =     0.036195     Total SCF correction =     0.000047
     Total force =     0.014541     Total SCF correction =     0.000060
     Total force =     0.001085     Total SCF correction =     0.000086
     Total force =     0.000157     Total SCF correction =     0.000035
```

> [!TIP]
> Again, always check the _output file_ to confirm the calculation terminated correctly. For a geometry optimization, you should see lines like:
> ``` 
>     bfgs converged in  12 scf cycles and  11 bfgs steps
>     (criteria: energy <  1.0E-04 Ry, force <  1.0E-03 Ry/Bohr)
>     End of BFGS Geometry Optimization
> ```    




More interestingly, you can view the geometry optimization as an animation with xcrysden. Launch now with the option for PWscf _output_ file:
```
% xcrysden --pwo H2O.relax-symmetric.out
```
and Click "View as animation". Use the arrow buttons to track the movement of the atoms and satisfy yourself that the final geometry is reasonable.

For the final geometry, extract the H-O bond length and the internal angle, and compare with the experimental values of 0.96A and 104.5 degrees. 
(You should measure something like 0.97A and 104.1 degrees).

### Converge with respect to the cutoff

2. Let's return to the issue of the kinetic energy cutoff. How does it effect the geometry?

Repeat the convergence test from the first tutorial, but this time allow the molecule to relax at each value of the cutoff. Since this is tedious, run at 20Ry, 40Ry, 60Ry and 80 Ry. 
```
% mpirun -np 2 pw.x < H2O.relax-symmetric.in > H2O.relax-symmetric.out_20Ry
[...]
% mpirun -np 2 pw.x < H2O.relax-symmetric.in > H2O.relax-symmetric.out_80Ry
```
For each output, extract the O-H bond length and the internal angle. Prepare as before a 3-column file with the data (ecutwfc, bond length, angle), and plot the results with gnuplot.

<img src="Ref/Bond_vs_ecut-script.dat.png" height="400"/>

Based on the study of the total energy, HOMO-LUMO gap, and geometry, what is the best value (i.e. the lowest acceptable one) of the kinetic energy cutoff for this system? (meaning: these elements, these pseudopotentials, this XC choice...)

| Criterion    | Precision    | Cutoff |
| ---   | --- | --- |
| Total energy  | 1 mRy/molecule | ~75   |
|               | 10 mRy/molecule | ~65   |
| HOMO-LUMO gap | 1 meV   | ~45   |
|               | 10 meV   | ~70  |
| Bond length   | 0.01A   | ~40   |
|               | 0.001A   | ~50   |

> [!IMPORTANT]
> The optimal cutoff depends on the _physical property_ and the _precision_ you are interested in.

### Constrained optimization

3. Let's look now at the file 'H2O.relax_aligned.in'. It is identical to the symmetric case, except for the orientation of the molecule. As you can see in the image above (or have a look with `xcrysden`), one of the O-H bonds is aligned along the X-axis. In this simulation we will constrain this O-H bond to remain aligned along the X-axis, and constrain all three atoms to remain in the X-Z plane. This is done using a triplet of integers on the right side after the coordinates: 
```
ATOMIC_POSITIONS {angstrom}
H  3.00  4.00  4.00    1 0 0        <-- H can only move along x-axis
O  4.00  4.00  4.00    0 0 0        <-- O is fixed
H  4.71  4.00  4.71    1 0 1        <-- H can only move in the x-z plane
```
Since H2O is planar, it should not make any difference if we constrain it and orient it in this way. 
Let's investigate if this is true. Launch the calculation:
```
% mpirun -np 2 pw.x < H2O.relax_aligned.in > H2O.relax_aligned.out
```
Let's look for differences in the output files H2O.relax_aligned.out and H2O.relax_symmetric.out.
```
% diff H2O.relax_symmetric.out H2O.relax_aligned.out | grep Sym
<       4 Sym. Ops. (no inversion) found          <-- the "<" refers to the file on the left (symmetric);
>       2 Sym. Ops. (no inversion) found          <-- the ">" refers to the file on the right (aligned).

% diff H2O.relax_symmetric.out H2O.relax_aligned.out| grep "bfgs converged"
<      bfgs converged in   6 scf cycles and   5 bfgs steps
>      bfgs converged in  12 scf cycles and  11 bfgs steps

% diff H2O.relax_symmetric.out H2O.relax_aligned.out| grep "Final energy"  
<      Final energy   =     -34.3012262573 Ry
>      Final energy   =     -34.3013777521 Ry
```
There are a few differences:
* By rotating the molecule, QE was no longer able to find all the symmetry operations. 
* The constrained/aligned run takes almost twice as many relaxation steps to converge.
* The total energies are very slightly different, by 0.15 mRy or 2 meV. Compare this 'error' with the precision reached in the previous tutoral at 60Ry (i.e. about 9 mRy above that at 100Ry). 

> [!TIP]
> Make use of symmetry when possible - it speeds up the calculation.
>
> Errors in geometry optimization arise due to the discretization in planewave DFT. Minimize them by using a high enough cutoff.

### Bent vs linear geometries

4. Last, let's consider the case where the molecule is constrained to be linear: 'H2O.relax_linear.in'
```
ATOMIC_POSITIONS {angstrom}
H  3.0  4.0  4.0    1 0 0          <-- H can move along x
O  4.0  4.0  4.0    0 0 0          <-- O is fixed
H  5.0  4.0  4.0    1 0 0          <-- H can move along x
```
Actually, since there are no forces in the y-z plane, there is probably no need to impose the constraints: the molecule will remain trapped in a high symmetry (16 Sym. ops!), linear configuration. Run the calculation:
```
% mpirun -np 2 pw.x < H2O.relax_linear.in > H2O.relax_linear.out
```
and compare the total energy with the 'symmetric' case. 
```
% grep "Final energy" *out
H2O.relax_aligned.out:     Final energy   =     -34.3013777521 Ry
H2O.relax_linear.out:      Final energy   =     -34.2069118460 Ry
H2O.relax_symmetric.out:   Final energy   =     -34.3012262573 Ry
```
The bent molecule is clearly more stable, by about 1.28 eV. 

### Scripts
The convergence tests above can be run via a simple bash script:
```
% ./Scripts/run_ecut
% ./Scripts/run_plots
```
Make sure you know how to run the code and understand error messages before attempting to use the scripts.  




