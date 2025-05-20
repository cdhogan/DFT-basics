# Chemical bonding analysis: charge and potential

### Electrostatic potential

Note the potential in the vacuum!

### Charge density difference

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
      32    8.091618    8.091618   11.088886    2.080497     0.649342    80.792968
   [...]
      36   13.479400   13.479400   11.633543    2.978900     2.426442   433.333846
      37    8.091618    8.091618   14.260430    7.629474     2.176960  1904.246603    <- O
       --------------------------------------------------------------------------------
       VACUUM CHARGE:               0.0000
       VACUUM VOLUME:               0.0000
       NUMBER OF ELECTRONS:       113.9994
    ```
    O is 37, the Al underneath is 32
    

