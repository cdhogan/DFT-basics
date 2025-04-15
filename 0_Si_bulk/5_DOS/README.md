# Density of states (DOS) calculation
The density of states D(E) is a measure of how many energy levels are available for electrons at a given energy. The DOS is defined as D(E) = rho(E)/V, where rho(E)δ(E) is the number of states in the system of volume V whose energies lie in the range from E to E+δE. Calculation of the DOS is straightforward with quantum-ESPRESSO, and involves three distinct steps. First, the ground state electronic charge density is computed, as before, self-consistently, on a sufficiently dense k-point grid. Second, a non-self-consistent calculation is performed with pw.x over a much denser k-point grid, as the DOS is sensitive to the k-space integration. Third, the dos.x code computes the DOS by carefully integrating the charge density. 

![DOS equation](Ref/DOS_equation.png?raw=true "DOS equation")

In this tutorial we will examine two ways of performing the integration.

  1. Run the self-consistent calculation using the provided input 'si.scf.in' to generate the ground state electronic charge density. As before, we use an automatically 
  generated, regularly spaced, shifted k-point grid:
      ```
      % tail -2 si.scf.in 
      K_POINTS {automatic}
      8 8 8 1 1 1

      % pw.x < si.scf.in > si.scf.out
      ```
      As this is a SCF run, we set `calculation = 'scf'` in the input file.
      We have chosen 5 bands as before, with 4 being filled.

  2.  Run the non-self-consistent (nscf) calculation using the provided input 'si.nscf.in' to generate a set of eigenvalues and eigenfunctions on specific k-points of the Brillouin zone. There are two important changes to the input file:
      ```
      calculation = 'nscf'
      nbnd        = 10
      [...] 
      K_POINTS {automatic}
      8 8 8 0 0 0
      ```
      We thus request several empty bands (6) in addition to the filled (4) ones, like for the band structure calculation. In practice, the number of bands defines the range over which the DOS is computed, so typically one wants to include several eV above the CBM. 
      ```
      % pw.x < si.nscf.in > si.nscf.out
      ```
      Note that we also specify an 8x8x8 _unshifted_ grid. Shifted grids were more efficient before. Why choose an unshifted one now?
      Since we want to compare and align the DOS with the band structure, it will be useful to ensure the gamma point is included in our grid.
  
  3.  Now we compute the DOS. For this we use a different executable called `dos.x`, which reads a short input file containing a single `&dos` namelist. For detailed explanation of the input file options see the documentation for [DOS](http://https://www.quantum-espresso.org/Doc/INPUT_DOS.html). 
      ```
      &dos
      outdir='./tmp'
      prefix='Si'
      fildos='si.dos.dat',
      degauss=0.01
      Emin=-10.0, Emax=20.0, DeltaE=0.1
      /
      ```
      The last line determines the range over which D(E) is computed, and on what energy intervals (in eV). 
      Instead, `degauss` indicates that we will perform a numerical integration using a gaussian broadening of 0.01 Ry = 0.13eV (NB: Ry, not eV).
      ```
      % dos.x < si.dos.in > si.dos.out
      ```
      The output file `si.dos.dat` can be plotted. Note the format:
      ```
      % head si.dos.dat 
      #  E (eV)   dos(E)     Int dos(E) EFermi =    6.214 eV
      -10.000  0.1148E-84  0.1148E-85
      -9.900  0.1148E-84  0.2295E-85
      ```
      i.e., the file contains the DOS and the integrated DOS. What value does the latter have at the Fermi level?

      Note: the NSCF run recalculates the Fermi level.

  5.  Clearly, the DOS distribution is not a smooth curve. Can you understand why this is by looking at the formula above? We need to improve the integration by increasing the number of k-points. First, however, lets try to use an improved integration algorithm, the tetrahedron method. In this scheme the Brillouin zone is divided into small meshes that are further divided into tetrahedra. Within each tetrahedron, the eigenvalues E(k) (and if present, the matrix elements M(k)) are linearly or quadraticly interpolated and as a result, the BZ integration can be done analytically. To use this method, you just need to modify the input file slightly:
      ```
      % cat si.dos-tetra.in
      &dos
      outdir='./tmp'
      prefix='Si'
      bz_sum='tetrahedra'
      fildos='si.dos-tetra.dat',
      Emin=-10.0, Emax=20.0, DeltaE=0.1
      /
      ```
      Note there is no definition now of a smearing energy. Run `dos.x < si.dos-tetra.in > si.dos-tetra.out` again and compare with the previous plot. 
      ![DOS integration scheme](Ref/DOS-comparison.png?raw=true "DOS integration scheme")

      Clearly the tetrahedron method is better for obtaining a smooth DOS distribution (spectrum). This is generally true, but may not be adequate for metals with a complicated Fermi surface.

      Note: in principle, or at least in older versions of QE, one should perform the nscf calculation also using the tetrahedron method.

      
 
  4.  Let's now perform a convergence with k-points. Increase the density of the k-point mesh in the NSCF run, using grids of size 8x8x8, 16x16x16 and 24x24x24. Save the output si.dos.dat file with an appropriate name in each case. There should be no need to rerun the SCF calculation. For instance,
      ```
      sed 's/8 8 8/16 16 16/' si.nscf.in > si.nscf.in_k16
      pw.x < si.scf.in_k16 > si.scf.out_k16
      dos.x < si.dos.in > si.dos.out
      mv si.dos.dat si.dos.dat_k16
      ```
      Note that for larger grids, you should run in parallel, e.g. `mpirun -np 2 pw.x` and `mpirun -np 2 dos.x`  

      Repeat using the tetrahedron method, and satisfy yourself you have a well converged spectrum.

      Question: why do we need such a large density of k-points for computing the DOS, while a smaller grid is fine for the charge density?
      
  5. ADVANCED: You can also use the scripts 'run_dos' and 'run_plots' which will automate all the steps above. Look also at the 'EFermi.dat' file, which collects some information about the Fermi level and band edges. 
      ```
      % ./Scripts/run_dos
      % cat EFermi.dat
      % ./SCripts/run_plots
      ```
## Bibliography
1.  Aroyo et al, Acta Cryst. (2014). A70, 126-137 [Link](https://doi.org/10.1107/S205327331303091X)
