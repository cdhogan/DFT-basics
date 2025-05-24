# Optical spectra calculation (UNDER CONSTRUCTION)

The optical spectra (dielectric functions) can be computed (at the independent particle level) using the tools `epsilon.x` and `pw2gw.x`. Remember that Kohn-Sham DFT is fundamentally a ground state theory and thus calculation of excited state properties such as optical excitations must be viewed as a first approximation. (For a better treatment, check out TDDFT and GW-BSE approaches.)

The dielectric function is computed from the KS bandstructure using:

<img src="Ref/DOS_equation.png" height="80"/>

<!-- ![DOS equation](Ref/DOS_equation.png?raw=true "DOS equation") -->

i.e. like the DOS it involves an integral over the Brillouin zone of a Dirac delta function times the dipole/momentum transition matrix elements. 

Calculation of the dielectric function is straightforward (but tedious) with quantum-ESPRESSO, and involves three distinct steps: 
1. SCF calculation with `pw.x`. The ground state electronic charge density is computed with `pw.x` self-consistently, as before, on a sufficiently dense k-point grid. 
2. NSCF calculation with `pw.x`. A non-self-consistent (NSCF) calculation is performed using `pw.x` over a much denser k-point grid and over a larger range of bands (to cover the energy range we are interested in). 
3. Dielectric function calculation with `epsilon.x` or `pw2gw.x`. In practice the integral is replaced by a sum over (special) k-points.

It is _very_ important to organise the files neatly. Use separate directories for different numbers of k-points and bands. Also, keep an eye on the amount of disk space being used: some of the examples below use over 10000 k-points.

In this tutorial we will examine both codes.

  1. Run the self-consistent calculation using the provided input `si.scf.in` to generate the ground state electronic charge density. As before, we use an automatically 
  generated, regularly spaced, shifted k-point grid:
      ```
      % tail -2 si.scf.in 
      K_POINTS {automatic}
      8 8 8 1 1 1

      % pw.x < si.scf.in > si.scf.out
      ```
      As this is a SCF run, we set `calculation = 'scf'` in the input file.
      We have chosen 5 bands as before, with 4 being filled.

![optics](Ref/plot_script_epsilon_bands.png?raw=true "optics")
![optics](Ref/plot_script_epsilon_kpts.png?raw=true "optics")
![optics](Ref/plot_script_epsilon_kpts_unshifted.png?raw=true "optics")
![optics](Ref/plot_script_pw2gw_kpts.png?raw=true "optics")

plot "Ref/epsTOT.dat_k32_g0.01" w l,"" u 1:2:(1000) smooth acsplines 


  2.  Run the non-self-consistent (NSCF) calculation using the provided input `si.nscf.in` to generate a set of eigenvalues and eigenfunctions on specific k-points of the Brillouin zone. There are two important changes to the input file:
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
      Look quickly at the last eigenvalue for a few k-points: it is about 14 eV. 

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
      
## Bibliography
1.  Aroyo et al, Acta Cryst. (2014). A70, 126-137 [Link](https://doi.org/10.1107/S205327331303091X)
