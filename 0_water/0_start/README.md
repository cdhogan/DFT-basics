# The water molecule

In this first tutorial we consider a familiar system: the water (H2O) molecule.
We will show how to set up a simple input file to compute the ground state electronic properties with quantum-ESPRESSO.

# Outline
  1. Inspect input file
  2. Visualize with XCrysDen
  3. Run the code
  4. Understand the output: number of electrons, bands, HOMO-LUMO gap, symmetries

add nband = compute gap
plot energy levels

## Input file

  1. First look at the provided 'H2O.scf.in' file. 
     In any calculation, the first thing we need to know is the number and type of atoms. 
     For the water molecule, that's easy: 2 hydrogens and 1 oxygen, so 3 atoms of 2 different types, 
     defined inside the &SYSTEM namelist:
     ```
     % cat H2O.scf.in
     [...]
     &SYSTEM
       ntyp = 2,
       nat  = 3,
     /
     [...]
     ```
  2. To simulate an isolated molecule, we place it in a large empty box. Later we will examine in more detail what size and form the box must take, but for now let's just take a cubic box of length about 8 A. We can do this by explicitly defining the three  orthogonal lattice vectors in an "input card" called `CELL_PARAMETERS` together with `ibrav = 0`:
     ```
     % cat H2O.scf.in
     ibrav     = 0,
     [...]
     CELL_PARAMETERS {angstrom}
     8.0  0.0  0.0
     0.0  8.0  0.0
     0.0  0.0  8.0
     [...]
     ```
     An alternative way to define a cubic cell is by setting `ibrav=1`, which defines a simple cubic Bravais lattice, and defining the cell length `A` in Angstrom:
     ```
     ibrav     = 1,
     A         = 8.0
     ```
     In this case, the `CELL_PARAMETERS` block should not also be present, otherwise the code will complain.

  3. Let's now define a *starting* geometry for our water molecule. 
     We know that water is not linear, like CO2, but is bent. For simplicity, let's assume an internal angle of 90 degrees.
     How long are the H-O bonds? Typical covalent/ionic bond lengths are in the 1-2 angstrom range: let's assume the bond length is about 1 A.
     We also know the molecule is symmetric, so let's set it up like an inverted "V" shape, with the O atom in the middle of the cell, and the molecule in the X-Z plane. (This choice is not crucial, but has some advantages.)
     The atomic coordinates are written in Angstrom in an `ATOMIC_POSITIONS` input card:
     ```
     ATOMIC_POSITIONS {angstrom}
     H  3.3  4.0  4.7    
     O  4.0  4.0  4.0    
     H  4.7  4.0  4.7  
     ```
     The other settings in the input file we will explain later. 

  4. Let's now visualize our input file using `xcrysden`.
     ```
     % xcrysden --pwi H2O.scf.in
     ```
     Here `--pwi` means "PWscf input file format". (You can also choose to read a PWscf input file from XcrysDen main menu).
     Click OK until you see the molecule inside a box: zoom in, rotate it, play with the menu options. 
     When ready, measure the bond length and the internal angle using the tools below the image, and check they are consistent with the initial choices above.

  5. If everything looks good, we can run a first simulation with quantum-ESPRESSO, and calculate some basic ground state properties of this approximate water geometry.
     ```
     % pw.x < H2O.scf.in    [ENTER]
     [...]
     =------------------------------------------------------------------------------=
        JOB DONE.
     =------------------------------------------------------------------------------=
     ```
     Launched in this way the output is written quickly to screen. You can scroll back to read the lines, or run it again and redirect the output to a file, e.g.
     ```
     % pw.x < H2O.scf.in > H2O.scf.out
     % less H2O.scf.out
     ```
  6. Inspect the output file. The beginning reports the information about the system (number of atoms, lattice vectors, bands, etc), and the end of the file shows the self-consistent calculation of the ground state (total energy, eigenvalues, etc). 
     Find, or calculate, the following information:

     * The number of electrons
     <details>
     <summary>Answer</summary>
     There are 8 electrons in our system. This is a little surprising, because O has 8 electrons in total, and H has 1, so we might expect 10 electrons. However, the 1s2 electrons in the O atom are accounted for in the pseudopotential, and we only consider the valence electrons (6 for O, and 1 for each H)
     </details>
     
     * The number of states or energy levels
     <details>
     <summary>Answer</summary>
     This is reported as the number of Kohn-Sham states: 6, and was defined in the input file (nbnd=6). 
     The default value for an insulator is nelec/2=number of occupied states (here, 4).
      </details>
      
     * The number of symmetries  
     <details>
     <summary>Answer</summary>
     The water molecule has four symmetry elements: the identity _E_, a twofold rotation axis C_2, and two vertical reflection planes sigma_{v}(xz) and sigma_{v}(yz). 
     These elements correspond to the four symmetry operations of the molecule, which define its C_{2v} point group. 
     </details>
     
     * How much RAM is needed
     <details>
     <summary>Answer</summary>
     `Estimated max dynamical RAM per process >      50.83 MB`
     </details>
     
     * The HOMO-LUMO gap
     <details>
     <summary>Answer</summary>
     `highest occupied, lowest unoccupied level (ev):    -6.9983   -1.0880`
     Thus the gap is 5.81eV. For comparison, the experimental value is 6.3eV.
     
     * The total energy
     `!    total energy              =     -34.04117898 Ry`
     Note that it's easy to search for the final total energy value using grep:
     `% grep ! H2O.scf.out`
     Note that total energies are given in Rydberg atomic units: 1 Ry = 13.6057eV = 0.5 Ha
     
     * The number of iterations needed to converge
     The self-consistent field (SCF) loop took 6 iterations to converge. You can track its progress towards convergence by grepping the total energy and its error (precision) at each iteration:
     ```
     % grep "total energy" H2O.scf.out
     % grep scf H2O.scf.out
     ```
     
     * The time taken for the calculation
     `PWSCF        :      0.68s CPU      0.75s WALL`
     There are two times reported. The CPU time is the calculation time, and can change with the number of processors. The WALL time, is the "Wall clock" time and is the total run time, including time taken reading and writing to disk. You can also deduce it from the start and end times of the calculation:
     ```
     0_start % grep -e "starts on" -e "terminated on" pw.out     
     Program PWSCF v.6.7MaX starts on 29Oct2025 at 10: 7:20 
     This run was terminated on:  10: 7:20  29Oct2025    
     ```
     
     * The number of planewaves in the basis set
     This information is found in these lines:
     ```
     G-vector sticks info
     --------------------
     sticks:   dense  smooth     PW     G-vecs:    dense   smooth      PW
     Sum        2917    2917    725               118265   118265   14771
     [...]
     Dense  grid:    59133 G-vectors     FFT dimensions: (  64,  64,  64)
     ```
     The number of planewaves needed to expand the _wavefunctions_ is 14771, while 59133 = 14771*4 is the number needed to expand the _charge density_.

     * The number of points in the FFT grid
     `Dense  grid:    59133 G-vectors     FFT dimensions: (  64,  64,  64)`
     Our cubic cell in real space is described by a grid of 64x64x64.

     * The real-space resolution
     Since the box length is 8A, the resolution in real space is 8A/64 = 0.125A, i.e. about 1/8 the length of the H-O bond.
     This resolution is determined by `ecutwfc`, and needs to be tested (see the next tutorial).

     Do any of these values surprise you? 


     That's the basic idea! Next, let's run the calculation properly, and compute some observable quantities.
