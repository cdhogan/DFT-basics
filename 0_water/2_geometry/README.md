# Geometry optimization

In this tutorial we will compute the optimized geometry of the water molecule.

<img src="Ref/geometries.png" height="80"/>

### Outline
1. Optimize the geometry of H2O
2. Converge the kinetic energy cutoff with respect to the geometry
3. Constrained optimization

### Running the exercise

1. Let's inspect the file 'H2O.relax_symmetric.in'.

Run at 60Ry. 
EXtract H-O bond length and internal angle.

### Converge with respect to the cutoff

2. Test cutoff

<img src="Ref/Bond_vs_ecut-script.dat.png" height="400"/>

Compare the TE difference with the threshold you used before on ecutwfc
Rpeat the cutoff study, list the O-H length and bond angle

### Constrained optimization

3. Let's look now at the other files 'H2O.relax_aligned.in' and 'H2O.relax_linear.in'

Same cutoff of 60Ry

Compare total energy of aligned with symmetry: discussion of errors
Plane-wave DFT has discretization errors. 
Orientation dependence is a direct manifestation of finite basis/grid and is expected unless you push to the converged limit.

4. Linear case: stability.



Difference in total energy
- thresholds
The TE and force thresholds need to be tighter
- cutoff
Rotating the molecule changes how the real-space features (density, projectors) project onto that fixed set of plane waves -> tiny energy differences.
- symmetry
- box size
H2O is polar, so there are dipolar interaction between images

