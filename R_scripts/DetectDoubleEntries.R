library(jsonlite)


# Check whether each element of a vector is contained in a list: 

sapply(List, function(x) Vector %in% x)
mapply(function(x, y) {x %in% y}, list(Vector), List)
vapply(List, function(x) Vector %in% x, logical(length(Vector)))

# The above commands can be used to check for repetitions among the entries of a vector: 

v <- 1:16

sapply(v, function(x) v %in% x)
mapply(function(x, y) {x %in% y}, list(v), v)
vapply(v, function(x) v %in% x, logical(length(v)))



# Building blocks for the loop: 

LobbyData <- fromJSON(paste0("http://lobbywatch.ch/de/data/interface/v1/json/table/parlamentarier/aggregated/id/", 5))

colnames(LobbyData[["data"]][["interessenbindungen"]])


class(LobbyData[["data"]][["interessenbindungen"]]$organisation_id)

v <- LobbyData[["data"]][["interessenbindungen"]]$organisation_id

m <- vapply(v, function(x) v %in% x, logical(length(v)))

class(m)

names(m)

m[1,3]

grep("TRUE", m, value = FALSE) 

length(grep("TRUE", m, value = FALSE)) == dim(m)[1]

DoubleEntryControl_Vector <- integer()

if(length(grep("TRUE", m, value = FALSE)) == dim(m)[1]){
	append(DoubleEntryControl_Vector[i], 0)}else{
		append(DoubleEntryControl_Vector[i], 1)
		}


# Looop through the data base to find double entries in 'LobbyData[["data"]][["interessenbindungen"]]$organisation_id': 

rm(list=ls())

DoubleEntryControl_Vector <- integer()
for(i in 1:500){
	LobbyData <- fromJSON(paste0("http://lobbywatch.ch/de/data/interface/v1/json/table/parlamentarier/aggregated/id/", i))
	if(LobbyData[["count"]]==1 & is.null(LobbyData[["data"]][["partei_id"]])==FALSE){
		v <- LobbyData[["data"]][["interessenbindungen"]]$organisation_id
		m <- vapply(v, function(x) v %in% x, logical(length(v)))
		if(length(grep("TRUE", m, value = FALSE)) == dim(m)[1]){
	DoubleEntryControl_Vector <- append(DoubleEntryControl_Vector, 0)}else{
		DoubleEntryControl_Vector <- append(DoubleEntryControl_Vector, 1)
		}
			}else{DoubleEntryControl_Vector <- append(DoubleEntryControl_Vector, 0)
			}
}



Parla_ID_DoubleEntries <- grep(1, DoubleEntryControl_Vector, value = FALSE)


# Check data of individual parlamentarians (adapt ID in the code accordingly): 

LobbyData <- fromJSON(paste0("http://lobbywatch.ch/de/data/interface/v1/json/table/parlamentarier/aggregated/id/", 314))

v <- LobbyData[["data"]][["interessenbindungen"]]$organisation_id
v
