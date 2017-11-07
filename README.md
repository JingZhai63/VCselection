# VCselection for Microbiome Taxonomic Data

**VCselection** is a Julia package for performing variance components selection scheme VC-lasso for sparse and high-dimensional taxonomic data analysis. It utilizes the UniFrac distance computation from Jing Zhai's Julia package [PhylogeneticDistance.jl](https://github.com/JingZhai63/PhylogeneticDistance.jl)

* Unweighted UniFrac distance ($K_{uw}$)
* Weighted UniFrac distance
* Variance adjusted weighted UniFrac distance
* General UniFrac distance

The input files for _VCmicrobiome.jl_ are microbiome `kernel distance matrix (.csv file)`, `covariates file (.csv file)` and `phenotype file (.csv file)`. You should have these input files prepared before running our program. The `output file (.out file)` is a simple comma-delimited file containing the _p_-values for each phenotype and each group of OTUs under a certain testing scheme (eLRT, eRLRT or eScore).

To use **VCmicrobiome.jl** , you need to call the `MicrobiomeVCTest()` function.

Please see the detailed documents in [Read the Docs](http://vcselection.readthedocs.io/en/latest/)

# Installation

To install _VCselection_, open up Julia and then type

```julia
julia> Pkg.clone("https://github.com/JingZhai63/VCselection.git")
```

