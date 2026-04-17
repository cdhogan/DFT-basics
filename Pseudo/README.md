## Pseudopotentials

The pseudopotential files in this folder are soft, typically norm-conserving ones, chosen to allow the tutorials to be run quickly. They are not meant for production (publication) runs. Remember to test all pseudopotentials before use.

In general it is advised to choose a pseudopotential from a validated library. In recent years several such libraries have become available: use them. Some have been installed at `/data-fast/greenano/Software/PSEUDO`. Here is an incomplete list of pseudopotential libraries. For quantum-ESPRESSO you must use the UPF format.

| Acronym | Library | Link |
| --- | --- | --- | 
| sssp | Standard Solid-State Pseudopotentials (mixed) | https://www.materialscloud.org/discover/sssp/table/efficiency |
| psl | PSlibrary (USPP, PAW) | https://pseudopotentials.quantum-espresso.org/legacy_tables |
| dojo | pseudo-dojo (NC, PAW) | https://www.pseudo-dojo.org |
| gbrv | Garrity, Bennett, Rabe, Vanderbilt (USPP) | https://www.physics.rutgers.edu/gbrv/ | 
| hgh | Hartwigesen-Goedecker-Hutter (NC) | https://pseudopotentials.quantum-espresso.org/legacy_tables/hartwigesen-goedecker-hutter-pp | 
| fhi | FHI converted from Abinit (NC) | https://pseudopotentials.quantum-espresso.org/legacy_tables/fhi-pp-from-abinit-web-site | 
| oncv | Optimized Norm-Conserving Vanderbilt (NC) | See sg15 and dojo |
| sg15 | Schlipf and Gygi ONCV (NC) | http://www.quantum-simulation.org/potentials/sg15_oncv/ |

You will come across several acronyms in the names of pseudopotential files, especially in the PSLibrary, which have their own naming convention https://pseudopotentials.quantum-espresso.org/home/naming-convention

| Acronym | Meaning |
| --- | --- |
| pp, psp | pseudopotential |
| upf | universal pseudopotential format (UPF) |
| nc | norm-conserving (NC) |
| uspp | ultrasoft (US) pseudopotential | 
| paw | projector augmented wave (PAW) |
| vbc | von Barth/Car (LDA) |
| vwn | Vosko-Wilk-Nusair (LDA) |
| rrkj | Rappe-Rabe-Kaxiras-Joannopoulos (NC) |
| rrkjus | Rappe-Rabe-Kaxiras-Joannopoulos (Ultrasoft) |
| kjpaw | Kresse-Joubert PAW | 
| SR/FR | Scalar relativistic, fully relativistic |


