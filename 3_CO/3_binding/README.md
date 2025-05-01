# Binding energy
The binding energy is defined as the energy required to bring the atoms of a molecule to infinite distance from each other (non-interacting).

    ![Binding energy](Ref/BE_eqn.png?raw=true "Binding energy")

It can be accurately computed by calculating the total energy of the isolated atoms with respect to the total energy of the molecule. For CO, the experimental value is 11.108 (see Ref/binding.dat).

Atoms present a new problem - both oxygen and carbon are paramagnetic, and according to Hund's rule their electrons prefer to occupy states with parallel spin instead of filling up states with antiparallel configuration:

    ![Hunds rule](Ref/hunds_rule.png?raw=true "Hunds rule")

DFT calculations of a single atom in a large box is a somewhat pathological problem, and quite often one is faced by the dreaded:
   ```
   convergence NOT achieved after 100 iterations: stopping
   ```
Below we outline some strategies for handling paramagnetic spin.

In principle we could also continue our bond-length study until the atoms are far apart: this will give a valid estimate but will not be accurate, as DFT will struggle to properly handle the (different?) spin states of the separated atoms. See ../Lennard_Jones for an attempt.


# Purpose
  1. Calculate the binding energy of a molecule
  2. Run a spin polarized calculation for a paramagnetic system

# Running the exercise
  1. SCF input files for CO, O and C are provided in the respective directories. Notice that in each case the cells, cutoff, etc are identical. Let's start with a calculation for the CO molecule, using the parameters we found in the previous tutorials.
     ```
     % cd CO
     % pw.x < co.scf.in > co.scf.out
     ```
## Using smearing

  2. Let's try next the C atom. Start with a standard input file:
     ```
     % cd ../C
     % pw.x < c.scf.in      [without output redirection]
     ```
     As you can see, the calculation runs to 100 SCF iterations without converging.

     The easiest way to handle the convergence issue is to add a tiny amount of smearing, since the problem is related to the occupations: the code is trying to localize the 2p2 electron pair in one of the three 2p orbitals.
     ```
     % cat c.scf-smearing.in
     [...]
     occupations='smearing'
     degauss = 0.001
     [...]
     % pw.x < c.scf-smearing.in > c.scf-smearing.out
     ```
     Smearing allows the 2 electrons to distribute equally among these orbitals: 

     ```
          k = 0.0000 0.0000 0.0000 ( 26462 PWs)   bands (ev):

   -13.5140  -5.2916  -5.2916  -5.2916  -0.3319   1.2656

     occupation numbers 
     1.0000   0.3334   0.3334   0.3333   0.0000   0.0000

     the Fermi energy is    -5.2957 ev
     ```
     ![Occupations](Ref/occ_nospin.png?raw=true "Occupations")

     Clearly this is not consistent with the desired occupations, but at least we have a converged calculation and a total energy. Repeat this also for the oxygen atom and extract the total energies of the three systems.
     ```
     % cd ../O
     % pw.x < o.scf-smearing.in > o.scf-smearing.out
     % cd ../CO
     % pw.x < co.scf-smearing.in > co.scf-smearing.out
     % cd ../
     % grep ! */*scf-smearing.out
     C/c.scf-smearing.out:!   total energy = -10.69587460 Ry
     CO/co.scf-smearing.out:! total energy = -43.25079371 Ry
     O/o.scf-smearing.out:!   total energy = -31.39213466 Ry
     ```
     Thus we have a first estimate for the binding energy, 15.82 eV.

