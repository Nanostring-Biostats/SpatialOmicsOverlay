\name{SpatialPosition-class}
\docType{class}

\alias{class:SpatialPosition}
\alias{SpatialPosition-class}

% constructors
\alias{SpatialPosition}
\alias{SpatialPosition,environment-method}
\alias{SpatialPosition,data.frame-method}
\alias{SpatialPosition,matrix-method}
\alias{SpatialPosition,missing-method}

% show
\alias{show,SpatialPosition-method}

% accessing
\alias{meta}
\alias{meta,SpatialPosition-method}
\alias{position}
\alias{position,SpatialPosition-method}
\alias{spatialPos}
\alias{spatialPos,SpatialPosition-method}

\title{Class to Contain NanoString Spatial Overlay ROI information}

\description{
  The \code{SpatialPosition} class organizes the pertinant ROI specific information 
  from the OME-TIFFs
}

\usage{
  SpatialPosition(position)
}

\arguments{
  \item{position}{\code{data.frame} containing information from the OME-TIFF:
  
                    \code{"ROILabel"} order of ROIs
                    
                    \code{"Sample_ID"} unique identifier 
                    
                    \code{"Height"} total height of ROI 
                    
                    \code{"Width"} total width of ROI
                    
                    \code{"X"} top left corner (x coordinate) of ROI in total scan 
                    
                    \code{"Y"} top left corner (y coordinate) of ROI in total scan 
                    
                    \code{"Segmentation"} part of segmented ROI 
                    
                    \code{"Position"} base64 encoding of coordinates}
}

\section{Accessing}{
  \code{SpatialPosition} objects have the following accessor methods:
    \describe{
      \item{}{
        \code{spatialPos(object)}: returns SpatialPosition object
      }
      \item{}{
        \code{meta(object)}: extracts the metadata for each ROI, does not include the base64 encoding.
      }
      \item{}{
        \code{position(object)}: extracts the base64 encoding for each ROI, CAUTION: very long strings.
      }
    }
}

\value{
  An S4 class containing image data from a NanoString GeoMx experiment
}

\author{Maddy Griswold}

\seealso{
  \code{\link{SpatialOverlay-class}}
  
  \code{\link{parseOverlayAttrs}}
}

\keyword{classes}
\keyword{methods}