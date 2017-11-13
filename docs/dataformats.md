# Data Formats

The type of files involved in this package can be divided into two categories: input files and output file. The summary of different files are listed as

| Name       | Category           | Extension  | Description |
| ------------- |-------------|:-----:|-------------|
| Kernel matrices     | Input | .txt | Multiple txt files that contain the kernel distance matrices (variance components) which is calculated from the microbiome count data and phylogenetic info|
| Covariates     | Input      |  .txt | One txt file that contains the values of covariates|
| Phenotype | Input     |    .txt | One txt file that contains the values of phenotypes |
| Output | Output     |    .txt | Two txt files that contains variance components estimation and negative log-likelihood for each tuning parameter. 

# Kernel Distance Matrices files

UniFrac is a distance matrix used for comparing biological communities. More information about the UniFrac distance is [here](https://en.wikipedia.org/wiki/UniFrac). UniFrac distance can be calculated using Julia package [_PhylogeneticDistance.jl_](https://github.com/JingZhai63/PhylogeneticDistance.jl). Microbiome count file and phylogenetic tree file are needed. The distance matrix need be transformed to positive-definite kernel matrix and be scaled to have unit Frobenius norm.  

# Covariates file

Covariates file is a .txt file that contains the values of covariates. In covariates file, each line represents one measurement for one subject. The intercept should NOT be included. A typical covariates file look like

If a specific covariate value is missing, please impute by mean.  If no covariates file is provided, the covariates matrix **X** will be automatically set to a _n_-by-1 matrix with all elements equal to 1, where n is the number of individuals.

```txt
subjectID   microbiomeID age sex smoker
X001		X001T1	     57	 0	 1
X001		X001T2	     57	 0	 1
X001 	    X001T3	     57	 0	 1
X002		X002T1	     26	 1	 1
X002		X002T2	     26	 1	 1
X002		X002T3	     26	 1	 1
X003		X003T1	     27	 0	 1
X003		X003T2	     27	 0	 1
X003		X003T3	     27	 0	 1
X004		X004T1	     44	 0	 1
X004		X004T2	     44	 0	 1
X004		X004T3	     44	 0	 1
X005		X005T1	     38	 0	 1
X005		X005T2	     38	 0	 1
X005		X005T3	     38	 0	 1
```

# Phenotype file 

Phenotype file is a txt file that contains the values of phenotypes. In phenotype file, each line represents one measurement at one time point. One subject may have several repeated measurements. The format of phenotype file is the same as covariate file. The fields in phenotype file are

* Subject ID
* Measurement ID
* Time Point (optional)
* Phenotypes

```txt
"subjectID"    "microbiomeID" "y1"   "y2"   "y3"   "y4"   "y5"
X001			X001T1		   25.47  31.68  27.63  28.65  23.93
X001			X001T2		   24.64  31.23  26.94  29.55  26.71
X001			X001T3		   24.93  30.80  30.21  28.91  26.61
X002			X002T1		   12.05  15.64  14.65  11.88  14.36
X002			X002T2		   14.33  14.00  16.12  11.93  15.00
X002			X002T3		   11.45  15.73  15.12  12.66  15.15
X003			X003T1		   12.93  9.977  13.75  14.32  12.65
X003			X003T2		   10.49  12.08  14.26  12.13  13.32
X003			X003T3		   12.42  10.59  13.97  11.73  12.47
X004			X004T1		   20.26  24.75  22.69  21.64  20.18
X004			X004T2		   21.25  25.76  23.17  21.50  20.30
X004			X004T3		   20.65  26.15  22.12  20.72  20.53
X005			X005T1		   13.94  20.73  18.98  15.65  19.46
X005			X005T2		   15.26  21.50  17.06  15.91  20.53
X005			X005T3		   16.43  19.54  18.40  16.71  19.86

```

# Output file

Output files have two files: one includes the variance components estimation and one  contains negative log-likelihood under each tuning parameter. In estimation output file, each line represents for one variance component and each column represents for one tuning parameter. 
