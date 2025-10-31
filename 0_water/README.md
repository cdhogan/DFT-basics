# Water molecule (0_water)

In this first tutorial we consider a simple and familiar system: the water (H2O) molecule. 

We will show how to run simple input files to compute the geometry and ground state electronic properties of H2O using quantum-ESPRESSO.

<img src="water_intro.png" height="200"/>

## Running the exercise
  Enter each sub-directory in numerical order, and follow the detailed instructions in each README file.
  - [0_start](0_start)
    - View an input file for a molecule in a box
    - Visualize the system with xcrysden
    - Run a self-consistent calculation using pw.x
    - Understand the output
  - [1_cutoff](1_cutoff)
    - Converge the kinetic energy cutoff for total energy and HOMO-LUMO gap
    - Scaling with G-vectors
  - [2_geometry](2_geometry)
    - Optimize the geometry of H2O
    - Converge the cutoff for the geometry
    - Constrained geometry optimization
  - [3_charge_density](3_charge_density)
    - Calculate and visualize the charge density
    - Calculate the dipole moment and vacuum level
  - [4_electronic_states](4_electronic_states)
    - Plot the energy levels and electronic states of H2O
    
## Documentation
  1. Follow the detailed instructions in the README files
  2. Input files for quantum-ESPRESSO are described in 
     - [INPUT_PW](https://www.quantum-espresso.org/Doc/INPUT_PW.html) 
     - [INPUT_PP](https://www.quantum-espresso.org/Doc/INPUT_PP.html) 
     - [everything else](https://www.quantum-espresso.org/resources/users-manual/input-data-description)

