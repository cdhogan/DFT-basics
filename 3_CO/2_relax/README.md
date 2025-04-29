# Calculation of the CO bond length

In this tutorial we will compute the C-O bond length in three ways: by searching for a minimum in the total energy, and then the total force, as a function of bond length; and by using a geometry optimization algorithm.

## Running the exercise
  1. We start with the 'co.scf.in' file, which now contains the currect cutoff and cell parameters. Based on the expt. value for the bond length, 1.13A, let's scan a range of bond lengths +/-10%, i.e. from 1.0 to 1.3 A in steps of 0.05A, changing the x-coordinate of the C atom each time.
     ```
     % vi co.scf.in
     % pw.x < co.scf.in > co.scf.out_bond1.0
     ```
     Extract both the total energy and the total force each time, and make a table of data: bond, Energy, Force called, e.g. 'Etot_vs_bond.dat'.
     ```
     % grep -e !  -e "Total force" co.scf.out
     !    total energy              =     -43.26290842 Ry
     Total force =     0.062036     Total SCF correction =     0.000336
     ```

     You can save time (but learn nothing) by running the script, `Scripts/run_bond`.

  2. Plot the total energy and force as a function of the bond length, and look for a minimum. Which quantity do you think will be more useful?

     Regarding the total energy, you can try to fit the data near the minimum to a parabola. In gnuplot, the process is quite simple.
     ```
     gnuplot> f(x) = a*x**2 + b*x + c				<-- Define the function
     gnuplot> fit [1.05:1.25] f(x) 'Etot_vs_bond.dat' u 1:2 via a, b, c	<-- Fit in range [] 
     [...]
     Final set of parameters            Asymptotic Standard Error
     =======================            ==========================
     a               = 3.9868           +/- 0.3557       (8.921%)
     b               = -9.04387         +/- 0.8183       (9.048%)
     c               = -37.8638         +/- 0.4692       (1.239%)
     ```
     If the fit is successful, the parameters a,b,c are reported. Sometimes it helps to set some rough values to specific parameters in advance.
     
     Now you can plot the data again, and compare with the fit
     ```
     gnuplot> plot "Etot_vs_bond.dat" u 1:2 w lp,f(x) t "fit" 
     ```
     By inspection, or by running the script `Scripts/fit.gnu`, the minimum value of the fit can be found.
     ```
     r0(parabolic) =  1.1342268874859
     e0(parabolic) =  -42.9927279299405
     ```
    ![bond vs size](Ref/Etot_vs_bond_fit.png?raw=true "potential vs cell size")

  3. Regarding the forces, a simple plot will identify quickly the minimum:

    ![bond vs size](Ref/Force_vs_bond.dat.png?raw=true "potential vs cell size")

     
   4. Now let's look at the provided 'co.relax.in' file. You will notice a number of changes with respect to the SCF calculation that indicate a structural relaxation run. The calculation type is 'relax'; a force threshold is indicated; a new namelist IONS is present; and the atomic positions are followed by three integers that indicate which atomic components are fixed (0) or free (1) to move. (If nothing is specified, the default is 1 1 1). 
     ```
     % cat co.relax.in
     [...]
     calculation  = "relax",
     forc_conv_thr = 1.0D-4		<- default is 1.0D-3
     &IONS
        ion_dynamics = "bfgs"		
     /
     ATOMIC_POSITIONS {angstrom}
     C  3.800  2.0  2.0   1 0 0		<- force component multiplier
     O  2.000  2.0  2.0   0 0 0
     [...]
     % pw.x < co.relax.in > co.relax.out
     ```

   5. Finally, compare the bond lengths found using the various methods.
