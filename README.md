# SpatialOmicsOverlay

# For review

## Overview

The GeoMxTools package contains tools for analyzing data on the image from
NanoString GeoMx Digital Spatial Profiler (DSP). It provides functions
to extract image and XML from OME-TIFFs, overlay Regions of Interest (ROIs) onto
the image, and manipulate the image (coloring, orientiation, cropping). Output 
figures are ggplot based allowing for easy customization of images to include
spatial images into data visualization. 

## Installation

### Download the release version from Bioconductor
<https://bioconductor.org/packages/release/bioc/html/SpatialOmicsOverlay.html>

### Install the release version from Bioconductor
``` r
if (!requireNamespace("BiocManager", quietly=TRUE))
    install.packages("BiocManager")

BiocManager::install(version="release")

BiocManager::install("SpatialOmicsOverlay")
```

### Install the development version from GitHub
``` r
install.packages("devtools")
library("devtools")
devtools::install_github("Nanostring-Biostats/SpatialOmicsOverlay", 
                         build_vignettes = TRUE, ref = "dev")
```

## Documentation

To learn how to start using SpatialOmicsOverlay, view documentation for the
version of this package installed in your system, start R and enter:

``` r
browseVignettes("SpatialOmicsOverlay")
```

## Branches
The release version on Bioconductor is the stable version.
<https://bioconductor.org/packages/release/bioc/html/SpatialOmicsOverlay.html>

The devel version on Bioconductor is upstream of master on GitHub.
It is under active development and no guarantee is made on usability
at any given time.

The dev branch on GitHub is under active development and no guarantee 
is made on usability at any given time.

## Citation
Griswold, M.
SpatialOmicsOverlay: Spatial Overlay for Omic Data From Nanostring GeoMx data. 
R Package Version 1.0.0. 
NanoString Technologies Inc.; Seattle, WA 98109, USA. 2021. 

## License
This project is licensed under the [MIT license](LICENSE).
