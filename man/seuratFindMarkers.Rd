% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/seuratFunctions.R
\name{seuratFindMarkers}
\alias{seuratFindMarkers}
\title{seuratFindMarkers}
\usage{
seuratFindMarkers(
  inSCE,
  cells1 = NULL,
  cells2 = NULL,
  group1 = NULL,
  group2 = NULL,
  allGroup = NULL,
  conserved = FALSE
)
}
\arguments{
\item{inSCE}{Input \code{SingleCellExperiment} object.}

\item{cells1}{A \code{list} of sample names included in group1.}

\item{cells2}{A \code{list} of sample names included in group2.}

\item{group1}{Name of group1.}

\item{group2}{Name of group2.}

\item{allGroup}{Name of all groups.}

\item{conserved}{Logical value indicating if markers conserved between two
groups should be identified. Default is \code{FALSE}.}
}
\value{
A \code{SingleCellExperiment} object that contains marker genes populated in a data.frame stored inside metadata slot.
}
\description{
seuratFindMarkers
}
