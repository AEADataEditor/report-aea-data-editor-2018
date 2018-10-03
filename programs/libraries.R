#' ---
#' title: "Installing and loading all libraries"
#' author: "Lars Vilhuber"
#' date: "March 30, 2017"
#' ---

#' utility program to check and install libraries if necessary.
#' It is called by the other programs
#' The first time this is run, it might take a while.
#' This can also be run independently, to install all necessary packages
#' beforehand.

pkgTest <- function(x)
{
  if (!require(x,character.only = TRUE))
  {
    install.packages(x,dep=TRUE)
    if(!require(x,character.only = TRUE)) stop("Package not found")
  }
  return("OK")
}

#' Define the list of libraries
libraries <- c("plyr","reshape2","data.table","dplyr","magrittr","stargazer","ggplot2","RefManageR","devtools","bibtex","knitcitations","googlesheets")

#install_github("cboettig/knitcitations")
#install.packages("knitcitations")
#require(knitcitations)

results <- sapply(as.list(libraries), pkgTest)
cbind(libraries,results)
