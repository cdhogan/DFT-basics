# Adsorption of O on Al(001): general strategies

Here we will compute the adsorption energy of an O atom on the Ag(001) surface.
Surface optimizations are slow calculations so it is important to identify a good strategy.

     ![Adsorption sites](Ref/al001_O_sites.png?raw=true "Adsorption sites")

## Input file

We will start from the relaxed coordinates of the Al(001) surface.
We add by hand an O atom in a chosen site. For simplicity, we will start with the on-top site.

Where do we put the O atom? It is important to have a reasonable starting geometry, otherwise the optimization can take a long time, so we need an estimate of the Al-O bond distance. Looking at the literature, e.g.  [1], we can estimate a range 1.70-2.10A, depending on the coordination ("In the ideal crystal structure of θ-Al2O3, Al-O bonds can be either 1.70 Å or 1.79 Å (tetrahedral) or 1.99 Å or 2.10 Å (octahedral)."). 

Let's start then with an Al-O distance of 1.72A.
Recall `alat=2.8546`, thus in alat units we place the O atom about 0.61 above an Al atom in the top layer.

   ```
   ```

top initial 1.72 A
top final   1.68 A

hollow initial: 2.14 A
hollow final: 2.08


[1] M. Young et al, ACSAppl.Mater. Interfaces2020,12,22804−22814
ProbingtheAtomic-ScaleStructureofAmorphousAluminumOxide GrownbyAtomicLayerDeposition
