# Chemical bonding analysis: charge and potential

### Electrostatic potential

Use pp.x and average.x to investigate the electrostatic potential in the Al(001)/O supercell. Note the potential in the vacuum!

### Charge density difference

This is a very powerful technique for analysing and understanding bonding.

<img src="Ref/CDD.png" height="80"/>

It is based on calculating the charge densities of the relaxed Al(001)/O system and of the A(001) and O atom in the same frozen geometries they have in the Al(001)/O case. The latter are called "peeled-off" geometries.

For the difference calculation to work, the three calculations must be done in exactly the same way (cell, cutoff, k-points, etc).

What we can expect to find:

Top site:
- Charge depletion just above the Al atom.
- Charge accumulation between Al and O, suggesting covalent bonding (see adsorption energy).

Bridge or hollow site:
- Accumulation may appear between multiple Al atoms and O, indicating shared bonding.

Charge transfer direction:
- If electrons accumulate around O, and deplete near Al, this means O is accepting electrons from Al (expected for electronegative atoms like O).


1. Average plot

2. 3D plot

### Charge transfer and Bader charges

    We can use the `bader` code to compute the atomic charges.
    ```
    % pp.x < charge0.in 
    % pp.x < charge21.in 
    % bader charge0.cube -ref charge21.cube 
    % cat ACF.dat 
           #         X           Y           Z       CHARGE      MIN DIST   ATOMIC VOL
    --------------------------------------------------------------------------------
       1   16.183237   16.183237   43.155298    2.858544     2.377244   497.997653
       2   16.183237    5.394412   43.155298    2.971628     2.377255   501.735615
    [...]
      32    8.091618    8.091618   11.088886    2.080497     0.649342    80.792968    <- Al (top)
    [...]
      36   13.479400   13.479400   11.633543    2.978900     2.426442   433.333846
      37    8.091618    8.091618   14.260430    7.629474     2.176960  1904.246603    <- O
       --------------------------------------------------------------------------------
       VACUUM CHARGE:               0.0000
       VACUUM VOLUME:               0.0000
       NUMBER OF ELECTRONS:       113.9994
    ```
(O is #37, the Al underneath is #32).

Thus O has accepted 1.63 electrons from the surface, most of which is coming from the Al atom bonded to it.

