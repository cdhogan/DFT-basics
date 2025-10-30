# Convergence of the basis set (kinetic energy cutoff)

In quantum-ESPRESSO, and other codes that use plane-waves as a basis set (e.g. VASP,Abinit,Castep), the (pseudo-) wavefunction is expanded over a set of plane-waves (G-vectors):

<img src="Ref/basis.png" height="80"/>

In principle one should use an infinite number of G-vectors. In practice, one truncates this expansion at some point, by including G-vectors up to some **|Gmax|**. However, instead of working in terms of **|Gmax|**, it is more useful to talk in terms of energy - specifically, the _kinetic energy_. 
The reason is that, for the same required precision, the same energy cutoff can be specified even if the cell size changes.

Using the expression for the kinetic energy of a planewave with wavevector |k+G| (you should be able to derive this!), we define the cutoff as the following:  

<img src="Ref/cutoff.png" height="80"/>

whereby we keep all G-vectors that satisfy this expression.
In quantum-ESPRESSO, this Ecut is determined by the parameter `ecutwfc`. 

Thus, we need to perform convergence tests to find an appropriate value of `ecutwfc`.
Determining this cut-off point is a crucial **first step** in any DFT calculation.

What cutoff to use depends on many factors, including:
* What elements are present (heavy/light/d-shells?)
* The pseudopotential choice (how many valence electrons?)
* What precision is required (what are you calculating?)
* The computational cost (what resources do you have?)


## Outline
1. Converge the kinetic energy cutoff with respect to the total energy
2. Converge the kinetic energy cutoff with respect to some observable
3. Understand the cutoff vs G-vector relation

## Running the exercise

1. We take again our H2O.scf.in input file. Remember, the geometry is still only a guess: nonetheless, it does not affect the following convergence study. In this file, the cutoff is set to a starting value of 10Ry.

Run the SCF calculation, redirecting the output to a file:
```
% pw.x < H2O.scf.in > H2O.scf.out_10Ry		[or]
% mpirun -np 2 pw.x < H2O.scf.in > H2O.scf.out_10Ry
```
2. Repeat step 1 and change each time the value of `ecutwfc` from 10 up to 100 Ry in steps of 10 Ry. 

Modify (edit with `vi` or your preferred editor) the 'H2O.scf.in' file and change `ecutwfc = 10` to `ecutwfc = 20`.

You can also make this change directly to the original input file using the `sed` command to replace the first occurrence of '10' with '20':
```
sed -e 's/10/20/' H2O.scf.in
```
Run the calculation, making sure to change the name of the _output_ file each time (so as to not overwrite it).
```
% pw.x < H2O.scf.in > H2O.scf.out_20Ry
```
Repeat for 10,20,30...100 Ry.
```
[...]
% pw.x < H2O.scf.in > H2O.scf.out_100Ry
```

### Analyse the total energy

3. Use `grep` to extract the final total energy from all files in one command using the wildcard *
```
% grep -e '!' *out*Ry
H2O.scf.out_10Ry:!    total energy              =     -15.77444885 Ry
H2O.scf.out_20Ry:!    total energy              =     -15.97444885 Ry
[...]
```
Copy and paste the cutoff energies and total energies into a 2 column file (Ecut,Etot) called 'Etot_vs_Ecut.dat' and plot it to see if you have reached convergence.
```
gnuplot> plot "Etot_vs_Ecut.dat" w l
```
<img src="Ref/Etot_vs_Ecut-script.dat.png" height="600"/>

At what cutoff do you think the total energy is converged? You might say "70Ry" based on where the graph _looks_ flat. But it's not flat! The total energy decreases monotonically with the cutoff (i.e. as the basis set gets more complete). You can see this in the log plot on the right. 

So, you should decide on some numerical threshold. 1mRy? 1meV? Per atom, or per formula unit? It's hard to say.

### Analyse the electronic properties

4. Instead of focusing on the total energy - an esoteric quantity! - let's look at the HOMO-LUMO gap instead as a function of `ecutwfc`.


<img src="Ref/Gap_vs_Ecut-script.dat.png" height="600"/>






     Carry out a series of SCF runs, modifying the value of `ecutwfc` each time, Use a script to scan progressively higher values of cut off:

     ```
     % ./Scripts/run_ecut
     ```
     Let's plot the convergence with total energy and with respect to the HOMO-LUMO gap.
     ![Etot vs cutoff](Ref/Etot_vs_Ecut.dat.png?raw=true "Etot vs Ecut")
     ![gap vs cutoff](Ref/Gap_vs_Ecut.dat.png?raw=true "Gap vs Ecut")

     A cutoff of 70Ry seems well converged. In the rest of the tutorial we will use 60Ry to speed things up.


The cutoff will be determined by the 'hardest' pseudopotential used, it could be the O or the H. 
