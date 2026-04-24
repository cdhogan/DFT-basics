## Pseudopotentials

The pseudopotential files in this folder are typically norm-conserving ones, chosen to allow the tutorials to be run quickly. They are not meant for production (publication) runs. Remember to test all pseudopotentials before use.

In general it is advised to choose a pseudopotential from a validated library. In recent years several such libraries have become available: use them. Some have been installed at `/data-fast/greenano/Software/PSEUDO`. Here is an incomplete list of pseudopotential libraries. For quantum-ESPRESSO you must use the UPF format.

| Acronym | Library | Link |
| --- | --- | --- | 
| SSSP | Standard Solid-State Pseudopotentials (mixed) | https://www.materialscloud.org/discover/sssp/table/efficiency |
| psl | PSlibrary (USPP, PAW) | https://pseudopotentials.quantum-espresso.org/legacy_tables |
| DOJO | pseudo-dojo (NC, PAW) | https://www.pseudo-dojo.org |
| GBRV | Garrity, Bennett, Rabe, Vanderbilt (USPP) | https://www.physics.rutgers.edu/gbrv/ | 
| HGH | Hartwigesen-Goedecker-Hutter (NC) | https://pseudopotentials.quantum-espresso.org/legacy_tables/hartwigesen-goedecker-hutter-pp | 
| FHI | FHI converted from Abinit (NC) | https://pseudopotentials.quantum-espresso.org/legacy_tables/fhi-pp-from-abinit-web-site | 
| ONCV | Optimized Norm-Conserving Vanderbilt (NC) | See sg15 and dojo |
| SG15 | Schlipf and Gygi ONCV type (NC) | http://www.quantum-simulation.org/potentials/sg15_oncv/ |

You will come across several acronyms in the names of pseudopotential files, especially in the PSLibrary, which have their own naming convention in the form `[rel-][core-][XC-][valence-][type][_version]`. See https://pseudopotentials.quantum-espresso.org/home/naming-convention for details. Some acronyms are listed in this table: 

| Acronym | Meaning |
| --- | --- |
| pp, psp | pseudopotential |
| upf | universal pseudopotential format (UPF) |
| nc | norm-conserving (NC) |
| uspp | ultrasoft (US) pseudopotential | 
| paw | projector augmented wave (PAW) |
| van | Vanderbilt ultrasoft (US) |
| rrkj | Rappe-Rabe-Kaxiras-Joannopoulos (NC) |
| rrkjus | Rappe-Rabe-Kaxiras-Joannopoulos (Ultrasoft) |
| kjpaw | Kresse-Joubert PAW | 
| SR/FR | Scalar relativistic, fully relativistic |
| pz | Perdew-Zunger (LDA) |
| pbe | Perdew-Burke-Ernzerhof (GGA-PBE) |
| pw91 | Perdew-Wang 91 (GGA) |
| -spd- | semicore s/p/d states in valence |
| -n- | Nonlinear core-correction |

### Which pseudopotential should I choose?

As always, the answer is: _it depends_. Here are some general comments on the various libraries:

| Library | Comments |
| --- | --- |
| SSSP | This is actually a curated, highly tested selection of PPs from different libraries, mixing USPP/PAW/NCPP types  for the same functional. The idea is to offer the best PP for each element. Standard (efficiency) and highly accurate (precision) versions are available. If you don't know any better, this is a good place to start. |
| DOJO | A systematic, standardized library of norm-conserving pseudos. The clickable tables helpfully indicate the suggested cutoffs, which are, however quite large.
| SG15 | An accurate, norm-conserving library, optimized to have lower cutoffs. Fully-relativistic PPs are also included. |
| GBRV | A fast ultrasoft library perfect for high-throughput studies thanks to their low cutoffs. 
| PSlibrary | A large USPP/PAW library that contains PPs for a wide range of elements and types. If you are looking for something specific, check here. Not as systematically tested as the above ones, but still a great resource. The recommended PPs are listed here: https://dalcorso.github.io/pslibrary/PP_list.html Note that the latter URL gives you the PP file _generator_, if you just want a specific UPF file search through https://pseudopotentials.quantum-espresso.org/legacy_tables |
| HGH, FHI, ... | These are older libraries that are largely superceded by the modern libraries. Can be accurate but have high cutoffs. Best to avoid. |

If you need PPs for actinoids, rare earths, etc, check out the links in https://pseudopotentials.quantum-espresso.org/
