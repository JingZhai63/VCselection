# Examples

This example illustrates the usages of different options by analyzing a simulated data set obtained from a longitudinal HIV Pulmonary Microbiome Study. This demo data set contains 31 microbiome genus clusters and 50 individuals. The simulated microbiome data measured at three time points. The required/optional input files are

* Folder for kernel matrices files: kernel matrices of 31 genus clusters (vc01.csv, vc02.csv, ... vc31.csv)
* Covariates file: X_5.csv with two simulated covariates
* Phenotye file: y.csv with five centered outcomes

These data files come with our package, and they are available at here.

# Basic usage

Open up a Julia session and type
* setting working directory
```julia
julia> cd("VCselection/docs/examples/baseline")
julia> Vpath = string(pwd(), "/vc")
```
If `outpath` is not provided, then the output will be written to the working directory.

* selection in cross-sectional design
```julia
julia> using VCselection
julia> microVClasso(Vpath = Vpath, resFile = "outcome/y.csv",  covFile = "covariate/X_5.csv", outpath = "out/")
```

You can also call microVClasso from command line. For example, to perform selection,

```command
$ julia -E 'using VCselection; microVClasso(Vpath = Vpath, resFile = "outcome/y.csv",  covFile = "covariate/X_5.csv", outpath = "out/")
```

Note:
* If the input files are not at the current directory, you should specify the paths correctly.
* If the phenotype file and outcome file don't include the column names,
```julia
julia> using VCselection
julia> microVClasso(Vpath = Vpath, resFile = "outcome/y.csv",  covFile = "covariate/X_5.csv", outpath = "out/", yhead = false, xhead = false)
```
* If you want to specify the index of column for phenotype and covariate files,
```julia
julia> using VCselection
julia> microVClasso(Vpath = Vpath, resFile = "outcome/y.csv",  covFile = "covariate/X_5.csv", outpath = "out/", resIdx = 7, covIdx = [3,4], yhead = false, xhead = false)
```

# Option `λgrid`
If `λgrid` is provided,
```julia
julia> using VCselection
julia> λoptions = vcat(0.1, 0.2, 0.5, 1.0)
julia> microVClasso(Vpath = Vpath, resFile = "outcome/y.csv",  covFile = "covariate/X_5.csv", outpath = "out/", λgrid = λoptions)
```

# Option `criterion`
The default `criterion` is "AIC". Other options are "BIC", "Both" and "None". For example, if you want to output selection results using both "AIC" and "BIC",
```julia
julia> using VCselection
julia> microVClasso(Vpath = Vpath, resFile = "outcome/y.csv",  covFile = "covariate/X_5.csv", outpath = "out/", λgrid = λoptions, criterion = "Both")
```

## Option `longitudinal`

If the microbiome taxonomic data is longitudinal,

* setting working directory
```julia
julia> cd("VCselection/docs/examples/longitudinal")
julia> Vpath = string(pwd(), "/vc")
```

* selection in longitudinal design
```julia
julia> using VCselection
julia> microVClasso(Vpath = Vpath, resFile = "outcome/y.csv",  covFile = "covariate/X_5.csv", outpath = "out/", longitudinal = true)
```

## Option `λfactor`

This option is used for setting the penalization of each variance components. `λfactor` is a vector with length _(L+1)_ in longitudinal design or length _L_ in cross-sectional design. In longitudinal design, the Z'Z matrix can be constructed using the subject ID in _microVClasso_ and set up the corresponding `λfactor`. Note that if the design matrix is provided by users, the `λfactor` will not be set up by the software.

```julia
julia> using VCselection
julia> penaltyIdx = vcat(0, ones(L))
julia> microVClasso(Vpath = Vpath, resFile = "outcome/y.csv",  covFile = "covariate/X_5.csv", outpath = "out/", longitudinal = true, λfactor = penaltyIdx)
```
