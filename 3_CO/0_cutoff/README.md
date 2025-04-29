# Isolated systems: kinetic energy cutoff

In this tutorial we consider an isolated system, the carbon monoxide (CO) molecule. 

# Outline
  1. Set up a calculation for a 0D system
  2. Converge the kinetic energy cutoff

## Running the exercise

  1. First look at the provided 'co.scf.in' file. 

     Like in the graphene case, since we are using a code based on Bloch's theorem for periodic systems, we must adopt a supercell scheme in which the molecule is surrounded by vacuum in all three directions. 
     ```
     % cat co.scf.in
     ibrav     = 0,
     [...]
     CELL_PARAMETERS {angstrom}
     8.0  0.0  0.0
     0.0  8.0  0.0
     0.0  0.0  8.0
     [...]
     ```
     This makes the calculation relatively heavy, as a large unit cell implies a smaller Brillouin zone, and a large number of reciprocal lattice vectors. 

     For isolated systems, one can use e.g. `ibrav=1`, `CELL_PARAMETERS{alat}`, bohr units, etc. However it is more common (and easier) to use Angstroms and cartesian coordinates when dealing with chemical systems.

     From the graphene tutorial we learned a good rule-of-thumb is to separate periodic images by about 10A. We start with a cube of 8A side to make the cutoff convergence tests a little faster.

     On the positive size, only a single k-point is required to integrate quantities over the Brillouin zone. In fact, if we choose this point to be the Gamma point in this way: 
     ```
     K_POINTS {Gamma}
     ```
     we switch on faster algorithms inside the code that reduce the memory load and CPU time - this is because the wavefunctions can be stored as real numbers and not as complex quantities.

     Note however that some (obscure) parts of the code or post-processing routines may not work with the Gamma-point sampling (the code will complain).

     We also make an initial guess for the C-O bond length. We could, for instance use Avogadro to make rough calculation, but here we can just use the experimental length of 1.13A - we will calculate the theoretical value after the cutoff has been established.
     ```
     ATOMIC_POSITIONS {angstrom}
     C  3.130  2.0  2.0  
     O  2.000  2.0  2.0  
     ```
     Have a look at the supercell geometry with XCrysDen, and check the images are not too close together. Note that we have not placed the molecule at the cell origin: this simply makes visualization easier.

     ```
     % xcrysden --pwi co.scf.in 
     ```
     When prompted, select "Do not reduce dimensionality" and add a few more cells with `Modify` -> `Number of units drawn` -> `2,2,2`. Check that the C-O bond length is 1.13A and that the *minimum* distance between a molecule and its image is 6.9A (i.e. 8-1.13).
     
  2. Now that we have set up a 'reasonable' 0D geometry, we must perform the kinetic energy cutoff tests for our system. The cutoff will be determined by the 'hardest' pseudopotential used, it could be the C or the O. 

     Carry out a series of SCF runs, modifying the value of `ecutwfc` each time, as done for bulk Si. Or better, use a script to scan progressively higher values of cut off:

     ```
     % ./Scripts/run_ecut
     ```
     Let's plot, like we did for Si, the convergence with total energy and with respect to the HOMO-LUMO gap.
     ![Etot vs cutoff](Ref/Etot_vs_Ecut.dat.png?raw=true "Etot vs Ecut")
     ![gap vs cutoff](Ref/Gap_vs_Ecut.dat.png?raw=true "Gap vs Ecut")

     A cutoff of 70Ry seems well converged. In the rest of the tutorial we will use 50Ry to speed things up.


