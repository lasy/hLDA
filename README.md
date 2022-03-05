
<!-- README.md is generated from README.Rmd. Please edit that file -->

# hLDA

<!-- badges: start -->

<!-- badges: end -->

The `hLDA` `R` package is a wrapper around the `HLDA` class/functions of
the [`tomotopy`](https://bab2min.github.io/tomotopy/v0.12.2/en/)
`python` library. It allows to fit hierarchical topic models
(hierarchical Latent Dirichlet Allocation or hLDA) on matrix of count
data where each row is a sample (e.g. a document) and each column is a
feature (e.g. a word). Element `(i,j)` of the count matrix provides the
number of time a given feature `j` was found in document `i`.

## Installation

You can install the development version of hLDA with:

``` r
devtools::install_github("lasy/hLDA")
```

## Example

This is a basic example which shows you how to fit a hierarchical LDA
model to count data and to visualized the fitted parameters. This
example fit hLDA to random data, where no structure is expected.

``` r
library(hLDA)

set.seed(1)
M <- 10 # number of samples (e.g. documents)
N <- 20 # number of features (e.g. words)
x <- matrix(sample(0:100, N*M, replace = TRUE), M, N)
colnames(x) <- paste0(sample(letters, N, replace = TRUE), 1:N) # random feature names
m <- hLDA(x, depth = 3) # fitting the hLDA to the data
```

``` r

plot_hLDA(m, title = "test with random data")
```

<img src="man/figures/README-plot-1.png" width="100%" />
