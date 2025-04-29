# Convergence over cell size

In this exercise we will determine the size of supercell needed to remove, or adequately reduce, any interactions between the repeated images (molecules) in adjacent cells. In other words, we will increase the vacuum spacing around the molecules until some physical quantities converge to a constant value.

Once a large enough vacuum is used, quantities such as the bond length, HOMO-LUMO gap, binding energy, ionization potential, total energy, etc, should not vary if we further increase the the cell size: what observable parameter we monitor depends on what we want to compute.

# Purpose
  1. Converge the total energy and forces with cell size
  2. Investigate how some observables can change with cell size.

## Running the exercise
  1. Let's test three values of the cell parameter: 5, 10, and 15 A. We start with a small cell size. Change the cell parameters to 5 A.
     ```
     % cat co.scf.in
     [...]
     CELL_PARAMETERS {angstrom}
     5.0  0.0  0.0
     0.0  5.0  0.0
     0.0  0.0  5.0
     % pw.x < co.scf.in > co.scf.out
     ```
     Use grep to extract the total energy, total force, and HOMO/LUMO levels from the output file.
     ```
     % grep -e !  -e "Total force" -e "highest" co.scf.out 
          highest occupied, lowest unoccupied level (ev):    -7.7979   -0.5526
     !    total energy              =     -43.26290842 Ry
     Total force =     0.062036     Total SCF correction =     0.000336
     ```

  2. Calculate also the average electrostatic potential along the direction of the C-O axis (see the graphene tutorial for details).
     ```
     % pp.x < co.pp.in > co.pp.out
     % average.x < co.avg.in > co.avg.out
     % mv avg.dat co.avg.dat_size5

  3. Repeat steps 1 and 2 for 10 and 15 A cell size. Prepare a table like so:
     ```
     #Cell Etot Ftot Gap IP
     5     -    -    -   -
     10    -    -    -   -
     15    -    -    -   -
     ```
     in which you input the total energy, total force, HOMO-LUMO gap, and ionization potential (roughly equal to Evac-HOMO; Expt is 14.0eV).

     Plot also the electrostatic potential for the three cell sizes. 

     Identify a minimum value for the cell size and intermolecular distance.

  4. Alternatively, run the two scripts in the Scripts folder to scan a larger set of values.

     ```
     % ./run_cellsize
     % ./run_plots
     ```

     ![bond vs size](Ref/Etot_vs_cell.dat.png?raw=true "potential vs cell size")
     ![bond vs size](Ref/Force_vs_cell.dat.png?raw=true "potential vs cell size")
     ![bond vs size](Ref/Gap_vs_cell.dat.png?raw=true "potential vs cell size")
     ![bond vs size](Ref/Pot_vs_cell.dat.png?raw=true "potential vs cell size")

