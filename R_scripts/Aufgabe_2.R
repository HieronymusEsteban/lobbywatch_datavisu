

# --------------------------------------------------------------------------------------------

# Getting the average number of mandates per guest (Zutrittsberechtiger) in the different parties: party being the party of the parlamentarian that the guest is admitted by: 


library(jsonlite)


# For example: Guest (Zutrittsberechtigter) with id 111: 
LobbyData_Ex <- fromJSON("http://lobbywatch.ch/de/data/interface/v1/json/table/zutrittsberechtigung/aggregated/id/111")

LobbyData_Ex <- fromJSON("http://lobbywatch.ch/de/data/interface/v1/json/table/zutrittsberechtigung/aggregated/id/7")


# --------------------------------------------------------------------------------------------
# Get a vector containing all guest IDs: 

rm(list=ls())

empty_vector <- integer()

for(i in 1:500){
	
	LobbyData <- fromJSON(paste0("http://lobbywatch.ch/de/data/interface/v1/json/table/zutrittsberechtigung/aggregated/id/",i))
	
	if(LobbyData[["count"]]==1 & is.null(LobbyData[["data"]][["parlamentarier_name"]])==FALSE){
		
		empty_vector <- append(empty_vector, as.integer(LobbyData[["data"]][["id"]]))
		}
		}

Zutritt_id_vector <- empty_vector
length(Zutritt_id_vector)


# Now I have all the guest ids that are still in use (a lot of ids lead to empty entries, now I have only those leading to "real" entries).


# --------------------------------------------------------------------------------------------

# What kind of data do I get?

LobbyData_Ex <- fromJSON("http://lobbywatch.ch/de/data/interface/v1/json/table/zutrittsberechtigung/aggregated/id/497")

names(LobbyData_Ex[["data"]])

LobbyData_Ex[["data"]][["parlamentarier_name"]]

LobbyData_Ex[["data"]][["name"]]

# For example: Urs Müller-Walz is a guest (Zutrittsberechtigter) of Arslan Sibel. 

# --------------------------------------------------------------------------------------------

# Create a list for all guests, containing the information of interest about each guest (id, name, number of mandates, parlamentarian id, and parlamentarian name): 

empty_list <- as.list(rep(0,length(Zutritt_id_vector)))

for(i in 1:length(Zutritt_id_vector)){
	
	LobbyData <- fromJSON(paste0("http://lobbywatch.ch/de/data/interface/v1/json/table/zutrittsberechtigung/aggregated/id/", Zutritt_id_vector[i]))
	
	if(LobbyData[["count"]]==1 & is.null(LobbyData[["data"]]
	[["parlamentarier_name"]])==FALSE){
		
		empty_list[[i]] <- list(LobbyData[["data"]][["id"]], LobbyData[["data"]][["name"]], nrow(LobbyData[["data"]][["mandate"]]), LobbyData[["data"]][["parlamentarier_id"]], LobbyData[["data"]][["parlamentarier_name"]])
	
		names(empty_list[[i]]) <- c("zutrittsberechtigter_id", "zutrittsberechtigter_name", "anzahl_mandate", "parlamentarier_id", "parlamentarier_name")
		}
		}

Zutritt_list <- empty_list

# --------------------------------------------------------------------------------------------
# OK, just checking what kind of information I got: 

class(Zutritt_list)

length(Zutritt_list)

length(Zutritt_list[[7]])

names(Zutritt_list[[7]])

Zutritt_list[[7]][["parlamentarier_name"]]

Zutritt_list[[1]][["parlamentarier_id"]]

Zutritt_list[[1]][["anzahl_mandate"]]

Zutritt_list[[1]][["zutrittsberechtigter_name"]]

Zutritt_list[[1]][["parlamentarier_name"]]

