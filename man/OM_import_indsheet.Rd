% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/OM_import_indsheet.R
\name{OM_import_indsheet}
\alias{OM_import_indsheet}
\title{Imports data from UKPDS-OM2 worksheet}
\usage{
OM_import_indsheet(path, variable, sheet = NULL)
}
\arguments{
\item{path}{Path to UKPDS-OM2 workbook}

\item{variable}{Variable to import (see variables in ukpdstools::ukpds_sheetnames)}

\item{sheet}{Specify sheet name if different from those in ukpdstools::ukpds_sheetnames}
}
\value{
Imported data from UKPDS-OM2
}
\description{
Imports data from UKPDS-OM2 worksheet
}
\examples{
OM_import_indsheet(path, variable = "hdl")
}
