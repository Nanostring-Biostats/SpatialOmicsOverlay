\name{SpatialOverlay-class}
\docType{class}

\alias{class:SpatialOverlay}
\alias{SpatialOverlay-class}

% constructors
\alias{SpatialOverlay}
\alias{SpatialOverlay,character-method}

% show
\alias{show,SpatialOverlay-method}

% accessing
\alias{slideName}
\alias{slideName,SpatialOverlay-method}
\alias{overlay}
\alias{overlay,SpatialOverlay-method}
\alias{scanMeta}
\alias{scanMeta,SpatialOverlay-method}
\alias{coords}
\alias{coords,SpatialOverlay-method}
\alias{plotFactors}
\alias{plotFactors,SpatialOverlay-method}
\alias{labWork}
\alias{labWork,SpatialOverlay-method}
\alias{outline}
\alias{outline,SpatialOverlay-method}
\alias{seg}
\alias{seg,SpatialOverlay-method}
\alias{scaleBarRatio}
\alias{scaleBarRatio,SpatialOverlay-method}
\alias{fluor}
\alias{fluor,SpatialOverlay-method}
\alias{sampNames}
\alias{sampNames,SpatialOverlay-method}
\alias{showImage}
\alias{showImage,SpatialOverlay-method}
\alias{res}
\alias{res,SpatialOverlay-method}
\alias{workflow}
\alias{workflow,SpatialOverlay-method}
\alias{scaled}
\alias{scaled,SpatialOverlay-method}
\alias{imageInfo}
\alias{imageInfo,SpatialOverlay-method}


\title{Class to Contain NanoString Spatial Overlay Images and Data}

\description{
  The \code{SpatialOverlay} class organizes the pertinant information from the 
  OME-TIFFs allowing for plotting on top of or beside the image
}

\usage{
  SpatialOverlay(slideName,
                 scanMetadata,
                 overlayData,
                 coords = NULL,
                 plottingFactors = NULL,
                 workflow = list(outline=FALSE,
                                 labWorksheet=TRUE,
                                 scaled=FALSE),
                 image = list(filePath = NULL,
                              imagePointer = NULL,
                              resolution = NULL))
}

\arguments{
  \item{slideName}{The name of the slide in the \code{SpatialOverlay} object}
  \item{scanMetadata}{A \code{list} containing the scan metadata: panel(s) used, 
                      Physical sizes (x,y) for scale bar, fluorescence data, and segmentation info}
  \item{overlayData}{An \code{\link{SpatialPosition}} containing individiual sample 
                     info: SampleID, Height, Width, X&Y coordinates in overall scan, 
                     segmentation, and base64 encoded position}
  \item{coords}{An optional \code{data.frame} with coordinates derived from the encoded position.}
  \item{plottingFactors}{An optional \code{data.frame} with annotations to plot on. 
                         These can be added using \code{\link{addPlottingFactor}}}
  \item{workflow}{A \code{list} containing meta-data on the processing workflow including
                  \code{"outline"}, \code{"labWorksheet"}, & \code{"scaled"}. These booleans are kept 
                  automatically in \code{\link{readSpatialOverlay}} and are used 
                  for logic gates in downstream processing}
  \item{image}{A \code{list} containing location of and pointer to the image:
               \code{"filePath"}, \code{"imagePointer"}, & \code{"resolution"}}
}

\section{Accessing}{
  \code{SpatialOverlay} objects have the following accessor methods:
    \describe{
      \item{}{
        \code{sampNames(object)}: extracts the sample names of each ROI in the slide.
      }
      \item{}{
        \code{slideName(object)}: extracts the slide name.
      }
      \item{}{
        \code{overlay(object)}: extracts the \code{SpatialPosition} information for each ROI.
      }
      \item{}{
        \code{scanMeta(object)}: extracts the scan metadata.
      }
      \item{}{
        \code{coords(object)}: extracts the coordinates for the entire scan.
      }
      \item{}{
        \code{plotFactors(object)}: extracts avaliable plotting factors.
      }
      \item{}{
        \code{labWork(object)}: extracts the boolean if a lab worksheet was used.
      }
      \item{}{
        \code{outline(object)}: extracts the boolena if only the outline points 
        were generated.
      }
      \item{}{
        \code{seg(object)}: extracts if there are any segmented ROIs in the slide.
      }
      \item{}{
        \code{scaleBarRatio(object)}: extracts the scale bar ratio from \code{scanMeta} 
        for the X axis
      }
      \item{}{
        \code{fluor(object)}: extracts fluorenscence information for the scan.
      }
      \item{}{
        \code{showImage(object)}: prints image.
      }
      \item{}{
        \code{res(object)}: extracts resolution of image.
      }
      \item{}{
        \code{workflow(object)}: extracts workflow data.
      }
      \item{}{
        \code{scaled(object)}: extracts if coordinates have been scaled.
      }
      \item{}{
        \code{imageInfo(object)}: extracts image data.
      }
    }
}

\value{
  An S4 class containing image data from a NanoString GeoMx experiment
}

\author{Maddy Griswold}

\seealso{
  \code{\link{readSpatialOverlay}}
}

\keyword{classes}
\keyword{methods}