## Using nspin=2 and smearing

  3.  If we *don't* know the spin multiplicity (or don't care), we can activate the spin polarization with `nspin=2` and help the convergence, as above, with a small smearing. Since we allow spin polarization, we have to define some starting magnetization (otherwise the code will complain). 

      ```
      % cat c.scf-spin-smearing.in
      [...]
      nspin = 2
      occupations='smearing'
      degauss = 0.001
      starting_magnetization=0.1
      ```
      Let's run the 'spin-smearing' input files for the carbon and oxygen atoms. Look at the output file to see the changes. For carbon:
     % pw.x < c.scf-spin-smearing.in > c.scf-spin-smearing.out
      ```
       ------ SPIN UP ------------
                k = 0.0000 0.0000 0.0000 ( 26462 PWs)   bands (ev):
         -14.3912  -6.1163  -6.1163  -6.1162  -0.3217   1.2981
      
           occupation numbers
           1.0000   0.6697   0.6667   0.6637   0.0000   0.0000
      
       ------ SPIN DOWN ----------
                k = 0.0000 0.0000 0.0000 ( 26462 PWs)   bands (ev):
         -11.5436  -3.5017  -3.4989  -3.4949  -0.2051   1.3284

           occupation numbers
           1.0000   0.0000   0.0000   0.0000   0.0000   0.0000

           the Fermi energy is    -6.1121 ev
      !    total energy              =     -10.79193341 Ry
           total magnetization       =     2.00 Bohr mag/cell
           absolute magnetization    =     2.00 Bohr mag/cell
     ```
     ![Occupations](Ref/occ_smear.png?raw=true "Occupations")
     On the positive note, the system results to be paramagnetic, with the 2p2 electrons all in a spin-up state. The magnetization (difference in number of spin up and spin down electrons) is 2 Bohr magnetons, corresponding a total spin angular quantum number of S=1.

     The total energy is also considerably lower than for the first 'smearing' attempt.

     However, the two electrons are again smeared out across the three 2p orbitals.

     Repeating for C, O and (for completeness) CO, we obtain again a value for the binding energy.

     ```
     % cd ../O
     % pw.x < o.scf-spin-smearing.in > o.scf-spin-smearing.out
     % cd ../CO
     % pw.x < co.scf-spin-smearing.in > co.scf-spin-smearing.out
     % cd ../
     % grep ! */*scf-spin-smearing.out
     C/c.scf-spin-smearing.out:!   total energy = -10.79193341 Ry
     CO/co.scf-spin-smearing.out:! total energy = -43.25079381 Ry
     O/o.scf-spin-smearing.out:!   total energy = -31.50775784 Ry
     ```
     we obtain a better value for the binding energy of 12.940 eV.

