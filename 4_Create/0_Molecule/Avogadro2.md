# Design a molecule from scratch
In this tutorial we will use Avogadro2 to create the pyrrole molecule, relax the structure with a force-field optimization, and then perform an accurate geometry optimization using quantum-ESPRESSO.

The below tutorial works with the second version of Avogadro, at https://two.avogadro.cc/

**If you are using the original version of Avogadro (at https://avogadro.cc/), which has slightly different menus, follow instead [this tutorial for Avogadro](README.md)**


![Pyrrole structure](Ref/pyrrole01.png?raw=true "pyrrole")

  1. Launch Avogadro2. There are detailed Documentation on their website at https://two.avogadro.cc/docs/getting-started/drawing-molecules.html   
    ![Avogadro menu](Ref/avogadro2_menu.png?raw=true "menu")
  - If you like, first play with the menu options: Draw: add/delete atoms and bonds, change bond order; Move/Manipulate: move atoms; etc. When finished, clear the window by hitting CMD-X or CTRL-X on your keyboard.
  - Now using the first "Draw" tab, create the pyrrole molecule.
  - Relax the molecule using a simple force-field optimization: click "Extensions > Open Babel > Optimize Geometry"
  - Click "Navigate" and rotate the view, checking that it looks correct.
  - Click "File > Export > Molecule..." and save the geometry in Avogadro XYZ format as pyrrole.xyz. In this format, the atoms are specified in Angstrom. The second line is a comment, you can change it if you like.
  - Check the geometry with Xcrysden 
  ```
  % xcrysden --xyz pyrrole.xyz
  ```
  - It is advisable to shift the molecule so that it fits neatly inside a box (for the next step). 
  ```
  % head pyrrole.xyz
  10
	Energy:      32.5376008
  N          2.35756        0.26815       -8.46372
  C          1.29444        0.14487       -7.64867
  ...
 
  % awk '{if (NR>2) {print $1,$2,$3+5,$4+10} else print}' pyrrole.xyz > pyrrole_shifted.xyz  (choose suitable values)
  ```

  2. Now create an input file for PWscf. The easiest thing is to copy and modify a previous file, i.e. one from the CO tutorial.
  ```
  cp ../../3_CO/3_HomoLumo/co.relax.in .
  cp co.relax.in pyrrole.relax.in
  ```
  - At this point you need to edit the file: insert the atoms for pyrrole_shifted.xyz, modify appropriately the number and type of atoms, define an appropriate supercell, etc.
  - Download suitable pseudopotentials from the quantum-ESPRESSO website. For simplicity, let's choose PBE kinds for N,C,H from http://www.pseudo-dojo.org/   (they are also in the Ref and Pseudo folders)

  3.  At this point you should perform the same convergence tests as we demonstrated for the CO molecule.
  - If time is short, take the cutoff from the pseudo-DOJO site and define a cubic box so that molecules are separated by at least 10 angstrom.
  - Relax the structure.

  4. Plot the HOMO using pp.x, and check it looks reasonable using a Google search.

  ![Pyrrole HOMO](Ref/pyrrole_HOMO.png?raw=true "pyrrole")

  Note that the LUMO, in comparison, looks terrible compared to published work. This is due to several factors, including over-delocalization with PBE and LDA functionals.

### When you have completed this tutorial, you can move on to [1_Crystal: Design a bulk crystal calculation from scratch](../1_Crystal)

