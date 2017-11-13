# Data Formats

The type of files involved in this package can be divided into two categories: input files and output file. The summary of different files are listed as

| Name       | Category           | Extension  | Description |
| ------------- |-------------|:-----:|-------------|
| Kernel matrices    | Input | .csv | Multiple csv files that contain the kernel distance matrices (variance components) which is calculated from the microbiome count data and phylogenetic info|
| Covariates     | Input      |  .csv | One csv file that contains the values of covariates|
| Phenotype | Input     |    .csv | One csv file that contains the values of phenotypes |
| Output | Output     |    .csv | Multiple csv files that contains variance components estimation, negative log-likelihood or AIC/BIC for each tuning parameter.

# Kernel Distance Matrices files

UniFrac is a distance matrix used for comparing biological communities. More information about the UniFrac distance is [here](https://en.wikipedia.org/wiki/UniFrac). UniFrac distance can be calculated using Julia package [_PhylogeneticDistance.jl_](https://github.com/JingZhai63/PhylogeneticDistance.jl). Microbiome count file and phylogenetic tree file are needed. The distance matrix need be transformed to positive-definite kernel matrix and be scaled to have unit Frobenius norm.  

* Kernel matrices files should have same order with phenotype file and covariate file
* Do not include column names and row names in kernel matrices files

# Covariates file

Covariates file is a .csv file that contains the values of covariates. In covariates file, each line represents one measurement for one subject. The intercept should NOT be included. A typical covariates file look like

If a specific covariate value is missing, please impute by mean.  If no covariates file is provided, the covariates matrix **X** will be automatically set to a _n_-by-1 matrix with all elements equal to 1, where n is the number of individuals.

```csv
id	    time	X1	    X2
id_001	t0	  1.857     1.492
id_001	t1	  0.747     2.414
id_001	t2	 -0.652     0.887
id_002	t0	 -0.993     0.476
id_002	t1	  0.737    -0.041
id_002	t2	  0.309     0.230
id_003	t0	  0.205    -0.223
id_003	t1	 -1.705     0.631
id_003	t2	  0.307     0.337
```

# Phenotype file

Phenotype file is a txt file that contains the values of phenotypes. In phenotype file, each line represents one measurement at one time point. One subject may have several repeated measurements. The format of phenotype file is the same as covariate file. The fields in phenotype file are

* Subject ID
* Measurement Time
* Measurement ID (optional)
* Phenotypes

```csv
id	    time	 outcome1	outcome2	outcome3	outcome4   outcome5
id_001	t0	   -1.114  	-1.598    	-2.825    4.140	   3.023
id_001	t1	    1.138   	2.872	     1.240    1.767	   3.016
id_001	t2	   -0.081  	 0.548	    -1.447    0.094	  -0.807
id_002	t0	    3.987      -2.001    	-0.998   -0.689      -0.790
id_002	t1	    1.617   	1.480	    -1.159   -3.790       0.026
id_002	t2	    2.964   	3.026	    -0.437    1.777	  -0.446
id_003	t0	    1.087      -2.223    	-1.900   -3.228       0.075
id_003	t1	    2.791      -0.375    	 0.170    2.168	  -1.286
id_003	t2	    1.708   	1.255	    -2.569    1.651	   1.769

```

# Output file

By default, output have two files: one includes the variance components estimation and one contains negative log-likelihood under each tuning parameter. In estimation output file, each line represents for one variance component and each column represents for one tuning parameter. In negative log-likelihood file, each line represents for one tuning parameter.

If users indicate the criterion (i.e., AIC/BIC), the **VCselection** will output another two files, one contains the AIC/BIC for all tuning parameter and the other one contains the variance components estimation with lowest AIC/BIC value. The file name includes the optimal tuning parameter selected by AIC/BIC.
