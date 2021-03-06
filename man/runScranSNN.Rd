% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/getCluster.R
\name{runScranSNN}
\alias{runScranSNN}
\title{Get clustering with SNN graph}
\usage{
runScranSNN(
  inSCE,
  useAssay = NULL,
  useReducedDim = NULL,
  useAltExp = NULL,
  altExpAssay = "counts",
  clusterName = "scranSNN_cluster",
  k = 10,
  nComp = 50,
  weightType = c("rank", "number", "jaccard"),
  algorithm = c("walktrap", "louvain", "infomap", "fastGreedy", "labelProp",
    "leadingEigen")
)
}
\arguments{
\item{inSCE}{A \code{\link[SingleCellExperiment]{SingleCellExperiment}}
object.}

\item{useAssay}{A single \code{character}, specifying which
\code{\link{assay}} to perform the clustering algorithm
on. Default \code{NULL}.}

\item{useReducedDim}{A single \code{character}, specifying which
low-dimension representation (\code{\link{reducedDim}})
to perform the clustering algorithm on. Default \code{NULL}.}

\item{useAltExp}{A single \code{character}, specifying the assay which
\code{\link{altExp}} to perform the clustering
algorithm on. Default \code{NULL}.}

\item{altExpAssay}{A single \code{character}, specifying which
\code{\link{assay}} in the chosen
\code{\link{altExp}} to work on. Only used when
\code{useAltExp} is set. Default \code{"counts"}.}

\item{clusterName}{A single \code{character}, specifying the name to store
the cluster label in \code{\link{colData}}. Default
\code{"scranSNN_cluster"}.}

\item{k}{An \code{integer}, the number of nearest neighbors used to construct
the graph. Smaller value indicates higher resolution and larger number of
clusters. Default \code{10}.}

\item{nComp}{An \code{integer}, the number of components to use when
\code{useAssay} or \code{useAltExp} is specified. WON'T work with
\code{useReducedDim}. Default \code{50}.}

\item{weightType}{A single \code{character}, that specifies the edge weighing
scheme when constructing the Shared Nearest-Neighbor (SNN) graph. Choose from
\code{"rank"}, \code{"number"}, \code{"jaccard"}. Default \code{"rank"}.}

\item{algorithm}{A single \code{character}, that specifies the community
detection algorithm to work on the SNN graph. Choose from \code{"walktrap"},
\code{"louvain"}, \code{"infomap"}, \code{"fastGreedy"}, \code{"labelProp"},
\code{"leadingEigen"}. Default \code{"walktrap"}.}
}
\value{
The input \code{\link[SingleCellExperiment]{SingleCellExperiment}}
object with \code{factor} cluster labeling updated in
\code{colData(inSCE)[[clusterName]]}.
}
\description{
Perform SNN graph clustering on a
\code{\link[SingleCellExperiment]{SingleCellExperiment}} object, with graph
construction by \code{\link[scran]{buildSNNGraph}} and graph clustering by
"igraph" package.
}
\examples{
data("mouseBrainSubsetSCE")
mouseBrainSubsetSCE <- runScranSNN(mouseBrainSubsetSCE,
                                   useReducedDim = "PCA_logcounts")
}
\references{
Aaron Lun and et. al., 2016
}
