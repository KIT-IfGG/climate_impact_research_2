### Install R- package ProfoundData ####
### You must install all dependencies (e.g. zoo, RSQLite)!
# install.packages("zoo")
# install.packages("RSQLite")
# install.packages("DBI")
# install.packages("sqldf")
# install.packages("rgdal", type = "source")
install.packages("devtools")

### Install the ProfoundData package from file ####
# install.packages("../data/R-Packages/ProfoundData_0.1.6.tar.gz", build_vignettes = TRUE, repos = NULL)

library(ProfoundData)
?ProfoundData
vignette("ProfoundDataVignette", package="ProfoundData")

### Download the PROFOUND data base ####
### Use link provided in the course slides

### Install R-Package LandClimTools ####
library(devtools)
install_github("KIT-IfGG/LandClimTools")
library(LandClimTools)

### Alternative: Install R-package LandClimTools from file (see Ilias). Change the path to your folder structure! This line need to be executed only once.
#install.packages(pkgs="path/to/LandClimTools.tar.gz", repos=NULL, type = "source")

