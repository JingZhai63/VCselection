
# VCselection for Microbiome Taxonomic Data

**VCselection** is a Julia package for performing variance components selection scheme VC-lasso for sparse and high-dimensional taxonomic data analysis. It utilizes the UniFrac distance computation from Jing Zhai's Julia package [PhylogeneticDistance.jl](https://github.com/JingZhai63/PhylogeneticDistance.jl)

* Unweighted UniFrac distance 
* Weighted UniFrac distance  
* Variance adjusted weighted UniFrac distance 
* General UniFrac distance  

#What's new in VCselection

* select microbiome clusters associated with clinical outcome
* variance components selection using lasso
* longitudinal case

For selecting microbiome clusters, the input files for _VCselection_ are microbiome  clusters' `kernel distance matrices (.txt files)`, `covariates file (.txt file)` and `outcome file (.txt file)`. 

You should have these input files prepared before running our program. The `output files (.txt files)` are simple comma-delimited files, including variance components estimation and negative log-likelihood for each phenotype and each tuning parameter.


To use **VCselection.jl** , you need to call the `VClasso()` function.

Please see the detailed documents in [Read the Docs](http://vcselection.readthedocs.io/en/latest/)

## Contents

* [Installation](http://vcselection.readthedocs.io/en/latest/installation/)
* [Dataformats](http://vcselection.readthedocs.io/en/latest/dataformats/)
* [Usage](http://vcselection.readthedocs.io/en/latest/usage/)
* [Examples](http://vcselection.readthedocs.io/en/latest/examples/)
