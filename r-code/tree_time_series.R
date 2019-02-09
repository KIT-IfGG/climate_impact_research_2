### Calculate: death, establishment and growth, demography

datapath <- "simulations/collelongo/Output" 


### Read fullOut files ####
fis <- list.files(datapath, full.names = TRUE)
fis <- fis[grep("fullOut", fis)]
fis <- fis[grep("csv", fis)]

### Todo: Here there is no reasonable time series of outputs. Need to be regular 
### outputs! Change this in the control file.

### Create tree id ####
years <- unlist(lapply(fis, function(x) strsplit(x, "_")[[1]][2]))
years <- 10 * as.numeric(unlist(lapply(years, function(x) strsplit(x, "[.]")[[1]][1])))

fulls <- lapply(fis, function(x) read.csv(x))
names(fulls) <- years

for (i in 1:length(fulls)) {
  fulls[[i]]$birth <- as.numeric(names(fulls)[i]) - fulls[[i]]$age
  fulls[[i]]$treeID <- paste0(fulls[[i]]$cell, "_", fulls[[i]]$age - as.numeric(names(fulls)[i]), "_",fulls[[i]]$species)
}

for (i in 2:length(fulls)) {
  ### Cohort: All trees established whithin a cell at the same time, species
  ### Growth
  m <- match(fulls[[i-1]]$treeID, fulls[[i]]$treeID)
  #cbind(fulls[[i-1]]$treeID, fulls[[i]]$treeID[m])
  #fulls[[i]]$treeID[m]   ### Survivors
  growth <- fulls[[i]]$DBH[m]  - fulls[[i-1]]$DBH ### cm
  fulls[[i-1]]$growth <- growth
  
  ### Died? 
  fulls[[i-1]]$will_die <- fulls[[i-1]]$stems
  fulls[[i-1]]$will_die[!is.na(fulls[[i-1]]$growth)] <- 0

  ### Established?
  fulls[[i]]$new <- fulls[[i]]$stems
  m <- match(fulls[[i]]$treeID, fulls[[i-1]]$treeID)
  new <- ifelse(is.na(m), 1, 0)
  fulls[[i]]$new[!is.na(m)] <- 0
}

### Put things together ####
establishment <- unlist(lapply(fulls, function(x) sum(x$new)))
mortality <- unlist(lapply(fulls, function(x) sum(x$will_die)))
growth_mean <- unlist(lapply(fulls, function(x) mean(rep(x$growth, x$stems), na.rm = T)))   ### weighted mean!
dat <- cbind.data.frame(decade = as.numeric(names(fulls)), establishment = establishment, mortality = mortality, growth_mean = growth_mean)

dat <- dat[order(dat$decade),]
matplot(dat$decade, dat[,2:4], type = "l",lwd=2)
matplot(dat$decade, dat[,2:4], type = "l", xlim=c(0, 45),lwd=2)

par(mar = c(4,4,1,4))
matplot(dat$decade, dat[,2:3], type = "l", xlim=c(2350, 2600), lwd=2, xlab = "Years", ylab = "Number of cohorts")
par(new=TRUE)
plot(dat$decade, dat[,4], type = "l", xlim=c(2350, 2600), lwd=2, lty = 3, col = 3, axes = FALSE, ylab = "", xlab = "")
abline(h = 0)
axis(4)
mtext("DBH growth (cm)" , 4, 3)
legend("topleft", legend = names(dat[,2:4]), lwd=2, lty=1:3, col = 1:3)

### Save as csv ####
write.csv(dat, file = "figures/demography.csv")

