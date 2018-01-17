### Update LandClimTools, if there were changes or install.
### Install LandCLim from github, might be necessary to update devtools before.
#library(devtools)
#install_github("KIT-IfGG/LandClimTools")

### Load the library ###
library(LandClimTools)

### Set(check your working directory ####
setwd("~/climate_impact_research_2/")
proj_wd <- getwd()

### Create/find/check path to the executable ####
paste0(proj_wd, "/simulations/LandClim_trunk_2016")
list.files(paste0(proj_wd, "/simulations/"))  ### Should return [1] "LandClim_trunk_2016" "bily_kriz"
set_landclim_path(paste0(proj_wd, "/simulations/LandClim_trunk_2016"))   ### only runs with Ubuntu!


### Simulation ####
### The working directory needs to be at the sites level!

### Should work like this, but it does not. Needs to be solved in the r-Package LandClimTools.
#setwd(paste0(proj_wd, "/simulations/bily_kriz"))
#run_landclim(control_file = "control.xml") 

### Thus we simulate "by hand". This code is usually hiddin in the function run_landclim or simulate.
setwd(paste0(proj_wd, "/simulations/bily_kriz"))
oldwd <- getwd()
dir.create("Output")
file.remove(list.files("Output", full = TRUE))
setwd(paste(oldwd, "/Input/", sep = ""))
system(paste0(lc_path, " ", control_file))
setwd(oldwd)
clean_output_ubuntu()

### Back to the project working directory ####
setwd(proj_wd)


