library(ProfoundData)
library(LandClimTools)

setDB("../data/ProfoundData.sqlite")

overview <- browseData()
site_infos <- ProfoundData::getData(dataset =  "SITES")
site_infos <- site_infos[overview$TREE ==1,]
site_infos$site

### Klimadaten für site BilyKriz ####
### ISIMIP: www.isimip.org
colnames(overview)
clim <- ProfoundData::getData("CLIMATE_ISIMIPFT", "bily_kriz")
str(clim, 1)

clim$date <- as.Date(clim$date)

table(clim$forcingConditions)
table(clim$year)
table(clim$forcingDataset)

### Global circulation models, z.B. 
## https://verc.enes.org/models/earthsystem-models/metoffice-hadley-centre/hadgem2-es

### Emission scenarios

### van Vuuren, D.P., Edmonds, J., Kainuma, M., Riahi, K., Thomson, A., Hibbard, K., Hurtt, G.C., Kram, T., Krey, V., Lamarque, J.-F., Masui, T., Meinshausen, M., Nakicenovic, N., Smith, S.J., & Rose, S.K. 2011. The representative concentration pathways: an overview. Climatic Change 109: 5–31.

### "Historical" is simulated climate data for the past, which fits to the "future" scenarios
clim_site <- clim[clim$forcingConditions=="historical" & clim$forcingDataset =="HadGEM2ES",]
head(clim_site)
summary(clim_site)

plot(tmean_degC ~ date, data=clim_site, type="l", col="gray")
abline(h=mean(clim_site$tmean_degC), lwd=2, col="gray")
lines(smooth.spline(clim_site$date, clim_site$tmean_degC, nknots=50), lwd=2, col="tomato")
abline(lm(tmean_degC ~ date, data=clim_site), lwd=3, col="tomato")


### LandClim climate data header, read in example
header <- readLines("../data/landclim_site_infos/climate_header.txt")
header[2]   ### Latitude must match latitude of site

header[2] <- site_infos$lat[site_infos$site=="bily_kriz"]

### Altitude!
header[3] <- ifelse(is.na(site_infos$elevation_masl[1]), 99, (site_infos$elevation_masl[1]))
# profound_climate_to_landclim(climdata, header, file="data/test_clim.txt")
dir.create("simulations")
dir.create("simulations/bily_kriz")
dir.create("simulations/bily_kriz/Input")

profound_climate_to_landclim(clim[clim$forcingConditions=="historical",], header, file="simulations/bily_kriz/Input/clim.txt")


