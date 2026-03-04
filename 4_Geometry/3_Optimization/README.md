## UNDER CONSTRUCTION

Geometry optimization of periodic systems can be tricky. What works for bulk silicon will not work for 2D silicene. It is important to understand what is a truly free parameter, and what is constrained by symmetry. There are powerful tools at your disposal but it is important to understand their limitations. In this tutorial we will discuss how to approach geometry optimization for systems with different dimensionality, degrees of freedom, and symmetry, pointing out common pitfalls. In the following we discuss a range of 0D-3D systems, getting progressively more complicated.

* 0D: C2H6 molecule
* 3D: Si bulk
* 2D: graphene
* 3D: graphite
* 1D: (4,0) carbon nanotube
* 2D: silicene 
* 3D: GaN bulk

Note that a small k-point grid has often been chosen to speed up calculations.

## 0D: C2H6 molecule

* Manual: E(relax) 

As seen in previous tutorials, isolated molecules can be computed in quantum-ESPRESSO using a supercell approach whereby the molecule is surrounded by empty space in a large box. As a rule of thumb, at least 10A should separate the molecules from their periodic images in all directions. Thus the supercell geometry is fixed and the only calculation that needs to be done is 'relax'. Nonetheless, there are several pitfalls which can be numerical or physical in nature, including:

1) Image interactions. If the molecule has a strong dipole moment (like HF or NH3) there is a systematic error due to electrostatic interation between the periodic array of dipoles. In this case, a larger supercell should be used, or better, corrected to remove the intercell interactions using `assume_isolated = 'mt'`. Similar issues arise if the molecule is charged.
2) Local vs global minima (conformational complexity). A standard geometry optimization algorithm (e.g. BFGS) can end up in a nearest minimum, which can be a local not global one. For a large molecule, there can be multiple local minima. One should try different starting points, perform torsion scans, distort the molecule, to explore the configuration space (or better use an approach like CREST or xTB).
3) Wrong spin state. Lower energy spin states may exist for open shell molecules/ions, transition metal complexes, etc. A classic example is the O2 molecule, which has a triplet ground state, but codes will happily converge to the singlet state if care is not taken. 
4) Flat potential energy surfaces. Large "floppy" molecules or weakly bound complexes may be very slow to reach a minimum, or require a very low force threshold.
5) Symmetry traps. If symmetry is detected or enforced in the initial geometry, codes can constrain the molecule to stay in a higher energy, symmetric, state.

Let's consider the last case. Copy from the Inputs folder the C2H6.in_eclipsed file, inspect the contents, and launch a relaxation calculation. View the result with xcrysden and note the total energy.

  ```
  % cp Inputs/C2H6.in_eclipsed .
  % pw.x < C2H6.in_eclipsed > C2H6.out_eclipsed
  % grep ! C2H6.out_eclipsed
  % xcrysden --pwo C2H6.out_eclipsed
  ```
The C2H6 molecule is initially in the so-called "eclipsed" conformation, whereby the H atoms are aligned (looking down the C-C bond). This creates steric interaction and raises the total energy. However, the geometry optimization keeps the same geometry. This is because it lies in a stationary first-order saddle point - or a maximum with respect to the torsional angle.

It's a trap!

Try:
* Turn off symmetries
* Lower the force threshold
* Change the box from cubic to orthorhombic
* Slightly disort the atomic positions by hand.

In each case check to see if the molecule relaxes into a different geometry, and/or if the total energy changes significantly.

If unsuccessful, try the C2H6.in_distorted input file in the Inputs folder. 

  ```
  % cp Inputs/C2H6.in_distorted .
  % pw.x < C2H6.in_distorted > C2H6.out_distorted
  % grep ! C2H6.out_distorted
  % xcrysden --pwo C2H6.out_distorted
  ```

The optimization converges to the so-called 'staggered' conformer, which is lower in energy. The literature suggests it is more stable than about 3 Kcal/mol, or 0.13 eV - check it.

Exercise: Plot the torsional energy barrier, i.e. the total energy vs dihedral angle, from 0 to 120 in steps of 15 degrees. 

Note: Symmetry reduces the number of coordinates that must be optimized (speeds up the calculation) but can also force a system to stay in a 

Note: How to confirm a molecule is in the global minimum? First check it is in a true local minimum by performing a vibrational frequency analysis: any imaginary frequencies indicate an unstable equilibrium. Second, you might need to perform a wider conformational search or use other more advanced methods (basin hopping, metadynamics, etc). This can be done in QE with ph.x or more easily with a code like ORCA. 

## 3D: Bulk Si, diamond lattice

* Manual: E(scf) vs alat; fit to equation of state
* Variable-cell relax: ibrav, fixed atoms

In the bulk silicon case the geometry is fully determined by the lattice constant (alat); the atomic positions are naturally constrained by symmetry. Thus the calculation type is "scf" or "vc-relax" with fixed atoms. 

### Variable-cell relax

  ```
  % cp Inputs/si.vc-relax.in .
  % cat Inputs/si.vc-relax.in 	[edited]
&CONTROL
  calculation  = "vc-relax",
/
&SYSTEM
  ibrav     = 2,
  A = 5.43,
/
&IONS
/
&CELL
   press_conv_thr=0.001
   cell_dofree="ibrav"
/
ATOMIC_POSITIONS {alat}
 Si 0.00 0.00 0.00 0 0 0
 Si 0.25 0.25 0.25 0 0 0

  % pw.x < si.vc-relax.in > si.vc-relax.out
  % grep ! "celldm(1)" si.vc-relax.out	(in bohr)
  ```
or use the script
  ```
  % ./Script/run_alat_Si_bulk
  ```
