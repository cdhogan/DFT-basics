# Visualizing structures with XCrysDen

This is a short tutorial on XCrysDen, a software for visualizing atomic structures, charge densities, etc.

XCrysDen is particularly useful in combination with quantum-ESPRESSO since it can directly open pwscf input and output files, as well as .xsf (volumetric) output files. For more publication-grade images, I recommend VESTA.

The full documentation is available at e.g. http://www.xcrysden.org/doc/intro.html
A PDF with some instructions is available here: http://www.mineralscloud.com/events/download/tutorial_xcrysden.pdf

## Installation

It is best to consult the main documentation depending on your system and various libraries. For instance in linux:
```
% sudo apt install tk libglu1-mesa libtogl2 libfftw3-bin libfftw3-dev libxmu6 imagemagick openbabel libgfortran5
% sudo apt install xcrysden
```
Make sure to add some lines like
```
XCRYSDEN_TOPDIR=/opt/local/share/xcrysden-1.6.2 
XCRYSDEN_SCRATCH=/tmp 
```
to your `.bashrc` or `.zshrc` file.
> [!TIP]
> If xcrysden crashes on startup try to uncomment the line `#set toglOpt(accum) false` in the `~/.xcrysden/custom-definitions` file.

## File formats

For use with quantum-ESPRESSO, input and output files can be read directly, as well as some other types of file:
```
% xcrysden --pwi pwscf_input_file.in
% xcrysden --pwo pwscf_output_file.out
% xcrysden --xsf pwscf_XSF_file.xsf
% xcrysden --xyz generic_XYZ_format_file.xyz
```

## Basic usage

If you launch `xcrysden` without specifying a filename, you will see an empty canvas. From the File menu you can select a file (in some chosen format) to load or to load some example files:

![xcrysden menu](Ref/filemenu-annot.png?raw=true "File")

Besides pwscf input and output files, you can also look at more complicated XSF files.

Once a structure is loaded, Xcrysden will give you the option to display as a full periodic 3D supercell/crystal, or to reduce to 0/1/2D. This can be useful for working with low dimensionality systems.

Once, selected, you can now access to the main window options:

![xcrysden menu](Ref/fullscreen-annot.png?raw=true "File")

The meaning of the various icons is explained in the image. Note in particular the buttons for measuring bond lengths and angles, and for switching between 'nicely cut unit cell' and 'translational asymmetric unit'.

The canvas background can be changed via the icon in the top left corner (useful for printing).

![xcrysden menu](Ref/allmenus.png?raw=true "File")

The main drop down menus are File, Display, Modify and Tools. Here are some tips (see also image below):

** File **
- Save XSF structure: useful to convert a QE input file to a volumetric XSF format file, which can be read with e.g. VESTA (do not reduce the dimensionality in this case)
- Save current State (and Structure): will create a larger checkpoint file saving any more complicated view options (supercells, isosurfaces, colours, etc).
- Print crystal to file: for printing, make the screen as large as possible and save as a PPM or (if available) a PNG file. 

** Display **
- Coordinate system: the red, green, blue arrows correspond to x,y,z axes. You may need to change their colour if you change the background colour.
- Anti-aliasing: turn on if saving good quality 3D images with lighting.
- Primitive/Conventional cell mode: select the former to view the atoms as they appear in the input file.

** Modify **
- See http://www.xcrysden.org/doc/modify.html
- Atomic radius: If bonds do not appear, increase the covalent radius for the selected element(s). The display radius is just the size of the ball on screen.
- Tessellation factor: increase to improve the resolution/smoothness of printed images.
- Number of units drawn: use to repeat a few more unit cells in x,y,z directions.

** Tools **
- k-path Selection: to view the systems Brillouin zone based on the specified ibrav, and generate paths in k-space.
- Data grid: to view volumetric data, isosurfaces of density, etc.

![xcrysden menu](Ref/various-annot.png?raw=true "File")

## 3D visualization

When viewing an XSF file the volumetric data can also be viewed through Tools > Data-grid. Click Ok until you see the following:

![xcrysden menu](Ref/allmenus.png?raw=true "File")

** Isosurfaces **
By default this is switched on. Insert a value of "Isovalue" in the box, making sure to choose a value between the minimum and maximum. If you are viewing more than one unit cell you can ask to show the isosurface across the other cells. Note the options for transparency and for rendering +/- isovalues.

** Planes **
Plane #1..#3 give the option to plot 2D data on planes parallel to the cell planes. You can shift the plane using the red arrows at the bottoms. The number of slides typically corresponds to the FFT indices.
Note the scale function (linear and log are the most useful) and the "Ranges" tab which allows you to tune the contrast (e.g. by cutting the lower valued data).

## Brillouin zone

See http://www.xcrysden.org/doc/kpath.html
The key thing here is, that in order to save a path of k-points you must specify the filename with extension .pwscf.

## Advanced

Xcrysden can do some quite fancy data representations and make use of scripting tools. Unfortunately the information is not easily found on the website without clicking all the links. See for instance the contents of http://www.xcrysden.org/doc/HOWTO.html and http://www.xcrysden.org/doc/FAQ.html and http://www.xcrysden.org/doc/XSF.html 


