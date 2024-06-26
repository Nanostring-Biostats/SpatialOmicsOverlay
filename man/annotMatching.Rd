% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/xmlParsing.R
\name{annotMatching}
\alias{annotMatching}
\title{Match ROIs in annotation file to xml}
\usage{
annotMatching(annots, ROInum, maskNum, maskText, segCol = NULL)
}
\arguments{
\item{annots}{df of annotations}

\item{ROInum}{ROI number from xml file}

\item{maskNum}{number of masks for ROI, used for AOI matching in software 
<= v2.4}

\item{maskText}{segment name, used for AOI matching in software v2.4+}

\item{segCol}{column containing segment name, if NULL function will determine automatically}
}
\value{
df with ROI unique identifiers
}
\description{
Match ROIs in annotation file to xml
}
