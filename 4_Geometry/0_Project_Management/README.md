
setting paths

VM structure

Structure of directories
Linking files
Directories are cheap: use them, and name them clearly. Run separate kinds of calculations in different folders. This makes identifying errors easier. 
Imagine a study of CO adsorption on Ag(111).
Bulk_Ag/
cutoff
k-points
lattice relax
bands
Dos_opt/k881_110/

CO/
cutoff/40relax
relax/40ry
relax/60ry
relax/100ry

surface/
setup
relax 1*1
setup 3*3
clean/relax/221110
441110
clean/properties
adsorbed/relax/221110
441110 -> finalmgeom and Etot
adsorbed/properties/atm, pp.x runs


Parallel usage
speedup graph
mpi vs openmp
Not useful more than 8 procs
check multiple jobs
kill multiple procs


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

REstarting jobs
It can happen that a long job dies before completion because of external factors (time limit exceeded, disk full, MPI error). in some cases one xan reatart a run from the last "checkpoint", or speed up a restarted job.
QE 

convergence relax with k
read charge

Uploading downloading to cluster/ remote access

browser...
ssh...

