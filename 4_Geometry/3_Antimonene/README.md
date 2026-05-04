## Antimonene exercise ##

![Antimonene](Ref/geom.png?raw=true "Antimonene")


Use quantum-ESPRESSO to compute the lattice constant and cohesive energy of beta-antimonene, without any supplied input file or use of AI/materials cloud, and compare results with Wang et al (ACS Appl Mater Interfaces 7 (2015), p11490 doi: 10.1021/acsami.5b02441) . The student should modify e.g. an input file for graphene and perform adequate convergence tests. Try several modern pseudopotential libraries (DOJO, GBRV, SG15,SSSP) and exchange correlation functionals (LDA,PBE,PBEsol,PBE-D3). 

Notes on pseudopotentials: ../../Pseudo

Notes on XC choice: ../../8_graphite_XC

### Summary of results ###

|Run|Functional|Type|Library|Cutoff|NLCC|Fullname|
| --- | --- | --- | --- | --- | --- | --- |
A|LDA-PW|NC|DOJO|80/320|Yes|DOJO-LDA-NC-SR-04-STD	|4.003 A|3.383 eV|
D|LDA-PZ|USPP|GBRV|60/600|Yes|GBRV-LDA-1.5-USPP	|4.005 A|3.481 eV|
B|PBE	|NC|DOJO|80/320|Yes|DOJO-PBE-NC-SR-04-STD	|4.122 A|2.585 eV|
E|PBE	|NC|SG15|80/320|No|SG15-1.2-PBE-ONCV 	|4.130 A|2.731 eV|
C|PBE-D3BJ|USPP|SSSP|60/600|Yes|SSSP_1.3.0_PBE_eff-USPP+D3BJ|4.066 A|2.846 eV|
F|PBEsol|USPP|GBRV|60/600|Yes|GBRV-PBEsol-1.5-USPP|	4.041 A|2.916 eV|

Note that the used cutoffs are conservative choices and have not been tested: 60Ry for USPP, 80Ry for NCPP.

### Conclusions ###

- The same functionals compute alat to 0.01A, and Ecoh to 0.15eV 
- All functionals compute alat to 0.15A
- vdW corrects the PBE alat a little towards LDA (poor mans vdW!)
- Large range of 1eV in Ecoh with respect to functionals: LDA overbinds, PBE underbinds
- PBEsol result lies between LDA and PBE, corrects PBE like a vdW correction. However PBEsol is not reliable for atoms.