## Using nspin=2 and fixed multiplicity

  4. As we actually know the desired multiplicity for both C and O atoms is a triplet state, we can contrain the final (total) magnetization which allows us to switch off the smearing (`occupations='fixed'`, which is anyway the default). 
     ```
     % cd C
     % cat c.scf-spin-triplet.in
     [...]
     nspin=2
     tot_magnetization=2
     occupations='fixed'
     [...]
     ```
     Let's run the 'spin-triplet' input files for the carbon atom. Look at the output file to see the changes. For carbon:
     % pw.x < c.scf-spin-triplet.in > c.scf-spin-triplet.out
     % cat c.scf-spin-triplet.out

      ------ SPIN UP ------------
     
               k = 0.0000 0.0000 0.0000 ( 26462 PWs)   bands (ev):
        -14.2724  -6.0604  -6.0600  -5.8822  -0.3079   1.3025
     
          occupation numbers  
          1.0000   1.0000   1.0000   0.0000   0.0000   0.0000   
     
      ------ SPIN DOWN ----------
     
               k = 0.0000 0.0000 0.0000 ( 26462 PWs)   bands (ev):
        -11.5582  -4.2697  -3.1185  -3.1179  -0.1974   1.3303   
     
          occupation numbers  
          1.0000   0.0000   0.0000   0.0000   0.0000   0.0000   
     
          highest occupied, lowest unoccupied level (ev):    -6.0600   -5.8822
     
     !    total energy              =     -10.79395348 Ry      
          total magnetization       =     2.00 Bohr mag/cell
          absolute magnetization    =     2.00 Bohr mag/cell
     ```
     ![Occupations](Ref/occ_triplet.png?raw=true "Occupations")
     As you can we, we finally obtain the correct orbital occupancy! The total energy is again lower, but oly slightly lower than for 'spin-smearing' technique.

     Repeat the calculation for oxygen and the CO molecule. In the latter case the multiplicity is singlet. 
     ```
     % pw.x < o.scf-spin-triplet.in > o.scf-spin-triplet.out
     % pw.x < co.scf-spin-singlet.in > co.scf-spin-singlet.out

     % grep ! */*let*
     C/c.scf-spin-triplet.out:!   total energy = -10.79395348 Ry
     O/o.scf-spin-triplet.out:!   total energy = -31.51731831 Ry
     CO/co.scf-spin-singlet.out:! total energy = -43.25079385 Ry
     ```
     We thus obtain a best theoretical value for the binding energy, of 12.783 eV. It is still higher than the experimental value of 11.108, which is due to our use of an LDA XC functional.

## Notes on atoms

  5. Instead of using the default `occupations='fixed'`, if a single k-point is used, you can set the occupations (and thus the multiplicity) of each level (band) explicitly with `occupations='from_input'` and the OCCUPATIONS card:
     ```
     % cat o.scf-spin-triplet-occ.in
     [...]
     nbnd  = 6,
     nspin = 2,
     occupations = 'from_input'
     [...]
     OCCUPATIONS
     1.0 1.0 1.0 1.0 0.0 0.0
     1.0 1.0 0.0 0.0 0.0 0.0
     ```
     See also the `one_atom_occupations` input variable.

  6. In the above exercises we ran the CO molecule with the same spin settings as the atoms. Since we are commputing a difference in energies, it is good practice to treat each system in exactly the same way, in case there are small errors or extra energetic contributions (e.g. from the smearing). However, the total energy for CO is almost identical for each run, since we have a large gap and a tiny smearing.
     ```
     CO/co.scf.out:              ! total energy = -43.25079371 Ry
     CO/co.scf-smearing.out:     ! total energy = -43.25079371 Ry
     CO/co.scf-spin-smearing.out:! total energy = -43.25079381 Ry
     CO/co.scf-spin-singlet.out: ! total energy = -43.25079385 Ry
     ```

  7. In some cases, the above tricks to find the correct multiplicity may fail, or the SCF loop may not converge. For instance, try modifying the 'spin-smearing' inputs for C and O in the following way:
     ```
     starting_magnetization=1.0
     ```
     For carbon, we obtain:
     ```
     occupation numbers 
     1.0000   1.0000   1.0000   1.0000   0.0000   0.0000
     0.0000   0.0000   0.0000   0.0000   0.0000   0.0000
     total magnetization       =     4.00 Bohr mag/cell
     ```
     and for oxygen:
     ```
     occupation numbers 
     1.0000   1.0000   1.0000   1.0000   0.0000   0.0000
     1.0000   1.0000   0.0000   0.0000   0.0000   0.0000
     total magnetization       =     2.00 Bohr mag/cell
     ```
     In other words, we obtain the correct multiplicity with 'spin-smearing' for O, but garbage for C. 

     Note that with 'starting_magnetization' you are applying a spin to ALL atomic levels (s+p), not just the one you want!

     Another trick that might work with smearing, if the spins are not ordering the way you want, is to break all symmetries in the input file. For instance:
     ```
     nosym=.true.
     CELL_PARAMETERS {angstrom}
     10.0  0.0  0.0
      0.0 11.0  0.0
      0.0  0.0 12.0
     ```
     can help the code break the px/py/pz degeneracy.

  8. Now that you appreciate the problems with treating isolated atoms, reconsider how you might compute the binding energy in a large cell by separating the C and O atoms. What kind of spin treatment would you use that will work for molecular CO and for the separated C and O atoms? 

## Advanced

  - Test the dependence in binding energy with the kinetic energy cutoff.
  - Try a different XC functional, such as PBE. Does it over- or under-estimate the BE?
