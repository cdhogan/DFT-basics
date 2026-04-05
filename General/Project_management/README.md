# Project management

In this page are some general guidelines of how to manage larger projects, monitor  disk and memory usage, parallelize efficiently, and so no.

- [Task organization](#task-organization)
- [Disk space]($disk-space-management)
- [Processes](#process-management)
- [Parallel usage](#parallel-usage)
- [Restarting jobs](#restarting-jobs)

## Task organization

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
```
Of course, this is just a guide for a specific (large) project, but try to follow a similar hierarchy corresponding to different physical and computational tasks.



## Disk space management

Essential commands for monitoring your use (or abuse!) of disk space.
```
du -s -h Dir                    # size of a directory in human readable format
du -sh /data-fast/greenano      # disk usage of a whole shared partition
du -sh * | sort -h              # file and directory sizes, sorted in order of size
ls -lh my_file             # size of a single file
```

### Tips with QE
When doing convergence tests, especially for dense k-grids needed for DOS or optics calculations, it is easy to generate parge amounts of data (typically wavefunctions). QE makes two kinds of wavefunction file:
```
% mpirun -np 2 pw.x < silicon.in >& silicon.out &
% ls
silicon.wfc1 silicon.wfc2                 <- temporary WFC files, 1 per MPI process
silicon.in silicon.out silicon.save
% ls silicon.save
data-file.xml charge-density.dat wfc1.dat wfc2.dat wfc3.dat wfc4.dat    <- saved WFC files, 1 per k-point
```
Unless you are restarting in the middle of a relaxation run, the `silicon.wfc*` files can be (should be) safely deleted. They are usually deleted at the end of a run, but will remain if a job is interupted or killed.

In many cases it is relatively fast to recompute wavefunctions from disk. Once you have computed plottable data (e.g. your * .dos or eps2.dat files), you can usually delete the `outdir/.save` directory, or at leasts the `outdir/.save/wfc*` files.

Save/copy your (human readable) input and output files to your local machine. In this way you can always quickly regenerate your data. 

## Process management
Job running slowly? Here are key commands for monitoring your jobs/processes. Before launching any large calculation, always check you have the needed resources available.

```
% cat /proc/cpuinfo    # How many CPUs are available
% cat /proc/meminfo    # How much memory available
% top                  # show running processes 
% ps aux               # show all processes by user
% ps aux | grep firefox    # filter processes running the firefox browser
% ps aux | grep pw.x
```
More advanced searching and sorting can be done using e.g. (see `man ps`)
```
ps -e -o user,pid,%mem,%cpu,user,comm | sort -k 3 -r | head
```
If there are more processes/threads running than the number of CPUs, the machine will run slowly.

To kill a running process, read the PID from the ps command, and 
```
% kill -9 [PID]        # replace [PID] with the appropriate number
```

To launch jobs in the background, put & after the executable, e.g.
```
% sleep 100 &
% kill %1            # kill the job
```
Background jobs can be brought to the foreground with `fg`.

In typical QE runs, you also have to tell the job to perform the writing of output in the background as well. In which case you need to put an ampersand after the redirect symbol as well:
```
% pw.x < silicon.in >& silicon.out &
```
This will redirect the standard output (and standard error) to the output file.

Note however that this command is attached to the __terminal__. If you close the terminal, i.e. disconnect, the job will die. This is not a problem if you are using the virtual machine and leave the terminal running. In general however one should say "don't hangup!", with
```
% nohup pw.x < silicon.in >& silicon.out &
```
This will allow you to close the terminal and log out, leaving your job safely running.

A useful trick with quantum-ESPRESSO is to check if the output file is updating in real time. You can do this with
```
% tail -f silicon.out
```
If you want to terminate a QE run in a nice way (i.e. so that it writes completely to disk), you can make an empty `prefix.EXIT' file in the run directory. After each SCF step the code checks for the presence of this file, and terminates neatly if present.
```
% pw.x < silicon.in >& silicon.out &
% touch silicon.EXIT
[ Job ends]
```

## Parallel usage

quantum-ESPRESSO can be run in parallel efficiently by making use of MPI and openMP directives.
```
% OMP_NUM_THREADS=1
% mpirun -np 4 pw.x < silicon.in > silicon.out
```
For typical cluster usage it is most efficent to use pure MPI and no openMP parallelization.

Jobs can be parallelized on various levels. 

* k-points: Jobs can be efficiently divided into different k-point 'pools' using the `pw.x -npool X' command. The number of pools must be a divisor of the number of MPI tasks, e.g.
  ```
  % mpirun -np 8 pw.x -npool 4 < silicon.in > silicon.out           <--fine
  % mpirun -np 8 pw.x -npool 3 < silicon.in > silicon.out           <--will crash immediately
  ```
  The number of k-points is then split into N pools. Ideally, Nkpt should be a multiple of N.
  Note that this option will not reduce the memory load, but just the speed.
* G-vectors: This is the default. In addition to, or alongside, pools, the code is parallelized with respect to G-vectors. This will reduce the memory load and the speed, albeit not as efficiently as pools. Speedup typically saturates at 4-8 MPI tasks on intel processors.
* images, bands, diag, GPUs: Larger jobs especially on HPCs need to be run with more finely-tuned options - see the PWscf manual.

When killing jobs running in parallel, make sure to kill the 'parent' process and not just one of the threads, as the code may keep running.

## Restarting jobs

It can happen that a long relaxation job dies before completion because of external factors (time limit exceeded, disk full, MPI error). 
In most cases one can restart a run from the last "checkpoint", i.e. using the last files written on disk. The default options are to start from scratch:
```
% cat silicon_orig.in
&system
    prefix = "silicon"
    outdir = "tmp"
   restart_mode="from_scratch"
&electrons
   startingpot="atomic"
   startingwfc="atomic"
```
To continue an incomplete relaxation, do
```
% cat silicon_restart.in
&system
    prefix = "silicon"
    outdir = "tmp"
    restart_mode="restart"        <-- Will read the ATOM_POSITIONS from tmp/silicon.save/data-file.xml
&electrons
    startingpot="file"            <-- The default: try read potential from charge-density.dat
    startingwfc="file"            <-- The default: try read wavefunctions from disk
```
If WFCs are not completely written, it can be safer to put startingwfc="atomic".

You can also speed up convergence tests by reading some previous data. For example, if increasing a k-grid, the following combination can help:
```
   restart_mode="from_scratch"
    startingpot="file"
    startingwfc="atomic" 
```
