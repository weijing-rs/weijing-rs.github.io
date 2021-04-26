;+
; :Author: Dr. Jing Wei (Email: weijing_rs@163.com)
;-
PRO nc2tif

  COMPILE_OPT IDL2
  ENVI, /RESTORE_BASE_SAVE_FILES
  ENVI_BATCH_INIT

  ;Define the work and output paths
  WorkDir = 'D:\xx\'
  out_dir = 'D:\xx\'

  ;Define the air pollutant (e.g., PM1, PM2.5, PM10, O3, NO2, SO, and CO)
  AP = 'O3'
  ;Define the spatial resolution (e.g.,0.1°*0.1°)
  SP = 0.1

  Files = FILE_SEARCH(WorkDir + '*.nc');
  N = N_ELEMENTS(Files)
  FOR j=0,N-1 DO BEGIN
    File = Files[j]
    cdfid = NCDF_OPEN(File,/nowrite)
    varid = NCDF_VARID(cdfid,AP)
    Latid = NCDF_VARID(cdfid,'Lat')
    Lonid = NCDF_VARID(cdfid,'Lon')
    IF varid EQ -1 THEN Continue
    NCDF_VARGET,cdfid,varid,data
    NCDF_VARGET,cdfid,Latid,Lat
    NCDF_VARGET,cdfid,Lonid,Lon
    NCDF_CLOSE,cdfid
    pos = STRPOS(FILE_BASENAME(File),'.nc')
    str = STRMID(FILE_BASENAME(File),0,pos)
    out_name = out_dir + str + '.img'
    PRINT,out_name
    OPENW,LUN,out_name,/GET_LUN
    WRITEU,LUN,data
    dim=SIZE(data)
    Ps=[SP,SP]
    Mc=[0.0D,0.0D,MIN(Lon),MAX(Lat)]
    map_info=ENVI_MAP_INFO_CREATE(name='geographic',mc=mc,ps=ps,proj=proj,/geographic)
    ENVI_SETUP_HEAD,fname=out_name,nb=1,ns=dim[1],nl=dim[2],data_type=dim[3],$
      interleave=0,offset=0,map_info=map_info,/WRITE
    FREE_LUN,LUN
  ENDFOR

END