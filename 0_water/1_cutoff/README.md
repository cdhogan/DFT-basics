# Convergence of the basis set (kinetic energy cutoff)

In quantum-ESPRESSO, and other codes that use plane-waves as a basis set (e.g. VASP,Abinit,Castep), the (pseudo-) wavefunction is expanded over a set of plane-waves (G-vectors):


In principle one should use an infinite number of G-vectors. In practice, one truncates this expansion at some point.
How many G-vectors are needed depends on many factors, including:
* What elements are present (heavy/light/d-shells, etc)
* The pseudopotential choice (number of electrons in valence, etc)
* What precision is required (what are you calculating?)
* The computational cost (what resources do you have?)

Determining this cut-off point is a crucial first step in any DFT calculation.

While we could test convergence of the basis set in terms of the number of G-vectors,
it is more common (and useful) to talk in terms of energy - specifically, the kinetic energy. 
The reason is that, for the same required precision, the same energy cutoff can be specified 
even if the cell size changes.

For a wavefunction defined as above, the kinetic energy term in the Kohn-Sham equation is (demonstrate this!):


Thus, we will perform convergence tests over the kinetic energy cutoff `ecutwfc`.

# Outline
  1. Converge the kinetic energy cutoff with respect to total energy
  2. Converge the kinetic energy cutoff with respect to some observable
  3. Understand the cutoff vs G-vector relation
  4. Test of H2O2, or of O2 and H2.

## Running the exercise

  1. We take again our H2O.scf.in input file. Remember, the geometry is still only a guess. 

      Now run the calculation, redirecting the output to a file:
      ```
      % pw.x < H2O.scf.in > H2O.scf.out
      ```
      or to use multiple processors, if quantum-espresso has been compiled in parallel
      ```
      % mpirun -np 2 pw.x < H2O.scf.in > H2O.scf.out
      ```


  3. Repeat step 1 and change each time the value of `ecutwfc` from 10 up to 100 Ry in steps of 10 Ry and the name of the output (so as to not overwrite them)
      ```
      % pw.x < H2O.scf.in > H2O.scf.out_10Ry
      ```
      Modify (edit) the `H2O.scf.in` file and change `ecutwfc = 10` to `ecutwfc = 20`
      ```
      % pw.x < H2O.scf.in > H2O.scf.out_20Ry
      ```
      You can also make this change directly to the original input file using the `sed` command:
      ```
      sed -e 's/10/20/' H2O.scf.in
      % grep ecutwfc H2O.scf.in
      ecutwfc   = 20,
      ```
      Repeat for 10,20,30...100 Ry.
      ```
      [...]
      % pw.x < H2O.scf.in > H2O.scf.out_100Ry
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
     For what cutoff do you think the total energy is converged?

  5. Let's check.








     Carry out a series of SCF runs, modifying the value of `ecutwfc` each time, Use a script to scan progressively higher values of cut off:

     ```
     % ./Scripts/run_ecut
     ```
     Let's plot the convergence with total energy and with respect to the HOMO-LUMO gap.
     ![Etot vs cutoff](Ref/Etot_vs_Ecut.dat.png?raw=true "Etot vs Ecut")
     ![gap vs cutoff](Ref/Gap_vs_Ecut.dat.png?raw=true "Gap vs Ecut")

     A cutoff of 70Ry seems well converged. In the rest of the tutorial we will use 60Ry to speed things up.


The cutoff will be determined by the 'hardest' pseudopotential used, it could be the O or the H. 
