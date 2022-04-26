# SpatialOmicsOverlay

## Overview

The SpatialOmicsOverlay package contains tools for analyzing data on the image from
NanoString GeoMx Digital Spatial Profiler (DSP). It provides functions
to extract image and XML from OME-TIFFs, overlay Regions of Interest (ROIs) onto
the image, and manipulate the image (coloring, orientation, cropping). Output 
figures are ggplot based allowing for easy customization of images to include
spatial images into data visualization. 

## Download

Download package from NanoString's GeoScriptHub 
(link pending)

## Installation

### Install the release version from tarball
``` r
install.packages("path/to/SpatialOmicsOverlay_0.99.11.tar.gz", 
                 dependencies = TRUE, repos = NULL)
```

### Install the development version from GitHub
``` r
if (!requireNamespace("devtools", quietly=TRUE))
    install.packages("devtools")
    
devtools::install_github("Nanostring-Biostats/SpatialOmicsOverlay", 
                         build_vignettes = TRUE, ref = "dev")
```

## Documentation

To learn how to start using SpatialOmicsOverlay, view documentation for the
version of this package installed in your system, start R and enter:

``` r
browseVignettes("SpatialOmicsOverlay")
```

or download vignette from NanoString website
(pending)

## Branches
The release version on GeoScriptHub is the stable version.
(link pending)

The dev branch on GitHub is under active development and no guarantee 
is made on usability at any given time.
<https://github.com/Nanostring-Biostats/SpatialOmicsOverlay>

## Citation
Griswold, M.
SpatialOmicsOverlay: Spatial Overlay for Omic Data From Nanostring GeoMx data. 
R Package Version 0.99.10. 
NanoString Technologies Inc.; Seattle, WA 98109, USA. 2021. 

## License
This project is licensed under the [MIT license](LICENSE).
