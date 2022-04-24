
#Author: Jing Wei (Email: weijing_rs@163.com)

#install.packages("raster")

library(raster)

#Define work and output paths
WorkPath <- "F:/CHAP/codes/test/"
OutPath = WorkPath

#Define air pollutant type 
#e.g., PM1, PM2.5, PM10, O3, NO2, SO2, and CO, et al.
AP = 'PM2.5'

files <- list.files(WorkPath,pattern = "*.nc")

for (i in 1:length(files)) {
  file = paste0(WorkPath,files[i])
  nc2raster = raster(file,varname=AP,band=1)
  out_file <- paste0(strsplit(file,".nc")[[1]][1],'.tif')
  writeRaster(nc2raster,out_file,format='GTiff',overwrite=TRUE)
  print(paste(out_file,'Finished'))
}

