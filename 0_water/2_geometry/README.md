Plane-wave DFT has discretization errors. 
Orientation dependence is a direct manifestation of finite basis/grid and is expected unless you push to the converged limit.

Compare the TE difference with the threshold you used before on ecutwfc

Difference in total energy
- thresholds
The TE and force thresholds need to be tighter
- cutoff
Rotating the molecule changes how the real-space features (density, projectors) project onto that fixed set of plane waves -> tiny energy differences.
- symmetry
- box size
H2O is polar, so there are dipolar interaction between images