With respect to the kinetic-energy cutoff, the results give:

  ```
# alat(A) energy(Ry) cutoff (Ry)
5.25621         -16.96097653            10
5.38562         -17.04255240            20 
5.39343         -17.04458938            30 **
5.39403         -17.04473735            40
5.39405         -17.04475579            60
  ```
thus the lattice parameter seems converged to 5.39A at about 30Ry. 

Note: the recommended cutoff for this pseudopotential (pseudo-DOJO) is 24-32 Ry.

### Scan a; fit to equation of state

Alternatively you can manually (or with a script) scan alat vs the total energy.
In this tutorial we scan always with a step size of 0.01A, which ensures that the minimum energy found is converged for lattice constant accurate to 0.01A.
  ```
  % cp Inputs/si.scf.in .
  % pw.x < si.scf.in > si.scf.out
  ```
Vary alat around the minimum value found with vc-relax. The results (also generated with the ./Script/run_alat_Si_bulk script) give:
  ```
# min   energy  cutoff  fit
5.42            -16.96583990    10       5.41611
5.39            -17.04824626    20       5.39384 **
5.39            -17.05049551    30       5.39160
5.39            -17.05066370    40       5.39127
5.39            -17.05068366    60       5.39133
  ```
Just looking at the minimum energy found in the scan, the data seems converged at 20Ry, i.e. fast than with vc-relax.

The most correct procedure to follow is to perform a fit using an equation of state (e.g. murnaghan-birch: birch2).
ev.x
 The results of fitting appear in the rightmost column, and confirm the previous result. However, the EOS fitting will work also with a larger scan step, and even for lower cutoffs, as it averages through oscillations in the data.

Why not use vc-relax all the time?
- It is excellent for finding a first approximation to the lattice parameters. 
- It is efficient, especially compared to a double scan (e.g. on a and c).
- However it works on minimizing the stress, which is a noisy, derived quantity. 
- The minimum stress does not necessarily mean minimum energy!
- In planewave DFT, the basis set (G vectors) depends on the cell. When the cell changes, the basis changes, leading to a ficticious stress. This "Pulay" stress at best means a higher cutoff is needed.
- If the starting coordinates are far from the final ones, it may be necessary to run vc-relax several times.
- Instead, by keeping the cell fixed, e.g. by scanning alat, the calculation is variational and the total energy can be safely used.

HINT: Use vc-relax to find the approximate value, and use an energy scan around this point to find the exact value.

## 2D: graphene, flat honeycomb 

* Manual: E(scf) vs alat
* Variable-cell relax: 2Dxy, fixed atoms

In the graphene case the geometry is fully determined by the in-plane lattice constant (alat); the atomic positions are naturally constrained by symmetry. Thus the calculation type is "scf" or "vc-relax" with fixed atoms. 

  ```
  % cp Inputs/graphene.*.in .
  % pw.x < graphene.scf.in > graphene.scf.out
  % pw.x < graphene.vc-relax.in > graphene.vc-relax.out
  ```

### Variable-cell relaxation
We start with a vc-relax calculation, constraining the height of the cell to be fixed, and allowing the in-plane axes to vary. Note that the atoms are in high-symmetry positions so they will not move during the relaxation (forces are zero).
  ```
&CELL
   press_conv_thr=0.001
   cell_dofree="2Dxy"
/
ATOMIC_POSITIONS crystal 
    C      0.000000000    0.000000000    0.500000000    
    C      0.333333333    0.666666667    0.500000000
  ```
Run the vc-relax calculation for increasing cutoff, or use the provided script.
  ```
  % ./Script/run_graphene_vc-relax-a

# cutoff(Ry)     a(A)    		energy(Ry)
20              2.35804600              -23.35333161
40              2.41618571              -23.99910851
60              2.45776487              -24.08829889
80              2.46621076              -24.09459622 ** converged 
100             2.46678699              -24.09473579
120             2.46678210              -24.09474871
  ```
Convergence is achieved at 80Ry, with a=2.47A.

### Scan alat, scf calculation

To solidify the result, we perform a fine scan (step 0.01A) around this value of alat and select the minimum value of energy (use sort -k2,2 -nr):
  ```
20Ry    2.59            -23.45692794
40Ry    2.49            -24.00626779
60Ry    2.47            -24.08835571 ** converged 
80Ry    2.47            -24.09457928
100Ry   2.47            -24.09471886
  ```
Once again we see convergence is obtained at a lower cutoff of 60Ry. In this case there is no equation of state option; you could fit the data to a polynomial if you wish, but if the scan step is small enough it's probably not needed.

## 3D: graphite

The geometry is fully determined by the in-plane lattice constant (alat) and the out-of-plane (interlayer) stacking (c). Atomic positions are again naturally constrained by symmetry. Now we have several options to perform the geometry optimization.

* Manual: E(scf) vs a vs c
* Full vc-relax: ibrav, fixed atoms
* Partial vc-relax: scan a, vc-relax on c only, fixed atoms


Full vc-relax:



Manual:
a fine, c wider



F. 1D with internal parameter: carbon nanotube
The geometry is determined by the axial lattice constant (c) and the tube diameter (d)

Manual: E(relax) vs c
Variable-cell relax: ?, free atoms





D. 2D with internal parameter: silicene, buckled honeycomb lattice
The geometry is determined by the in-plane lattice constant (alat) and the buckling height (h).


Manual: E(relax) vs alat 
Variable-cell relax: ibrav+2Dxy, free atoms



E. 3D with internal parameter: MoS2 bulk
The geometry is determined by the in-plane lattice constant (alat) and the internal parameter (u).

Manual: E(relax) vs alat vs c
Variable-cell relax: ibrav, free atoms



