

getwd()

setwd("/Documents/LobbyWatch")

library(jsonlite)

# Investigating party ids: 

Partei_ids <- fromJSON("https://lobbywatch.ch/de/data/interface/v1/json/table/partei/flat/list")

class(Partei_ids)

class(Partei_ids[["data"]])

dim(Partei_ids[["data"]])

colnames(Partei_ids[["data"]])


Partei_ids[["data"]][,c(1,4)]
#                                anzeige_name id
#1      Freisinnig-Demokratische Partei (FDP)  1
#2                  Grünliberale Partei (GLP)  2
#3            Sozialdemokratische Partei (SP)  3
#4             Grüne Partei der Schweiz (GPS)  4
#5           Schweizerische Volkspartei (SVP)  5
#6             Evangelische Volkspartei (EVP)  6
#7  Christlichdemokratische Volkspartei (CVP)  7
#8      Bürgerlich-Demokratische Partei (BDP)  8
#9           Mouvement Citoyens Romands (MCR)  9
#10                  Lega dei Ticinesi (Lega) 10

# Conclusion: According to the above list, there are only ten parties, i.e. 10 party ids in total. In reality there are more than ten parties and more than ten ids (see below). This list needs to be completed!

#---------------------------------------------------------------------------------------------

# Create a matrix with all parlamentarians' names, with their corresponding party name and party code: 

Name_Partei_ParteiID <- matrix(, nrow = 0, ncol = 3)


for(i in 1:400){
	LobbyData <- fromJSON(paste0("http://lobbywatch.ch/de/data/interface/v1/json/table/parlamentarier/aggregated/id/", i))
	if(LobbyData[["count"]]==1 & is.null(LobbyData[["data"]][["partei_id"]])==FALSE){
		Name_Partei_ParteiID <- rbind(Name_Partei_ParteiID, matrix(c(LobbyData[["data"]][["name"]], LobbyData[["data"]][["partei"]], as.integer(LobbyData[["data"]][["partei_id"]])), nrow =1, ncol = 3))
	}
}

# Create a legend of numerical party code (which numbers stands for which party name):

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

Partei_Code


save(Partei_Code, file = "Partei_Code_25.4.16.RData")

getwd()

setwd("/Documents/LobbyWatch")

load("Partei_Code_25.4.16.RData")

#-----------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------

# Automate query for special interest connections (Interessenbindungen) of parlamentarians: 

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

# Create loop that downloads all the entries for parlamentarians puts all the entries in a list (see above). Every list member is an empty vector that can grow with every reiteration. For each party id there is one list member, i.e. each list member index corresponds to a party id (1 - 16). The condition makes sure that only information of real entries ("count" must equal 1) are taken. Only parlamentarians that are members of a party are considered (so Thomas Minder will not be considered; "partei_id" must not be Null). It appears that the number of rows in the column 'organisation_name' in the data frame 'interessenbindungen' equals the number of special interest connections (Interessenbindungen) of a parlamentarian. Hence, this is the value taken to be put in the list created above. 

for(i in 1:500){
	LobbyData <- fromJSON(paste0("http://lobbywatch.ch/de/data/interface/v1/json/table/parlamentarier/aggregated/id/", i))
	if(LobbyData[["count"]]==1 & is.null(LobbyData[["data"]][["partei_id"]])==FALSE){
		empty_list[[as.integer(LobbyData[["data"]][["partei_id"]])]] <- append(empty_list[[as.integer(LobbyData[["data"]][["partei_id"]])]], length(LobbyData[["data"]][["interessenbindungen"]]$organisation_name))
	}
}

# Since the list is no longer empty it is appropriately renamed: 

Interessenbindungen_Liste <- empty_list

# Interestingly, if the data base and my code is correct, there are quite some parlamentarians with 0 special interest connections!

# Calculating mean of special interest connections for every party (sapply can be applied to a list but returns a vector):

Interessenbindungen_averages <- sapply(Interessenbindungen_Liste, mean)


# Calculating the total number of parlamentarians I considered to check whether I got them all: 

Interessenbindungen_AnzahlParlamentarier <- sapply(Interessenbindungen_Liste, length)
sum(Interessenbindungen_AnzahlParlamentarier)
# The total sum is 245. Total number of parlamentarians is 246: 200 (Nationalräte) + 46 (Ständeräte) = 246 (Vereinigte Bundesversammlung). Thomas Minder is not considered (no party affiliation), so 245 is exactly right. 

getwd()

setwd("/Documents/LobbyWatch")

save(Interessenbindungen_Liste, Interessenbindungen_averages, Interessenbindungen_AnzahlParlamentarier, file = "Interessenbindungen_25.4.16.RData")

load("Interessenbindungen_25.4.16.RData")


# Presenting the averages of special interest connections per parlamentarian for each party as a graphic: 

Interessenbindungen_averages

Interest_Frame <- data.frame(Interessenbindungen_averages, Partei_Code[,2], Partei_Code[,1])

colnames(Interest_Frame) <- c("Interessenbindungen", "Partei", "Partei_ID")

Interest_Vector <- Interest_Frame$Interessenbindungen

Interessenbindungen_Matrix <- matrix(Interest_Vector, nrow = 1, byrow=TRUE)

Interessenbindungen_Frame <- data.frame(Interessenbindungen_Matrix)

colnames(Interessenbindungen_Frame) <- Interest_Frame[,2]


# Results: 

Interest_Frame


#   Interessenbindungen Partei Partei_ID
#1             4.222222    FDP         1
#2             4.285714    GLP         2
#3             4.509091     SP         3
#4             5.181818    GPS         4
#5             3.700000    SVP         5
#6             5.500000    EVP         6
#7             4.825000    CVP         7
#8             6.125000    BDP         8
#9             3.000000    MCR         9
#10            2.500000   Lega        10
#11            6.000000    CSP        11
#12                 NaN      0         0
#13            5.000000    PdA        13
#14                 NaN      0         0
#15            6.000000  BastA        15
#16            0.000000    LDP        16


boxplot(Interessenbindungen_Frame, vert = T, method= "jitter")

stripchart(Interest_Frame$Interessenbindungen~Interest_Frame$Partei)

barplot(height = Interest_Frame$Interessenbindungen, width = 1, legend.text = Interest_Frame$Partei)

colors = rainbow(16)

barplot(height = Interest_Frame$Interessenbindungen, width = 1, space = 0.5, col = colors, names.arg = Interest_Frame$Partei, main = "Durchschnittliche Anzahl Interessenbindungen pro Parlamentarier")