Zutritt_list[[1]][[1]]
#[1] "3"
Zutritt_id_vector[1]
#[1] 3
Zutritt_list[[2]][[1]]
#[1] "4"
Zutritt_id_vector[2]
#[1] 4
Zutritt_list[[3]][[1]]
#[1] "7"
Zutritt_id_vector[3]
#[1] 7
Zutritt_id_vector[11]
#[1] 26
Zutritt_list[[11]][[1]]
#[1] "26"
Zutritt_list[[111]][[1]]
#[1] "243"
Zutritt_id_vector[111]
#[1] 243
Zutritt_list[[200]][[1]]
#[1] "426"
Zutritt_id_vector[200]
#[1] 426

#LobbyData <- fromJSON(paste0("http://lobbywatch.ch/de/data/interface/v1/json/table/parlamentarier/aggregated/id/", Zutritt_list[[1]][["parlamentarier_id"]]))


# --------------------------------------------------------------------------------------------
# Check whether there is a guest (Zutrittsberechtigter) who is admitted by more than one parlamentarian: 

empty_vector <- integer()

for(i in 1:length(Zutritt_id_vector)){
	if(length(Zutritt_list[[i]][[4]])>1){
		empty_vector <- append(empty_vector, i)
		}
		}

zutritt_index_MehrParla <- empty_vector
zutritt_index_MehrParla

# Answer: There is none. 

# --------------------------------------------------------------------------------------------

# Now creating a list that attributes the numbers of mandates of guests to the parties of their respective parlamentarians. First create an empty list where each member of the list is again an empty list and stands for a party. The index of the list member corresponds to the party id: 

LobbyData[["data"]][["partei_id"]]


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


# Get the data from the parlamentarier table for all the guest ids (the ones leading to real guest entries). Take the party ids from that data and use it as an index to attribute the guest mandate data from Zutritt_list to the newly created empty list: 

for(i in 1:length(Zutritt_list)){
	LobbyData <- fromJSON(paste0("http://lobbywatch.ch/de/data/interface/v1/json/table/parlamentarier/aggregated/id/", Zutritt_list[[i]][["parlamentarier_id"]]))
	if(LobbyData[["count"]]==1 & is.null(LobbyData[["data"]][["partei_id"]])==FALSE){
		empty_list[[as.integer(LobbyData[["data"]][["partei_id"]])]] <- append(empty_list[[as.integer(LobbyData[["data"]][["partei_id"]])]], Zutritt_list[[i]][["anzahl_mandate"]]
)
		}
		}

Mandate_partei <- empty_list
Mandate_partei

Mandate_averages <- sapply(Mandate_partei, mean)
length(Mandate_averages)


load("Partei_Code_25.4.16.RData")

source("Functions.R")

Name_Partei_ParteiID <- f.parla_name_partei(1:500)

Partei_Code <- f.partei_code(Name_Partei_ParteiID)


Mandate_Frame <- data.frame(Mandate_averages, Partei_Code[,2], Partei_Code[,1])

colnames(Mandate_Frame) <- c("Anzahl_Mandate", "Partei", "Partei_ID")

Mandate_Frame$Anzahl_Mandate

Mandate_Frame_clean <- Mandate_Frame[Mandate_Frame$Partei!=0,]

Mandate_Frame_clean$Anzahl_Mandate <- replace(Mandate_Frame_clean$Anzahl_Mandate, Mandate_Frame_clean$Anzahl_Mandate=="NaN", 0)

Mandate_Frame_final <- Mandate_Frame_clean

#colors = rainbow(16)

# I only use 14 different colors even though there are 16 party ID's. This is because two party ID's are "empty" (ID's) i.e. they have not been attributed an party. 
colors = c("royalblue4", "darkolivegreen3", "red3", "green3", "darkgreen", "gold", "orange", "black", "darkorange3", "turquoise", "orange3", "red", "orangered", "royalblue")

barplot(height = Mandate_Frame_final$Anzahl_Mandate, width = 1, space = 0.5, col = colors, names.arg = Mandate_Frame_final$Partei, main = "Durchschnittliche Anzahl Mandate pro Zutrittsberechtigter")

getwd()

setwd("/Documents/LobbyWatch")

save(Partei_Code, Zutritt_id_vector, Zutritt_list, Mandate_partei, file= "Mandate_12.5.16.RData")


