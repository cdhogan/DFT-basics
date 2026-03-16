# Setting up the geometry

In this exercise we will learn the various ways to define a crystal geometry with quantum-ESPRESSO.

To follow the exercises you should open the Documentation page at https://www.quantum-espresso.org/Doc/INPUT_PW.html and inspect the variables (and their options)
* &SYSTEM NAMELIST: 'ibrav' (and associated v1,v2,v3), 'celldm', 'A, B, C', 'nat' 
* CELL_PARAMETERS CARD: {options} v1, v2, v3
* ATOMIC_POSITIONS CARD: {options} X, x, y, z

We will start with the supplied file 'Si-PRIM.scf.in'. This is a standard input for silicon in the diamond crystal structure, which is composed of an FCC primitive cell and a 2-atom basis. 

```
% cat si-PRIM.scf.in
[...]
&SYSTEM
  ibrav     = 2,                        
  A         = 5.40                      
  nat       = 2,                                           
/
ATOMIC_POSITIONS {crystal}
 Si 0.00 0.00 0.00
 Si 0.25 0.25 0.25
[...]
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

> [!NOTE]
> In the output file you will see defined a quality called "alat". This is an _internal_ parameter that acts just as scaling factor (with units of distance). It usually corresponds to the bulk lattice constant, but it can also be  e.g. a supercell lattice parameter, or a surface cell lattice parameter, etc. 
>
> If ibrav > 0, specify EITHER 
> - Scheme 1	[ celldm(1)-celldm(6) ]			bohr units, alat := celldm(1) 
> - Scheme 2	[ A, B, C, cosAB, cosAC, cosBC ]	Angstrom, alat := A 


## Running the exercises

For each section A--L below, create a new input file called si-X.scf.in, where X is the section letter (si-A.scf.in etc). Start by copying si-PRIM.scf.in to si-X.scf.in, unless otherwise indicated.

```
% cp si-PRIM.scf.in si-A.scf.in
% vi si-A.scf.in		[or gedit, or nano, or your favourite editor ]
% xcrysden --pwi si-A.scf.in
```
In each case, view your new input files with xcrysden to check it looks ok, and run a basic calculation. Extract the total energy.
```
% pw.x < si-A.scf.in > si-A.scf.out
% grep ! si-A.scf.out
```

## Exercises: standard cell

### A - CELL_PARAMETERS
Task: Do not use the Bravais lattice definition, but define the cell axes explicitly in CELL_PARAMETERS.
- Start from (PRIM)
- ibrav = 0
- define the FCC lattice vectors using the definitions for "ibrav=2" in https://www.quantum-espresso.org/Doc/INPUT_PW.html 
- cell parameters: cartesian, in units of alat
- atom coordinates: fractional coordinates

```
% cp si-PRIM.scf.in si-A.scf.in
% vi si-A.scf.in     [or gedit, or nano, ... ]
% pw.x < si-A.scf.in > si-A.scf.out
% grep ! si-A.scf.out
```

> [!TIP]
> If ibrav=0 specify the lattice vectors directly in CELL_PARAMETERS. 
> These are cartesian vectors, and can be written in bohr, in Angstom, or scaled by a previously defined "alat". 
>
> The format is:
> ```
> CELL_PARAMETERS {alat | bohr | angstrom}
> v1(1)  v1(2)  v1(3)
> v2(1)  v2(2)  v2(3)
> v3(1)  v3(2)  v3(3)
> ```

### B - ALAT UNITS
Task: Define the lattice constant in bohr.
- Start from (PRIM) 
- Use celldm instead of A, B, C.
- ibrav = 2
- atom coordinates: fractional coordinates

```
% cp si-PRIM.scf.in si-B.scf.in
% vi si-B.scf.in
% pw.x < si-B.scf.in > si-B.scf.out
[etc]
```
> [!TIP]
> If ibrav > 0, specify EITHER 
> Scheme 1	[ celldm(1)-celldm(6) ]			bohr units, alat := celldm(1) 
> Scheme 2	[ A, B, C, cosAB, cosAC, cosBC ]	Angstrom, alat := A 


### C - CELL UNITS
Task: Define the lattice vectors in bohr.
- Start from (A)
- ibrav = 0
- atom coordinates: fractional coordinates

```
% cp si-A.scf.in si-C.scf.in
% vi si-C.scf.in
% pw.x < si-C.scf.in > si-C.scf.out
```

### D - BASIS
Task: Change the 2-atom basis. Set the origin to be at the midpoint of the Si-Si bond.
- Start from (PRIM) 
- atom coordinates: fractional coordinates

### E - ATOM ANGSTROM
Task: Define the atomic positions in cartesian coordinates, unit of angstrom.
- Start from (PRIM)
- atom coordinates: angstrom, cartesian

### F - ATOM ALAT
Task: Define the atomic positions in cartesian coordinates, unit of alat
- Start from (PRIM)
- atom coordinates: alat, cartesian

> [!NOTE]
> How do the total energies compare? Explain any discrepancies.


## Exercises: supercells

In the remaining section we will define some supercells to represent the Si crystal.
![Supercells](Ref/cells2.png?raw=true "Supercells")

In some cases we will use the handy `atomsk` program https://atomsk.univ-lille.fr/

### G - CONV CELL
Task: Build a conventional 8 atom unit cell of diamond silicon.
- Start from (PRIM) 
- build coordinates by hand or using xcrysden (use ATOMS INFO)
- use an appropriate ibrav (do not use 0)
- atom coordinates: fractional coordinates

Compare the total energy and the timing.

### I - CONV ATOMSK
Task: Build a conventional 8 atom cell using the atomsk program.
- Start from (A)
- Use `atomsk` to create from scratch a diamond unit cell for Si, with atoms in fractional coordinates, to a file format "pw".
```
% atomsk --create diamond 5.40 Si -fractional pw
```
The output is a very basic QE input file called "Si.pw".
- Extract the useful information from Si.pw and insert into si-I.scf.in

### J - SUPERCELL ALAT
Task: Build a 2x1x1 supercell of the conventional unit cell.
- Start from (I)
- Put the atom positions in units of alat, cartesian coordinates.
- Put the cell vectors in units of alat
- Check with xcrysden it looks right. Then define a 2x1x1 cell, and check again.
- Create a second cell of atoms from the first by shifting the positions using awk (or do by hand).
- cell parameters: cartesian, in units of alat
- atom coordinates: cartesian, in units of alat

### K - SUPERCELL ATOMSK
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

### L - ROTATE
Task: Build a conventional cell of Si such that a1 is along [110].
- Start from (I)
- Use atomsk to create from scratch a diamond unit cell for Si, with atoms in fractional coordinates, to a file format "pw".
```
% atomsk --create diamond 5.40 Si -rotate z 45 -fractional pw
```
- cell parameters: cartesian, in units of angstrom
- atom coordinates: fractional

It is enough to change only the cell vectors! Why?

Compare with the geometry created:
```
% atomsk --create diamond 5.40 Si -fractional -rotate z 45 pw
```
### Results
Your results should look something like this:
```
# task  nat     SymOps  Etot(Ry)        Etot(Ry/atom)   time(s)
PRIM    2       48      -15.84753139    -7.9237656950   0.15s
A       2       48      -15.84753139    -7.9237656950   0.13s
B       2       48      -15.84752967    -7.9237648350   0.13s
C       2       48      -15.84753146    -7.9237657300   0.14s
D       2       48      -15.84753139    -7.9237656950   0.13s
E       2       48      -15.84753139    -7.9237656950   0.14s
F       2       48      -15.84753139    -7.9237656950   0.14s
G       8       24      -63.39012605    -7.9237657562   0.39s
I       8       24      -63.39012607    -7.9237657587   0.37s
J       16      8       -126.78162396   -7.9238514975   2.78s
K       16      8       -126.78162396   -7.9238514975   2.79s
L       8       8       -63.39012606    -7.9237657575   0.55s
```

Note the way the number of symmetries found by the code reduces with the number of atoms. Is this expected? See the error message in the output:
```
     Found symmetry operation: I + (  0.2500 -0.5000  0.0000)
     This is a supercell, fractional translations are disabled
     Message from routine setup:
     using ibrav=0 with symmetry is DISCOURAGED, use correct ibrav instead
```
