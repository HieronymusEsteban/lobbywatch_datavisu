
#-----------------------------------------------------------------------------------
# Create a matrix with all parlamentarians' names, with their corresponding party name and party code: 


f.parla_name_partei <- function(indices_vector){
	Name_Partei_ParteiID <- matrix(, nrow = 0, ncol = 3)
	for(i in indices_vector){
		LobbyData <- fromJSON(paste0("http://lobbywatch.ch/de/data/interface/v1/json/table/parlamentarier/aggregated/id/", i))
			if(LobbyData[["count"]]==1 & is.null(LobbyData[["data"]][["partei_id"]])==FALSE){
		Name_Partei_ParteiID <- rbind(Name_Partei_ParteiID, matrix(c(LobbyData[["data"]][["name"]], LobbyData[["data"]][["partei"]], as.integer(LobbyData[["data"]][["partei_id"]])), nrow =1, ncol = 3))
			}
	}
	return(Name_Partei_ParteiID)
					}

#-----------------------------------------------------------------------------------				
# Create a legend of numerical party code (which numbers stands for which party name). The function applies to matrices with three columns. The first column must contain the parlamentarian's name, the second one must contain the party name and the third one must contain the party ID. 

f.partei_code <- function(Name_Partei_ParteiID){
	Partei_Code_vector <- rep(0, 32)
	Partei_Code <- matrix(Partei_Code_vector, ncol = 2)
	for(i in 1:16){
		Parlamentarier <- Name_Partei_ParteiID[Name_Partei_ParteiID[,3]==i,]
		if(class(Parlamentarier)=="character"){
						Partei_Code[i,1] <- Parlamentarier[3]
						Partei_Code[i,2] <- Parlamentarier[2]
						}else{
							if(is.matrix(Parlamentarier)==TRUE){
								if(dim(Parlamentarier)[1] > 0){
								Partei_Code[i,1] <- Parlamentarier[1,3]
								Partei_Code[i,2] <- Parlamentarier[1,2]}
							}
						}
	}
	return(Partei_Code)
}


#-----------------------------------------------------------------------------------
# Automate query for special interest connections (Interessenbindungen) of parlamentarians: 

# Create loop that downloads all the entries for parlamentarians puts all the entries in a list (see above). Every list member is an empty vector that can grow with every reiteration. For each party id there is one list member, i.e. each list member index corresponds to a party id (1 - 16). The condition makes sure that only information of real entries ("count" must equal 1) are taken. Only parlamentarians that are members of a party are considered (so Thomas Minder will not be considered; "partei_id" must not be Null). It appears that the number of rows in the column 'organisation_name' in the data frame 'interessenbindungen' equals the number of special interest connections (Interessenbindungen) of a parlamentarian. Hence, this is the value taken to be put in the list.

f.interessenbindungen_parla_partei <- function(indices_vector){
	
empty_vector_1 <- integer()
empty_vector_2 <- integer()
empty_vector_3 <- integer()
empty_vector_4 <- integer()
empty_vector_5 <- integer()
empty_vector_6 <- integer()
empty_vector_7 <- integer()
empty_vector_8 <- integer()
empty_vector_9 <- integer()
empty_vector_10 <- integer()
empty_vector_11 <- integer()
empty_vector_12 <- integer()
empty_vector_13 <- integer()
empty_vector_14 <- integer()
empty_vector_15 <- integer()
empty_vector_16 <- integer()


empty_list <- list(empty_vector_1, empty_vector_2, empty_vector_3, empty_vector_4, empty_vector_5, empty_vector_6, empty_vector_7, empty_vector_8, empty_vector_9, empty_vector_10, empty_vector_11, empty_vector_12, empty_vector_13, empty_vector_14, empty_vector_15, empty_vector_16)

for(i in indices_vector){
	LobbyData <- fromJSON(paste0("http://lobbywatch.ch/de/data/interface/v1/json/table/parlamentarier/aggregated/id/", i))
	if(LobbyData[["count"]]==1 & is.null(LobbyData[["data"]][["partei_id"]])==FALSE){
		empty_list[[as.integer(LobbyData[["data"]][["partei_id"]])]] <- append(empty_list[[as.integer(LobbyData[["data"]][["partei_id"]])]], length(LobbyData[["data"]][["interessenbindungen"]]$organisation_name))
	}
}
Interessenbindungen_Liste <- empty_list
return(Interessenbindungen_Liste)
}


