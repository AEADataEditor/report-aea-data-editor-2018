#' ---
#' local libraries


#' Define the list of libraries
libraries <- c("dplyr","devtools","googlesheets","rcrossref","readr","tidyr","summarytools")

#install_github("cboettig/knitcitations")
#install.packages("knitcitations")
#require(knitcitations)

results <- sapply(as.list(libraries), pkgTest)
cbind(libraries,results)
