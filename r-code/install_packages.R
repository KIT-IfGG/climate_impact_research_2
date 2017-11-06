
### Install R- package ProfoundData
install.packages("../data/R-Packages/ProfoundData_0.1.6.tar.gz", build_vignettes = TRUE, repos = NULL)

library(ProfoundData)
?ProfoundData
vignette("ProfoundDataVignette", package="ProfoundData")


### Install R-Package LandClimTools
library(devtools)
install_github("KIT-IfGG/LandClimTools")
library(LandClimTools)
?LandClimTools
