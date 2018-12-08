# This program downloads the data created by the replicators from the
# Google sheets noted in the config.R file
# and saves the csv/R files in the data/replications_data folder
# You may need to issue the gs_auth() function first
# gs_auth()

# -------------------------------------
# Extract Entry Questionnaire and Save
# -------------------------------------

# Extract Google Sheet Information Object
entryQ.gs <- gs_key(entry_KEY)

# Print worksheet names
gs_ws_ls(entryQ.gs)

# Extract Entry Questionnaire and tidy
entryQ <- entryQ.gs %>% gs_read(ws = "Form Responses 1")
names(entryQ) <- sub("\\?","",names(entryQ))

# Save
saveRDS(entryQ,file = file.path(dataloc,"entryQ.Rds"))
write.csv(entryQ,file = file.path(dataloc,"entryQ.csv"))

# -------------------------------------
# Extract Exit Questionnaire and Save
# -------------------------------------

# Extract Google Sheet Information Object
exitQ.gs <- gs_key(exit_KEY)

# Print worksheet names
gs_ws_ls(exitQ.gs)

# Extract Exit Questionnaire and tidy (This should now work after changing permissions)
exitQ  <- exitQ.gs  %>% gs_read(ws = "Form Responses 1")
names(exitQ) <- sub("\\?","",names(exitQ))

# Save
saveRDS(exitQ,file = file.path(dataloc,"exitQ.Rds"))
write.csv(exitQ,file = file.path(dataloc,"exitQ.csv"))

# -------------------------------------
# Extract Replication Sheets and Save
# -------------------------------------

# Extract Google Sheet Information Object
replication_list.gs <- gs_key(replication_list_KEY)

# Print worksheet names
gs_ws_ls(replication_list.gs)

# Iterate over each of the multiple sheets
ws <- gs_ws_ls(replication_list.gs)
for (x in 1:length(ws)) {

  # Extract list and tidy
	tmp.ws <- gs_read(replication_list.gs,ws=x)
	tmp.ws$worksheet <- ws[x]
	names(tmp.ws) <- sub("\\?","",names(tmp.ws))

	# Save
	saveRDS(tmp.ws,file = file.path(dataloc,paste0("replication_list_",x,".Rds")))
	write.csv(tmp.ws,file = file.path(dataloc,paste0("replication_list_",x,".csv")))

	# Pause so Google doesn't freak out
	Sys.sleep(10)
	rm(tmp.ws)

}

# Export the worksheet names to be used in a later data cleaning step
# This allows us to skip the "2009 missing online material" sheet, which
# has a different structure, in the next program.
ws <- as.data.frame(ws)
ws$date <- Sys.Date()
saveRDS(ws,file=file.path(dataloc,"mapping_ws_nums.Rds"))

# -------------------------------------
# Miscellaneous stuff to be tidied
# -------------------------------------

# The variable names are not consistent across all the ws
#names_wide <- names
#namevector <- unique(names$varname)
#names_wide[,namevector] <- NA
#for ( i in namevector ) {
#  names_wide[,i] <- as.numeric(names_wide[,1] == i)
#}
#sum_names <- names_wide %>% group_by(ws) %>% select(-varname) %>% summarize_all(funs(sum))
#sum_names$date <- Sys.Date()
#saveRDS(sum_names,file=file.path(dataloc,"varnames.Rds"))
