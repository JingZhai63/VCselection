# Installation

To install _VCselection_, open up Julia and then type

```julia
julia> Pkg.clone("https://github.com/JingZhai63/VCselection.git")
```

If you don't have _StatsBase_ and _Polynomials_ installed in julia, please perform

```julia
julia> Pkg.add("StatsBase")
julia> Pkg.add("Polynomials")
```

Then you can use the following command to verify that the package has been installed successfully

```julia
julia> using VCselection
julia> microVClasso()
microVClasso (generic function with 1 method)
```

Also, to install Jing Zhai's Julia package _PhylogeneticDistance.jl_, please see [installation](http://PhylogeneticDistancejl.readthedocs.io/en/latest/installation/)
