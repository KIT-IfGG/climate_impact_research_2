### Install R- package ProfoundData ####
### You must install all dependencies (e.g. zoo, RSQLite)!
install.packages("../data/R-Packages/ProfoundData_0.1.6.tar.gz", build_vignettes = TRUE, repos = NULL)

library(ProfoundData)
?ProfoundData
vignette("ProfoundDataVignette", package="ProfoundData")

### Download the PROFOUND data base ####
### http://cost-profound.eu/cloud/public.php?service=files&t=6b0c165b76a8e8abdf5028286e78096e

### Install R-Package LandClimTools ####
library(devtools)
install_github("KIT-IfGG/LandClimTools")
library(LandClimTools)
?LandClimTools



