
#Author: Jianxiong Hu (Email: hzeros_hu@163.com)

library(raster)
library(ncdf4)
library(stringr)

#Define work and output paths
WorkPath = 'D:/CHAP'
OutPath  = WorkPath

if(!file.exists(OutPath)) {
  dir.create(OutPath)
}

#Define air pollutant type 
#e.g., PM1, PM2.5, PM10, O3, NO2, SO2, and CO, et al.
AP = 'PM2.5'

#Define spatial resolution 
#e.g., 1 km = 0.01 Degree
#SP = 0.01 #Degrees

file <- list.files(WorkPath,pattern = "*.nc")

for (i in 1:length(file)) {
  #read the data
  f <- nc_open(file[i])
  #convert the scaleface and addOffset to numeric
  f$var[[1]]$scaleFact <- as.numeric(f$var[[1]]$scaleFact)
  f$var[[1]]$addOffset <- as.numeric(f$var[[1]]$addOffset)
  
  #get the AP data from nc file
  data <- ncvar_get(f, AP)
  
  #Define missing value: NaN or < 0
  data[data<0.0] <- NA
  data[data==6553.5] <- NA
  data1 <- t(data)
  
  #Read longitude and latitude information
  lat <- as.numeric(ncvar_get(f, "lat"))
  lon <- as.numeric(ncvar_get(f, "lon"))
  
  #define a blank raster file
  rr <- raster(data1,
               xmn=min(lon),xmx=max(lon),ymn=min(lat),ymx=max(lat),
               crs=crs("+proj=utm +zone=18 +datum=WGS84 +units=m +no_defs"))
  #plot(rr)
  filename <- str_split(file[i],".nc")[[1]][1]
  writeRaster(rr,paste0(WorkPath,"/",filename,".tif"),overwrite=TRUE)
}

