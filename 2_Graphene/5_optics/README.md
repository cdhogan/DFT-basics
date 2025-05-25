## Dielectric function of graphene

Run the scripts in Scripts folder

![epsilon](Ref/plot_script_epsilon_bands.png?raw=true "epsilon")

![epsilon](Ref/compk.png?raw=true "epsilon")
![epsilon](Ref/compk_unshifted.png?raw=true "epsilon")

Take care when using `pw2gw.x` for anisotropic systems, as the momentum matrix elements, if summed over k-points in the IBZ only, may not transform properly when expanded to the full BZ.

![pw2gw](Ref/plot_script_pw2gw_kpts.png?raw=true "pw2gw")

![epsilon](Ref/graphene-DF.jpg?raw=true "epsilon")

Ref: 10.1063/1.3604818
