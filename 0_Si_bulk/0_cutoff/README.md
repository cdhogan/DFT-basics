# Convergence on the kinetic energy cutoff
QE expands the wavefunctions on a plane wave (PW) basis set.
As with any basis set, an infinite number of functions is required to perfectly represent the original function.
We need to limit the number of PW to the smallest number that represents our system accurately.

  1. Look at the provided input file for bulk silicon and visualize it with `Xcrysden`. A brief explanation of variables is given in the file. Complete details are given on the [QE website](https://www.quantum-espresso.org/Doc/INPUT_PW.html).
      ```
      % cat si.scf.in
      % xcrysden --pwi si.scf.in
      ```
      Now run the calculation, redirecting the output to a file:
      ```
      % pw.x < si.scf.in > si.scf.out
      ```
      or to use multiple processors, if quantum-espresso has been compiled in parallel
      ```
      % mpirun -np 2 pw.x < si.scf.in > si.scf.out
      ```
  2. Look at the information presented on the output file 
      - A header containing information of the version of espresso used
      - A recap on the information of the system
      - A list of matrix representation of the symmetries of the system + the character table of the symmetries
      - The list of the points in k-space used
      - The information on each self-consistent iteration
      - The eigenvalues and occupations for the requested Kohn-Sham states at every k-point
      - The total energy marked by a ! ( as a sum of different contributions)
      - The forces acting on the atoms (should be 0 for a system at the equilibrium)
      - Information on the total time and time for each subroutine. Note that QE often uses Rydberg and bohr atomic units: 1 Ry = 13.6057eV, 1 bohr = 0.529177 Angstrom.
  3. Repeat step 1 and change each time the value of `ecutwfc` from 5 up to 30 Ry and the name of the output (so as to not overwrite them)
      ```
      % pw.x < si.scf.in > si.scf.out_5Ry
      ```
      Modify (edit) the `si.scf.in` file and change `ecutwfc = 5` to `ecutwfc = 10`
      ```
      % pw.x < si.scf.in > si.scf.out_10Ry
      ```
      You can also make this change directly to the original input file using the `sed` command:
      ```
      % sed -e 's/ecutwfc   = 5/ecutwfc   = 10/' si.scf.in > si.scf.in_10Ry
      % grep 'ecutwfc' si.scf.in_10Ry 
      ecutwfc   = 10,
      % pw.x < si.scf.in_10Ry > si.scf.out_10Ry
      ```
      Repeat for 15,20,25 and 30 Ry.
      ```
      [...]
      % pw.x < si.scf.in > si.scf.out_30Ry
      ```
  4. Use grep to print out the total energies from all files in one command using the wildcard *
      ```
      % grep -e '!' *out*Ry
      si.scf.out_10Ry:!    total energy              =     -15.77444885 Ry
      [...]
      ```
     Copy and paste the cutoff energies and total energies into a 2 column file (Ecut,Etot) called 'Etot_vs_Ecut.dat' and plot it to see if you have reached convergence. 
     ```
     gnuplot> plot "Etot_vs_Ecut.dat" w l
     ```
     To the eye, the total energy looks well converged at 30 Ry. This is misleading however, as it simply depends on the energy range of your plot - see the logscale plot on the right. The correct threshold to use depends on what quantity (observable) you want to compute: a bond length, a lattice parameter, an energy gap, a binding energy, an STM image, a vibrational frequency...and to what precision you want!

     Here are some rough guidelines on convergence (not for production/publication!):
     * Total energy: 1 mRy/atom = 13.6 meV/atom (0.1 mRy/atom is better)
     * Bond length: 0.002 Å
     * Cell parameters: 0.01 Å
     * Energy differences: 0.37 mRy/atom = 5 meV/atom (0.1 mRy/atom is better)
     * Forces: 10 meV/Å
     
     _NB: you must ALWAYS perform convergence tests yourself for your system!!_

     
     ![Total energy vs kinetic energy cutoff](Ref/Etot_vs_Ecut.png?raw=true "Total energy vs kinetic energy cutoff")

     If the plot doesn't look right, make sure you have used the right cutoff in the appropriate input and output files:
     ```
     % grep 'kinetic-energy cutoff' si.scf.out_25Ry 
     kinetic-energy cutoff     =      25.0000  Ry
     % grep 'ecutwfc' si.scf.in_25Ry 
     ecutwfc   = 25,
     ```

  6. Use grep on each file to extract the eigenvalues of the highest occupied and lowest unoccupied bands, and compute the band gap using the 'bc -l' program
      ```
      % grep -e 'highest' *out*Ry 
      si.scf.out_5Ry:     highest occupied, lowest unoccupied level (ev):     6.0229    7.5083
      % bc -l
      bc 1.06
      Copyright 1991-1994, 1997, 1998, 2000 Free Software Foundation, Inc.
      This is free software with ABSOLUTELY NO WARRANTY.
      For details type `warranty'. 
      7.5083-6.0229 
      1.4854
      quit
      ```
     Save the energies in a 4 column file (Ecut, VBM, CBM, gap) called 'Gap_vs_Ecut.dat' and plot them versus the cutoff. How does the convergence compare with the value expected from the total energy run?
     ![Eigenvalues and gap vs kinetic energy cutoff](Ref/Gap_vs_Ecut.png?raw=true "Gap vs kinetic energy cutoff")
  7. ADVANCED USERS: The shell scripts 'run_ecut' and 'run_plots' in the 'Script' directory will do everything automatically from step 3 to 5 (explained using comments inside the script). You may first have to modify the ENVIRONMENT_VARIABLES file in the root directory. The scripts must be run from the main 0_cutoff directory (or copied there). Hit 'q' to cycle through plot windows as they appear. Inspect the PDFs or PNGs that are created.
      ```
      ./Script/run_ecut
      ./Script/run_plots
      ```
      NB: Do not use the scripts for your own projects unless you understand well how they work!
      
### When you have completed this tutorial, you can move on to [1_kpoints: Convergence with k-points](../1_kpoints)
