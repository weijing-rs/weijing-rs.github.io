;+
; :Author: Dr. Jing Wei (Email: weijing_rs@163.com)
;-
PRO nc2geotiff

  COMPILE_OPT IDL2
  ENVI, /RESTORE_BASE_SAVE_FILES
  ENVI_BATCH_INIT

  ;Define work and output paths
  WorkDir = 'F:\CHAP\codes\test\'
  out_dir = WorkDir
  
  ;Define air pollutant type 
  ;e.g., PM1, PM2.5, PM10, O3, NO2, SO2, and CO, et al.
  AP = 'PM2.5'
  
  ;Define spatial resolution 
  ;e.g., 1 km ≈ 0.01 degree
  SP = 0.01 ;Degrees

  Files = FILE_SEARCH(WorkDir + '*.nc');
  N = N_ELEMENTS(Files)
  FOR j=0,N-1 DO BEGIN
    File = Files[j]
    cdfid = NCDF_OPEN(File,/nowrite)
    varid = NCDF_VARID(cdfid,AP)
    Latid = NCDF_VARID(cdfid,'lat')
    Lonid = NCDF_VARID(cdfid,'lon')    
    NCDF_VARGET,cdfid,varid,data
    NCDF_VARGET,cdfid,Latid,Lat
    NCDF_VARGET,cdfid,Lonid,Lon
    NCDF_ATTGET,cdfid,varid,'scale_factor',a
    NCDF_ATTGET,cdfid,varid,'add_offset',b
    NCDF_ATTGET,cdfid,varid,'_FillValue',c    
    ;
    INDEX = WHERE(data EQ c)
    data = data*a+b
    ;Define missing value: NaN or -999
    data[INDEX] = !VALUES.F_NAN ;-999
    ;Define output file
    pos = STRPOS(FILE_BASENAME(File),'.nc')
    str = STRMID(FILE_BASENAME(File),0,pos)
    outfile = out_dir + str + '.tif'
    ;Write GeoTIFF          
    geo_info={$
      MODELPIXELSCALETAG:[SP,SP,0.0],$
      MODELTIEPOINTTAG:[0.0,0.0,0.0,MIN(Lon)-SP/2,MAX(Lat)+SP/2,0.0],$
      GTMODELTYPEGEOKEY:2,$
      GTRASTERTYPEGEOKEY:1,$
      GEOGRAPHICTYPEGEOKEY:4326,$
      GEOGCITATIONGEOKEY:'GCS_WGS_1984'}
    WRITE_TIFF,outfile,data,/float, geotiff=geo_info
    PRINT,outfile + ' Finished'
    NCDF_CLOSE,cdfid
  ENDFOR
  
END