# This program downloads the data created by the replicators from the
# Google sheets noted in the config.R
# and saves the CSV / R/ DTA files in data/replications_data
# You may need to issue the gs_auth() function first
# 
# gs_auth()

entryQ.gs <- gs_key(entry_KEY)
exitQ.gs <- gs_key(exit_KEY)
replication_list.gs <- gs_key(replication_list_KEY)

gs_ws_ls(entryQ.gs)
gs_ws_ls(exitQ.gs)
gs_ws_ls(replication_list.gs)

entryQ <- entryQ.gs %>% gs_read(ws = "Form Responses 1")
names(entryQ) <- sub("\\?","",names(entryQ))
saveRDS(entryQ,file = file.path(dataloc,"entryQ.Rds"))
write.csv(entryQ,file = file.path(dataloc,"entryQ.csv"))

# this doesn't work yet
exitQ  <- exitQ.gs  %>% gs_read(ws = "Form Responses 1")
names(exitQ) <- sub("\\?","",names(exitQ))
saveRDS(exitQ,file = file.path(dataloc,"exitQ.Rds"))
write.csv(exitQ,file = file.path(dataloc,"exitQ.csv"))


## Accessing worksheet titled 'Form Responses 1'.
## Downloading: 74 kB     Error in stop_for_content_type(req, "text/csv") : Expected content-type:	text/csv
## Actual content-type:
##	text/html; charset=UTF-8
#exitQ <- readr::read_csv(file=file.path(basepath,"data","raw","Exit_Questionnaire_Draft (Responses) - Form Responses 1.csv"))

# There are multiple sheets on this one. We iterate over them
ws <- gs_ws_ls(replication_list.gs)
for (x in 1:length(ws)) {
	tmp.ws <- gs_read(replication_list.gs,ws=x)
	tmp.ws$worksheet <- ws[x]
	names(tmp.ws) <- sub("\\?","",names(tmp.ws))
	saveRDS(tmp.ws,file = file.path(dataloc,paste("replication_list_",x,".Rds",sep="")))
	write.csv(tmp.ws,file = file.path(dataloc,paste("replication_list_",x,".csv",sep="")))
	# pause so Google doesn't freak out
	Sys.sleep(10)
	rm(tmp.ws)
	rm(tmp)
}

# The variable names are not consistent across all the ws
names_wide <- names
namevector <- unique(names$varname)
names_wide[,namevector] <- NA
for ( i in namevector ) {
names_wide[,i] <- as.numeric(names_wide[,1] == i)
}
sum_names <- names_wide %>% group_by(ws) %>% select(-varname) %>% summarize_all(funs(sum))

# Fix a few things
# We will skip the "2009 missing online material", which has a different structure
# we do this in the next program. We save a few useful files
#
sum_names$date <- Sys.Date()
ws$date <- Sys.Date()
saveRDS(sum_names,file=file.path(dataloc,"varnames.Rds"))
saveRDS(ws,file=file.path(dataloc,"mapping_ws_nums.Rds"))


