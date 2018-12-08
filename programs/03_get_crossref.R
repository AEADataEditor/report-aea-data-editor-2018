# This program collects bibliographic information for all the DOIs read by the replicators from crossref
# To do: Need to also use exit questionnaire DOIs, some of which are not on replication lists

# Read dataframes of the 3 datasets created in previous files
repllist2 <- readRDS(file=file.path(interwrk,"replication_list_2.Rds")) %>% select(DOI)
exit <- readRDS(file=file.path(dataloc,"exitQ.Rds"))
entry <- readRDS(file=file.path(dataloc,"entryQ.Rds"))

# Gather DOIs
dois_toget <- unique(c(repllist2$DOI,exit$DOI,entry$DOI))

# Get citation information from Crossref (this can take a while).
tic.clear()
tic("Query to CrossRef")
bibinfo <- cr_cn(dois_toget, format = "bibentry")
toc(log=TRUE)

# Save bibliographic information object
saveRDS(bibinfo,file=file.path(dataloc,"crossref_query.Rds"))

# Convert to data frame
bibinfo.df <- lapply(bibinfo,function(x) as.data.frame(x)) %>% bind_rows() %>% distinct()
names(bibinfo.df)[1] <- "DOI"

# Save the information as dataframes
saveRDS(bibinfo.df,file=file.path(interwrk,"crossref_info.Rds"))
write.csv(bibinfo.df,file=file.path(interwrk,"crossref_info.csv"))

# Store log of time required to run
bibinfo.log <- tic.log(format=FALSE)
saveRDS(bibinfo.log,file=file.path(interwrk,"crossref_timing.Rds"))
