% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/check_busco_table.R
\name{check_busco_table}
\alias{check_busco_table}
\title{Check a BUSCO table's format}
\usage{
check_busco_table(x)
}
\arguments{
\item{x}{A data.frame of BUSCO coordinates from a full_table.tsv}
}
\value{
A logical or an ERROR.
}
\description{
Check a BUSCO table's format
}
\examples{
DM6file <- system.file("extdata", "DM6_full_table.tsv.gz", package = 'BUSCOplot')
DM6 <- read_busco(DM6file)
chromL <- make_known(DM6, sample_name = "DM6:")
lapply(chromL[1:2], head, n=2)


}
