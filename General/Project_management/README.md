In this page are some general guidelines of how to manage larger projects, monitor  disk and memory usage, parallelize efficiently, and so no.

## Organization

When starting a new project it is important to manage your calculations and files in a neat way. Directories are cheap: use them widely and name them clearly. The main thing to avoid is using a single folder for ten different types of calculation, and hundreds of files with slightly different names.

Let's consider a study of the electronic properties of CO adsorption on Ag(111). This involves several different levels of problem, including:

* Choosing pseudopotentials and exchange correlation functional.
* Setting up input files for bulk and surface
* Convergence tests for Ag and CO
* Identifying optimal adsorption site
* Computation of properties

Here is a possible directory structure for the project.

```
project_CO_Ag111/
│
├── 0_setup/
│   ├── pseudopotentials/
│   │   └── Ag.UPF, C.UPF, O.UPF
│   ├── bulk_geometry/
│   │   ├── Ag.cif
│   │   └── Ag_bulk.in		# basic input file
│   ├── molecule/
│       ├── CO.xyz
│       └── CO_molecule.in 	# basic input file
│
├── 1_Ag_bulk/
│   ├── 0_convergence/
│   │   ├── ecut/
│   │   └── kpoints/	# k-points and smearing
│   ├── 1_vc-relax/    	# estimate Ag lattice constant
│   ├── 1_alat/        	# equation of state
│   ├── 2_scf/         	# converged total energy
│   ├── 3_DOS
│       ├── k8x8x8
│       └── k16x16x16
│
├── 2_Ag111/
│   ├── 0_build_1x1/
│   │   ├── slab_4layers/	# should also converge slab thickness
│   │   └── vacuum_convergence/	
│   │       ├── 10A/
│   │       ├── 15A/
│   │       └── 20A/
│   ├── 1_relax/     	# slab interlayer distance
│   │   ├── k4x4x1
│   │   └── k8x8x1
│   ├── 2_build_3x3/
│   │   ├── slab_3layers/	
│   │   └── relax/	# scale with 1x1 k-points, but good to check
│   ├── 4_scf		# converged total energy
│   ├── 5_DOS		# best to do for 3x3 supercell
│   │   ├── k8x8x1
│   │   └── k16x16x1
│   └── 5_bands
│
├── 3_CO_molecule/
│   ├── 0_convergence/
│   │   ├── relax_5A/	# converge cutoff wrt geometry
│   │   ├── relax_10A/
│   │   └── relax_15A/
│   └── 1_scf/		# converged total energy
│
├── 4_Ag111_CO
│   ├── 0_top/
│   │   ├── 0_build/
│   │   ├── 1_relax/	# increase to CO cutoff if necessary
│   │   │   ├── gamma	# quickly reach a reasonable structure
│   │   │   └── k8x8x1/	# at converged grid
│   │   ├── 2_scf/
│   │   ├── 3_bands/
│   │   ├── 3_DOS/	# compare with clean 3x3
│   │   │   ├── k8x8x1/
│   │   │   └── k16x16x1/
│   │   └── 3_charge/	# or other post-processing
│   │
│   ├── 0_hollow/
│   │   └── 1_relax/
│   │
│   └── results/
│       └── adsorption_energies.dat
│
├── 5_analysis/		# perform final analyses of adsorbed vs clean
│   ├── adsorption_energy/
│   ├── charge_density_difference/
│   ├── projected_DOS/
│   └── work_function/
│
└── 6_results/		# collect final geometries, converged spectra, etc
    ├── bulk/
    ├── slab/
    ├── molecule/
    ├── adsorption/
    └── figures/


## Parallel usage

Parallel usage
speedup graph
mpi vs openmp
Not useful more than 8 procs
check multiple jobs
kill multiple procs

## Disk space management

Disk space
Greenano students: your workspace ($WORK) is at... 
You have a second workspace at

Your cohirt has XGb to use.

du -s -h Dir
du -sh /data-fast/greenano
du -sh * | sort -h
ls -lh single files

How to manage space
When doing convergence tests, especially for dense k-grids, it is easy to generate parge amounts of data (typically wavefunctions).
In many cases it is relatively fast to recompute wavefubctions from disk. Once you have computed plottable data (e.g. Dos or epsilon2), you can usually delete the save directory, or at oeasts the save/wfc* files.

wfc and wfc files
Know contents of Save folder

## Process management

Processes
emory usage
ps aux
pc aux | grep firefox
ps aux | grep pw.x
top
Sort by memory M
Sprt by cpu P

ps eo
kill -9 PID


Job control

Fore ground background
nohup
tail -f

## Restarting jobs

REstarting jobs
It can happen that a long job dies before completion because of external factors (time limit exceeded, disk full, MPI error). in some cases one xan reatart a run from the last "checkpoint", or speed up a restarted job.
QE 
## Restarting jobs


convergence relax with k
read charge

Uploading downloading to cluster/ remote access

browser...
ssh...

