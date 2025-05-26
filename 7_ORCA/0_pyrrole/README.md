## First steps with ORCA

Excellent tutorials are provided here:

https://www.faccts.de/docs/orca/6.0/tutorials/first_steps/first_calc.html

Let's compare the energy levels for the pyrrole molecule created previously, using different exchange correlation functionals, including hybrids.

   ```
   % ls
   pyrrole_relax_PBE.in
   pyrrole_relax_B3LYP.in
   pyrrole_initial.xyz
   % cat pyrrole_relax_PBE.in
   !PBE OPT def2-TZVP
   !PRINTGAP
   !PAL4
   * XYZfile 0 1 pyrrole_initial.xyz
   % orca pyrrole_relax_PBE.in >& pyrrole_relax_PBE.out &
   % grep "gap" pyrrole_relax_PBE.out
   % grep -A10 "Geometry convergence" pyrrole_relax_PBE.out
   % grep -A50 "ORBITAL ENERGIES" pyrrole_relax_PBE.out
   %
   % /path/to/orca pyrrole_relax_B3LYP.in >& pyrrole_relax_B3LYP.out &
   % grep "gap" pyrrole_relax_B3LYP.out
   % grep -A50 "ORBITAL ENERGIES" pyrrole_relax_B3LYP.out



   % grep -A22 "ORBITAL ENERGIES" pyrrole_relax_B3LYP.out | tail -2 | awk 'NR==1{s=-$4;next}{s+=$4}END{print s}'
   ```
