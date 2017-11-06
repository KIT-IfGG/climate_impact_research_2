library(ProfoundData)
library(LandClimTools)
library(raster)

### Path to database file
setDB("data/ProfoundData.sqlite")

overview <- browseData()
site_infos <- ProfoundData::getData(dataset =  "SITES")
site_infos[,c("name1", "natVegetation_description")]


### Select site for simulations ####
### Select sites for which climate data are available
sites <- overview[overview$CLIMATE==1,]

### Select site for which tree species are known
sites <- overview[overview$TREE==1 | overview$STAND==1,]
sites$name1

### Match sites and site_infos (lat and elevation infos needed later on)
site_infos <- site_infos[match(sites$name1,site_infos$name1),]

### site_infos$lon project?!

### Create landclim maps ####
d <- 100 
dem <- raster(xmn=site_infos$lon[1]-d, xmx=site_infos$lon[1]+d, ymn=site_infos$lat[1]-d, ymx=site_infos$lat[1]+d, crs=CRS("+init=epsg:4326"), resolution=25)  
dem[] <-  ifelse(is.na(site_infos$elevation_masl[1]), 99, (site_infos$elevation_masl[1]))
slope <- aspect <- mask <- landtype <- nitro <- stand <- soil <- management <- dem 
slope[] <- aspect[] <- 0
mask[] <- landtype[] <- nitro[] <- management[] <- 1
soil[] <- 15   ### Todo: Find site specific soil depth / field capacity
stand[] <- 15  ### Todo: Still no idea what this is for

landclim_stack <- stack(aspect, dem, landtype, management, mask, nitro, slope, soil, stand)
names(landclim_stack) <- c("aspect", "dem", "landtype", "management", "mask", "nitro", "slope", "soil", "stand")

### Write maps in landclim format
write_landclim_maps(landclim_stack,  nodata_value = "-9999", lcResolution = 25,  folder=paste("simulations/", tolower(sites$name1[1]), "/Input", sep=""))

