# ###########################
# CONFIG: define paths and filenames for later reference
# ###########################

# Change the basepath depending on your system

basepath <- rprojroot::find_rstudio_root_file()

# Main directories
dataloc <- file.path(basepath, "data","replication_data")
interwrk <- file.path(basepath, "data","interwrk")
hindexloc <- file.path(basepath, "data","h_index_data")
TexIncludes <- file.path(basepath, "text","includes" )
Outputs <- file.path(basepath, "analysis" )

programs <- file.path(basepath,"programs")

for ( dir in list(dataloc,interwrk,hindexloc,TexIncludes,Outputs)){
	if (file.exists(dir)){
	} else {
	dir.create(file.path(dir))
	}
}
