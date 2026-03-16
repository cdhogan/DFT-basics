# Setting up the geometry

In this exercise we will learn the various ways to define a crystal geometry with quantum-ESPRESSO.

To follow the exercises you should open the Documentation page at https://www.quantum-espresso.org/Doc/INPUT_PW.html and inspect the variables (and their options)
* NAMELIST &SYSTEM: 'ibrav' (and associated v1,v2,v3), 'celldm', 'A, B, C', 'nat' 
* CARD CELL_PARAMETERS: {options} v1, v2, v3
* CARD ATOMIC_POSITIONS: {options} X, x, y, z

We will start with the supplied file 'Si-PRIM.scf.in'. This is a standard input for silicon in the diamond crystal structure, which is composed of an FCC primitive cell and a 2-atom basis. 

```
% cat si-PRIM.scf.in
% xcrysden --pwi si-PRIM.scf.in
% pw.x < si-PRIM.scf.in > si-PRIM.scf.out
% grep ! si-PRIM.scf.out
```

Using xcrysden, you can view the conventional cell and a reduced cell, and by selecting Display > Conventional cell mode (F4) you can see the primitive cell/axes. (Programs like xcrysden and vesta tend to add the equivalent atoms at the cell edge).

![Conventional and primitive cells](Ref/cells.png?raw=true "Conventional and primitive cells")

Let's summarize the input file parameters:
PRIM - standard 2 atom cell
- ibrav = 2
- lattice constant: angstrom
- atoms: fractional coordinates

** Running the exercises

For each section A--L below, create a new input file called si-X.scf.in, where X is the section letter (si-A.scf.in etc). Start by copying si-PRIM.scf.in to si-X.scf.in, unless otherwise indicated.

```
% cp si-PRIM.scf.in si-A.scf.in
% vi si-A.scf.in		[or gedit, or nano, or ... ]
% xcrysden --pwi si-A.scf.in
```
In each case, view your new input files with xcrysden to check it looks ok, and run a basic calculation. Extract the total energy.
```
% pw.x < si-A.scf.in > si-A.scf.out
% grep ! si-A.scf.out
```

** Exercises: standard cell

A - CELL_PARAMETERS
Task: Do not use the Bravais lattice definition, but define the cell axes explicitly in CELL_PARAMETERS.
- Start from (PRIM)
- ibrav = 0
- define the FCC lattice vectors using the definitions for "ibrav=2" in INPUT_PW.html
- cell parameters: cartesian, in units of alat
- atom coordinates: fractional coordinates

B - ALAT UNITS
Task: Define the lattice constant in bohr.
- Start from (PRIM) 
- Use celldm instead of A, B, C.
- ibrav = 2
- atom coordinates: fractional coordinates

C - CELL UNITS
Task: Define the lattice vectors in bohr.
- Start from (A)
- ibrav = 0
- atom coordinates: fractional coordinates

D - BASIS
Task: Change the 2-atom basis. Set the origin to be at the midpoint of the Si-Si bond.
- Start from (PRIM) 
- atom coordinates: fractional coordinates

E - ATOM ANGSTROM
Task: Define the atomic positions in cartesian coordinates, unit of angstrom.
- Start from (PRIM)
- atom coordinates: angstrom, cartesian

F - ATOM ALAT
Task: Define the atomic positions in cartesian coordinates, unit of alat
- Start from (PRIM)
- atom coordinates: alat, cartesian

Q. How do the total energies compare? Explain any discrepancies.

> [!TIP]
> How do the total energies compare? Explain any discrepancies.


** Exercises: supercells

In the remaining section we will define some supercells to represent the Si crystal.
![Supercells](Ref/cells2.png?raw=true "Supercells")

In some cases we will use the handy 'atomsk' program https://atomsk.univ-lille.fr/

G - CONV CELL
Task: Build a conventional 8 atom unit cell of diamond silicon.
- Start from (PRIM) 
- build coordinates by hand or using xcrysden (use ATOMS INFO)
- use an appropriate ibrav (do not use 0)
- atom coordinates: fractional coordinates

Compare the total energy and the timing.

I - CONV ATOMSK
Task: Build a conventional 8 atom cell using the atomsk program.
- Start from (A)
- Use 'atomsk' to create from scratch a diamond unit cell for Si, with atoms in fractional coordinates, to a file format "pw".
```
% atomsk --create diamond 5.40 Si -fractional pw
```
- Extract the useful information from Si.pw and insert into si-I.scf.in

J - SUPERCELL ALAT
Task: Build a 2x1x1 supercell of the conventional unit cell.
- Start from (I)
- Put the atom positions in units of alat, cartesian coordinates.
- Put the cell vectors in units of alat
- Check with xcrysden it looks right. Then define a 2x1x1 cell, and check again.
- Create a second cell of atoms from the first by shifting the positions using awk (or do by hand).
- cell parameters: cartesian, in units of alat
- atom coordinates: cartesian, in units of alat

K - SUPERCELL ATOMSK
Task: Build a 2x1x1 supercell using atomsk.
- Start from (J)
- Use atomsk to create from scratch a diamond unit cell for Si, with atoms in fractional coordinates, duplicate along x, to a file format "pw".
```
% atomsk --create diamond 5.40 Si -duplicate 2 1 1 -fractional pw
```
- cell parameters: cartesian, in units of angstrom
- atom coordinates: fractional

> [!TIP]
> Which set of atom coordinates is easier to work with, when using supercells?

L - ROTATE
Task: Build a conventional cell of Si such that a1 is along [110].
- Start from (I)
- Use atomsk to create from scratch a diamond unit cell for Si, with atoms in fractional coordinates, to a file format "pw".
```
% atomsk --create diamond 5.40 Si -rotate z 45 -fractional pw
```
- cell parameters: cartesian, in units of angstrom
- atom coordinates: fractional

It is enough to change only the cell vectors! Why?

Compare with this:
```
% atomsk --create diamond 5.40 Si -fractional -rotate z 45 pw
```

