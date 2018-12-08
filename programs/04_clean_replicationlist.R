# We clean up additional variables on repllist (which is manually coded)
# 

# Restrict the variables
repllist2 <- readRDS(file=file.path(interwrk,"replication_list_2.Rds"))  %>% 
	select(DOI,`Entry Questionnaire`,`Entry Questionnaire Author`,
		   `Expected Difficulty`,Replicator,Completed,Replicated,
		   `2nd Replicator`,Completed_1,Replicated_1,
		   `Data Type`,`Data Access Type`,`Data URL`,`Data Contact`,
		   `Start-time`,`End-time`,`Main Issue`,
		   `Data Access Type: restricted`,`Data Access Type: public`,`Data Access Type: Unknown`) 

# merge on biblio information 
bibinfo.df <- readRDS(file=file.path(interwrk,"crossref_info.Rds"))
repllist3 <- left_join(repllist2,bibinfo.df,by="DOI")
saveRDS(repllist3,file=file.path(interwrk,"replication_list_3.Rds"))

# The variable Replicated is a bit noisy:

table(repllist3$Replicated)

# We recode
val.partial <- c("partial","partially","partly","yes(?) table 3 still unable to replicate","mostly")
val.yes <- c("yes","y")


repllist4 <- repllist3 %>% 
	mutate(replicated_clean = 
		   	ifelse(tolower(Replicated) %in% val.partial,
				  "partially",
				  ifelse(tolower(Replicated) %in% val.yes,
				  "yes",
				  tolower(Replicated))
		   )
	)


# 













saveRDS(repllist4,file=file.path(interwrk,"replication_list_clean.Rds"))
