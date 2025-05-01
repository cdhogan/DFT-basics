# Carbon monoxide (2_CO)
This tutorial illustrates how to run a calculation for a zero-dimensional system (molecule/quantum-dot).  
Follow the exercises from the sub-folders in numerical order.

## Running the exercise
  Enter each sub-directory in numerical order, and follow the detailed instructions in each README file.
  - [0_cutoff](0_cutoff) 
    - Convergence with respect to the kinetic energy cutoff
  - [1_cellsize](1_cellsize) 
    - Convergence with respect to the cell size (vacuum)
  - [2_relax](2_relax) 
    - Compute the equilibrium bond length in the CO molecule
  - [2_binding](2_binding)
    - Compute the binding energy of the CO molecule
    - Understand how to treat orbital occupation correctly in an open shell atom
  - [3_HomoLumo](3_HomoLumo)
    - Visualize the HOMO and LUMO of the CO molecule 
    - Investigate the orbital character as a function of cell size
  - [4_LennardJones](4_LennardJones) 
    - Use a Lennard-Jones like potential to fit the Energy vs Bond length curves
  - [5_project_states](5_project_states) 
    - Project the molecular states onto atomic orbitals
  - [OLD_0_cellsize](OLD_0_cellsize) 
    - Run a relax calculation for a molecule and visualize the output using xcrysden
    - Plot the electrostatic potential in the cell
    - Converge the bond length with the cell size
    - Test convergence of other properties with cell size
  - [OLD_2_relax](OLD_2_relax)
    - Converge the geometry with the kinetic energy cutoff
