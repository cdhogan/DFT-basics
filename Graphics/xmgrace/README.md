# Plotting data with grace
This is a short tutorial for plotting scientific data with grace (xmgrace). Grace is a WYSIWYG graphical program for generating 2D plots of functions and data. Although it is somewhat old, it is still a solid plotting tool for use in a Unix environment, and somewhat easier to learn that say gnuplot or the python-based matplotlib. The curve fitting and multipanel plotting is very nice to use.

![Silicene](Ref/figure.png?raw=true "Silicene")
An example of a two-panel figure created using Grace.

The official website is https://plasma-gate.weizmann.ac.il/Grace/ in which you will find the offical User Guide https://plasma-gate.weizmann.ac.il/Grace/doc/UsersGuide.html and Tutorial https://plasma-gate.weizmann.ac.il/Grace/doc/Tutorial.html. A PDF of the latter is given here Ref/vigmond_xmgrace_tutorial.pdf and a very nice tutorial from https://hogan53.net/common_pdfs/grace_tutorial_2024.pdf  Ref/grace_tutorial_2024.pdf  

## Main window
Assuming you have the software installed, you can launch it in different ways:
```
% xmgrace			[open the default plot window]
% xmgrace Ref/example.agr	[open a pre-existing project]
% xmgrace Ref/other_data.txt	[open a textfile containing data in columns]
```

![Description](Ref/main.png?raw=true "Comment")

<details>

<summary>What we learn here (click to expand)</summary>

* Terminal types (type "help terminal" for more information)
* Define a graph title (set xlabel "...")
* Plot two simple functions on the same graph (simply separate by comma)

</details>


## Plot styles
![Description](Ref/menus.png?raw=true "Comment")


![Description](Ref/inout.png?raw=true "Comment")
![Description](Ref/graph-menu.png?raw=true "Comment")
![Description](Ref/set-menu.png?raw=true "Comment")
![Description](Ref/axis-menu.png?raw=true "Comment")

![Description](Ref/example2.png?raw=true "Multi panel example")
![Description](Ref/arrange.png?raw=true "Comment")

![Description](Ref/data-transform.png?raw=true "Comment")
![Description](Ref/text.png?raw=true "Comment")

Now we move to a more useful example. Here on we will drop the `gnuplot>` prompt for clarity.
```
set title "Basic functions and styles"

```

<details>

<summary>What we learn here (click to expand)</summary>

* Set primary and secondary axes labels (set xlabel "...")
* Set axis ranges (set xrange [min:max])

</details>

> [!TIP]
> Type "help [topic]" from inside gnuplot to access the exhaustive gnuplot manual, e.g. "help plot" or "help xtics" or "help set" 

## Saving and loading scripts, generating images

## Other documentation and resources 
There is not a huge amount of documentation available, but for basic operation the WYSIWYG layout is fairly self-explanatory. 

*Official website*
* https://plasma-gate.weizmann.ac.il/Grace/  

*Video tutorials*
* https://www.youtube.com/playlist?list=PLzSoIVVxSY_8KZ-Jra7GE3Czi6tu54TrJ

*Miscellaneous blog posts, articles, websites, tutorials.* 
* http

