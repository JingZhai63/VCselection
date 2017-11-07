<style TYPE="text/css">
code.has-jax {font: inherit; font-size: 100%; background: inherit; border: inherit;}
</style>
<script type="text/x-mathjax-config">
MathJax.Hub.Config({
    tex2jax: {
        inlineMath: [['$','$'], ['\\(','\\)']],
        skipTags: ['script', 'noscript', 'style', 'textarea', 'pre'] // removed 'code' entry
    }
});
MathJax.Hub.Queue(function() {
    var all = MathJax.Hub.getAllJax(), i;
    for(i = 0; i < all.length; i += 1) {
        all[i].SourceElement().parentNode.className += ' has-jax';
    }
});
</script>
<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>

# VCselection for Microbiome Taxonomic Data

**VCselection** is a Julia package for performing variance components selection scheme VC-lasso for sparse and high-dimensional taxonomic data analysis. It utilizes the UniFrac distance computation from Jing Zhai's Julia package [PhylogeneticDistance.jl](https://github.com/JingZhai63/PhylogeneticDistance.jl)

* Unweighted UniFrac distance (\[K_{uw}\])
* Weighted UniFrac distance  (\[K_{w}\])
* Variance adjusted weighted UniFrac distance  (\[K_{vaw}\])
* General UniFrac distance  (\[K_{\alpha}\])

The input files for _VCselection_ are microbiome  clusters' `kernel distance matrices (.txt files)`, `covariates file (.txt file)` and `outcome file (.txt file)`. You should have these input files prepared before running our program. The `output files (.txt files)` are simple comma-delimited files, including variance components estimation \[\sigma^2\] and negative log-likelihood for each phenotype and each tuning parameter.

To use **VCselection.jl** , you need to call the `VClasso()` function.

Please see the detailed documents in [Read the Docs](http://vcselection.readthedocs.io/en/latest/)

# Installation

To install _VCselection_, open up Julia and then type

```julia
julia> Pkg.clone("https://github.com/JingZhai63/VCselection.git")
```

