library(ProfoundData)
library(LandClimTools)
library(raster)

setDB("../data/ProfoundData.sqlite")

overview <- browseData()
site_infos <- ProfoundData::getData(dataset =  "SITES")
site_infos <- site_infos[overview$TREE==1,]
site_infos$site   ### Remove "global"

### Select site for simulations ####
### Select sites for which climate data are available
sites <- overview[overview$CLIMATE==1,]

### Select site for which tree species are known
sites <- overview[overview$TREE==1 | overview$STAND==1,]
sites$site

### Match sites and site_infos (lat and elevation infos needed later on)
site_infos <- site_infos[match(sites$site,site_infos$site),]

### Species lists per site ####
species <- read_species_xml("../data/landclim_files/species_full_med.xml")   ### LandClim species parameters
species$name <- as.character(species$name)

site_species <- read.csv("../data/landclim_site_infos/site_species_actual.csv", stringsAsFactors=F, skip=1)  ### Species present at each profound site
site_species_pnv <- read.csv("../data/landclim_site_infos/site_species_pnv.csv", stringsAsFactors=F, skip=1) ### Alternative species list for each profound site ( change in odt-file and export as csv)
species_codes <- read.csv("../data/landclim_site_infos/species_codes.csv", stringsAsFactors=F)  ### Translation for LandClim species names in species_full_med.xml and profound species names.

### Climate header ####
header <- readLines("../data/landclim_site_infos/climate_header.txt")

### Make landclim input folders ####
for (i in 1:nrow(sites)){
#  i <- 8   ### site
  gcm <- 2   ### Global circulation model; HadGEM2ES
  sc <- 1  ### Emission scenario (1=historical)
  sc2 <- 5
  
  ### Create directories for landclim input files
  dir.create(paste("simulations/", tolower(sites$name1[i]), sep=""))
  dir.create(paste("simulations/", tolower(sites$name1[i]), "/Input", sep=""))
  
  ### Get climate time series from profound database 
  #isi_climate <- ProfoundData::getData("ISIMIP", sites$site[i])
  isi_climate <- ProfoundData::getData("CLIMATE_ISIMIPFT", sites$site[i])
  
  gcm_names <- unique(isi_climate$forcingDataset)
  
  ### Change climate header for sites for which info is available (lat and elevation)
  header[2] <- site_infos$lat[i]
  header[3] <- ifelse(is.na(site_infos$elevation_masl[i]), 99, (site_infos$elevation_masl[i]))
  
  isi_climate <- isi_climate[isi_climate$forcingDataset == gcm_names[gcm],]
  scenario_names <- unique(isi_climate$forcingConditions)
  
  ### Convert and write landclim climate data file from profound data
  profound_climate_to_landclim(isi_climate[isi_climate$forcingConditions==scenario_names[sc],], header, file=paste("simulations/", tolower(sites$name1[i]), "/Input/climate_", scenario_names[sc], ".txt", sep=""))
  profound_climate_to_landclim(isi_climate[isi_climate$forcingConditions==scenario_names[sc2],], header, file=paste("simulations/", tolower(sites$name1[i]), "/Input/climate_", scenario_names[sc2], ".txt", sep=""))
  
  ### Create landclim maps ####
  d <- 100 
  dem <- raster(xmn=site_infos$lon[i]-d, xmx=site_infos$lon[i]+d, ymn=site_infos$lat[i]-d, ymx=site_infos$lat[i]+d, crs=CRS("+init=epsg:4326"), resolution=25)  
  dem[] <-  ifelse(is.na(site_infos$elevation_masl[i]), 99, (site_infos$elevation_masl[i]))
  slope <- aspect <- mask <- landtype <- nitro <- stand <- soil <- management <- dem 
  slope[] <- aspect[] <- 0
  mask[] <- landtype[] <- nitro[] <- management[] <- 1
  soil[] <- 15   ### Todo: Find site specific soil depth / field capacity
  stand[] <- 15  ### Todo: Still no idea what this is for
  
  landclim_stack <- stack(aspect, dem, landtype, management, mask, nitro, slope, soil, stand)
  names(landclim_stack) <- c("aspect", "dem", "landtype", "management", "mask", "nitro", "slope", "soil", "stand")
  
  ### Write maps in landclim format
  write_landclim_maps(landclim_stack,  nodata_value = "-9999", lcResolution = 25,  folder=paste("simulations/", tolower(sites$name1[i]), "/Input", sep=""))
  
  ### Create species list ####  
  species_selection <- as.character(site_species[site_species[sites$site[i]]==1,"X"])
  
  species_selection <- species[species$name %in% species_codes$name_landclim[match(species_selection, species_codes$name_profound)],]
  write_species_xml(species_selection, paste("simulations/", tolower(sites$name1[i]), "/Input/species.xml", sep=""))
  file.copy(paste("simulations/", tolower(sites$name1[i]), "/Input/species.xml", sep=""), paste("simulations/", tolower(sites$name1[i]), "/Input/species_actual.xml", sep=""))  ### Todo:  Change this to save species lists...
  
  species_selection <- as.character(site_species_pnv[site_species_pnv[sites$name1[i]]==1,"X"])
  
  species_selection <- species[species$name %in% species_codes$name_landclim[match(species_selection, species_codes$name_profound)],]
  write_species_xml(species_selection, paste("simulations/", tolower(sites$name1[i]), "/Input/species_pnv.xml", sep=""))
   
  ### Add control file ####
  fis <- list.files("data/landclim_files")
  file.copy(paste("data/landclim_files/", fis, sep=""), paste("simulations/", tolower(sites$name1[i]), "/Input/",fis,  sep=""),  overwrite=TRUE)
}



