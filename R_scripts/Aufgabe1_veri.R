
library(jsonlite)


rm(list=ls())


# Load functions: 

setwd("/Documents/LobbyWatch")

source("Functions.R")


# Parlamentarians' IDs that the algorithm will be applied to: 
test_indices_1 <- 1:500 

 # Create a matrix from manually retrieved data (see excel file) as a comparison for the the matrix produced by my algorithm:
#Matrix_Manual <- matrix(c("Marina Carobbio Guscetti", "Ignazio Cassis", "SP", "FDP", "3", "1"), ncol = 3)

# Apply the algorithm to a limited amount of data (test_indices_1): 

Name_Partei_ParteiID <- f.parla_name_partei(test_indices_1)
Name_Partei_ParteiID

# Count the number of equal entries in both the manually and the automatically established matrix. All entries should be equal. Hence, the number of equal entries has to be equal to the total number of entries in the matrix (length(Matrix_Manual)):
#comparison <- sum(Name_Partei_ParteiID %in% Matrix_Manual, na.rm = TRUE) 
comparison
#length(Matrix_Manual)
#length(Name_Partei_ParteiID)

# Create a legend of numerical party code (which numbers stands for which party name):

Partei_Code <- f.partei_code(Name_Partei_ParteiID)
Partei_Code

# Compare with the manually retrieved party ID list: 
#Partei_Code_manual <- read.csv("/Documents/LobbyWatch/Partei_Code.csv", header = TRUE)
#Partei_Code_manual
#Partei_Code

# Automate query for special interest connections (Interessenbindungen) of parlamentarians: 


# Create loop that downloads all the entries for parlamentarians puts all the entries in a list (see above). Every list member is an empty vector that can grow with every reiteration. For each party id there is one list member, i.e. each list member index corresponds to a party id (1 - 16). The condition makes sure that only information of real entries ("count" must equal 1) are taken. Only parlamentarians that are members of a party are considered (so Thomas Minder will not be considered; "partei_id" must not be Null). It appears that the number of rows in the column 'organisation_name' in the data frame 'interessenbindungen' equals the number of special interest connections (Interessenbindungen) of a parlamentarian. Hence, this is the value taken to be put in the list created above.


Interessenbindungen_Liste <- f.interessenbindungen_parla_partei(test_indices_1)


Interessenbindungen_Liste # Compare with manually retrieved data on excel spreadsheet. 

Interessenbindungen_averages <- sapply(Interessenbindungen_Liste, mean)

Interest_Frame <- data.frame(Interessenbindungen_averages, Partei_Code[,2], Partei_Code[,1])

colnames(Interest_Frame) <- c("Interessenbindungen", "Partei", "Partei_ID")

Interest_Frame

#Interest_Frame_final <- na.omit(Interest_Frame) Not a terribly good idea: In case parties with zero average interest connections exist, they will not be considered since zero interest connections are reported as NaN (the mean of an empty vector or empty list produces NaN; remember the mean values are calculated based on the the entries in "Interessenbindungen_Liste"). A better way of filtering out the empty party IDs (party ID's that have not been attributed a party) is the following: 

Interest_Frame_clean <- Interest_Frame[Interest_Frame$Partei!=0,]
Interest_Frame_clean

# Then filter replace the "NaN" values with 0 (in this present case there are probably none but just to keep the code general): 

Interest_Frame_clean$Interessenbindungen <- replace(Interest_Frame_clean$Interessenbindungen, Interest_Frame_clean$Interessenbindungen=="NaN", 0)
Interest_Frame_clean

Interest_Frame_final <- Interest_Frame_clean

#colors = rainbow(16)

# I only use 14 different colors even though there are 16 party ID's. This is because two party ID's are "empty" (ID's) i.e. they have not been attributed an party. 
colors = c("royalblue4", "darkolivegreen3", "red3", "green3", "darkgreen", "gold", "orange", "black", "darkorange3", "turquoise", "orange3", "red", "orangered", "royalblue")

barplot(height = Interest_Frame_final$Interessenbindungen, width = 1, space = 0.5, col = colors, names.arg = Interest_Frame_final$Partei, main = "Durchschnittliche Anzahl Interessenbindungen pro Parlamentarier")



