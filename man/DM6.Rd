% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/DM6-full_table.R
\name{DM6}
\alias{DM6}
\title{DM6_full_table.tsv}
\format{
\code{BUSCO}, a tab delimited file created by the software \code{BUSCO}.
The first line is prefixed with a '#' and states the BUSCO version.
The second line is prefixed with a '#' and describes the lineage dataset.
The third line is prefixed with a '#' and is a header that describes the columns in subsequent rows.
\describe{
\item{Busco id}{Unique identifier for each BUSCO gene.}
\item{Status}{Copy number status for each gene (Fragmented, Complete, Duplicated, or Missing).}
\item{Sequence}{The sequence (chromosome, scaffold, contig) where the BUSCO was found.}
\item{Gene Start}{Start position for the BUSCO gene.}
\item{Gene End}{End position for the BUSCO gene.}
\item{Strand}{Strand the gene was determined to be from (+, -).}
\item{Score}{Score for match.}
\item{Length}{Length of match.}

}
}
\source{
\itemize{
\item Genomic scaffolds (FASTA format): \url{http://spuddb.uga.edu/dm_v6_1_download.shtml}
\item BUSCO (software): \url{https://busco.ezlab.org/}
}
}
\description{
This is an output file that has resulted from processing the potato 'DM6' genomic assembly with BUSCO.
The plant 'DM6' was a doubled monoploid potato.
While potato is expected to be tetraploid, this doubled monoploid (DM) plant is expected to be monoploid throughout it's genome.
This means that we expect most BUSCO genes to have a 'Status' of 'Complete' (single copy).
}
