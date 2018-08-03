### Title: CacheUpdate.R
### Author: Ben Crary, LimnoTech
### Description: Script to create data caches for each sensor for CrosslandsDemo.Rmd
### Comments: Server errors/timeouts may require breaking up GetValues functions into severl iterations and binding the results together (see air temperature)
###
### 09/12/2017
### Updated: 11/14/2017 for new endpoints


library(WaterML)
library(tidyverse)


server <- "http://data.envirodiy.org/wofpy/soap/cuahsi_1_1/.wsdl"


## water depth
wdepth <- GetValues(server, siteCode="envirodiy:160065_Limno_Crossroads", variableCode="envirodiy:MaxBotix_MB7386_Distance")
tidy <- separate(wdepth, time, into=c("date", "time"), sep=" ")
tidy$datetime <- paste(tidy$date, " ", tidy$time,sep="")
tidy$datetime <- as.POSIXct(strptime(tidy$datetime,format="%Y-%m-%d %H:%M:%S",tz="America/Chicago"))-11*60*60
tidy$date <- as.POSIXct(strptime(tidy$date, format="%Y-%m-%d", tz="America/Chicago"))-11*60*60
wdepth$datetime <- tidy$datetime
wdepth$date <- tidy$date
wdepth <- wdepth %>% filter(DataValue != 0)
wdepth <- wdepth %>% filter(DataValue != 9999)
wdepth <- wdepth %>% filter(DataValue < 4000) 
wdepth <- wdepth %>% filter(DataValue > 1000)
wdepth$Depth = (4000 - wdepth$DataValue)/1000

saveRDS(wdepth, "C:/Users/bcrary/Desktop/Projects/BigCZ/EnviroDIY_DemoApp/Crosslands/cache_wdepth.RDS")
#wdepthcache <- readRDS("C:/Users/bcrary/Desktop/Projects/BigCZ/EnviroDIY_DemoApp/cache_wdepth.RDS")


## water temp
wtemp <- GetValues(server, siteCode="envirodiy:160065_Limno_Crossroads", variableCode="envirodiy:Maxim_DS18B20_Temp")
tidy <- separate(wtemp, time, into=c("date", "time"), sep=" ")
tidy$datetime <- paste(tidy$date, " ", tidy$time,sep="")
tidy$datetime <- as.POSIXct(strptime(tidy$datetime,format="%Y-%m-%d %H:%M:%S", tz="America/Chicago"))-11*60*60
tidy$date <- as.POSIXct(strptime(tidy$date, format="%Y-%m-%d",tz="America/Chicago"))-11*60*60
wtemp$datetime <- tidy$datetime
wtemp$date <- tidy$date
wtemp$DataValue <- wtemp$DataValue*9/5+32
saveRDS(wtemp, "C:/Users/bcrary/Desktop/Projects/BigCZ/EnviroDIY_DemoApp/Crosslands/cache_wtemp.RDS")


## air temp
atemp <- GetValues(server, siteCode="envirodiy:160065_Limno_Crossroads", variableCode="envirodiy:Bosch_BME280_Temp")
#atemp1 <- GetValues(server, siteCode="envirodiy:160065_Limno_Crossroads", variableCode="envirodiy:Seeed_BME280_Temp", startDate=Sys.Date()-170,endDate=Sys.Date()-140)
#atemp2 <- GetValues(server, siteCode="envirodiy:160065_Limno_Crossroads", variableCode="envirodiy:Seeed_BME280_Temp", startDate = Sys.Date()-139, endDate=Sys.Date()-110)
#atemp3 <- GetValues(server, siteCode="envirodiy:160065_Limno_Crossroads", variableCode="envirodiy:Seeed_BME280_Temp",startDate  = Sys.Date()-109, endDate=Sys.Date()-80)
#atemp4 <- GetValues(server, siteCode="envirodiy:160065_Limno_Crossroads", variableCode="envirodiy:Seeed_BME280_Temp",startDate  = Sys.Date()-79, endDate=Sys.Date()-50)
#atemp5 <- GetValues(server, siteCode="envirodiy:160065_Limno_Crossroads", variableCode="envirodiy:Seeed_BME280_Temp",startDate  = Sys.Date()-49, endDate=Sys.Date()+2)
#atemp <- rbind(atemp1,atemp2, atemp3, atemp4, atemp5)

tidy <- separate(atemp, time, into=c("date", "time"), sep=" ")
tidy$datetime <- paste(tidy$date, " ", tidy$time,sep="")
tidy$datetime <- as.POSIXct(strptime(tidy$datetime,format="%Y-%m-%d %H:%M:%S", tz="America/Chicago"))-11*60*60
tidy$date <- as.POSIXct(strptime(tidy$date, format="%Y-%m-%d", tz="America/Chicago"))-11*60*60
atemp$datetime <- tidy$datetime
atemp$date <- tidy$date
atemp$DataValue <- atemp$DataValue*9/5+32
atemp <- filter(atemp, DataValue < 120)
saveRDS(atemp, "C:/Users/bcrary/Desktop/Projects/BigCZ/EnviroDIY_DemoApp/Crosslands/cache_atemp.RDS")


## humidity
humidity <- GetValues(server, siteCode="envirodiy:160065_Limno_Crossroads", variableCode="envirodiy:Bosch_BME280_Humidity")
tidy <- separate(humidity, time, into=c("date", "time"), sep=" ")
tidy$datetime <- paste(tidy$date, " ", tidy$time,sep="")
tidy$datetime <- as.POSIXct(strptime(tidy$datetime,format="%Y-%m-%d %H:%M:%S", tz="America/Chicago"))-11*60*60
tidy$date <- as.POSIXct(strptime(tidy$date, format="%Y-%m-%d", tz="America/Chicago"))-11*60*60
humidity$datetime <- tidy$datetime
humidity$date <- tidy$date
saveRDS(humidity, "C:/Users/bcrary/Desktop/Projects/BigCZ/EnviroDIY_DemoApp/Crosslands/cache_humidity.RDS")



## Battery

bbatt <- GetValues(server, siteCode="envirodiy:160065_Limno_Crossroads", variableCode="envirodiy:EnviroDIY_Mayfly_Batt")
tidy <- separate(bbatt, time, into=c("date", "time"), sep=" ")
tidy$datetime <- paste(tidy$date, " ", tidy$time,sep="")
tidy$datetime <- as.POSIXct(strptime(tidy$datetime,format="%Y-%m-%d %H:%M:%S", tz="America/Chicago"))-11*60*60
tidy$date <- as.POSIXct(strptime(tidy$date, format="%Y-%m-%d", tz="America/Chicago"))-11*60*60
bbatt$datetime <- tidy$datetime
bbatt$date <- tidy$date
saveRDS(bbatt, "C:/Users/bcrary/Desktop/Projects/BigCZ/EnviroDIY_DemoApp/Crosslands/cache_bbatt.RDS")


## board temp


btemp <- GetValues(server, siteCode="envirodiy:160065_Limno_Crossroads", variableCode="envirodiy:EnviroDIY_Mayfly_Temp")
tidy <- separate(btemp, time, into=c("date", "time"), sep=" ")
tidy$datetime <- paste(tidy$date, " ", tidy$time,sep="")
tidy$datetime <- as.POSIXct(strptime(tidy$datetime,format="%Y-%m-%d %H:%M:%S", tz="America/Chicago"))-11*60*60
tidy$date <- as.POSIXct(strptime(tidy$date, format="%Y-%m-%d", tz="America/Chicago"))-11*60*60
btemp$datetime <- tidy$datetime
btemp$date <- tidy$date
btemp$DataValue <- btemp$DataValue*9/5+32
saveRDS(btemp, "C:/Users/bcrary/Desktop/Projects/BigCZ/EnviroDIY_DemoApp/Crosslands/cache_btemp.RDS")





## free ram

bram <- GetValues(server, siteCode="envirodiy:160065_Limno_Crossroads", variableCode="envirodiy:EnviroDIY_Mayfly_FreeRAM")
tidy <- separate(bram, time, into=c("date", "time"), sep=" ")
tidy$datetime <- paste(tidy$date, " ", tidy$time,sep="")
tidy$datetime <- as.POSIXct(strptime(tidy$datetime,format="%Y-%m-%d %H:%M:%S", tz="America/Chicago"))-11*60*60
tidy$date <- as.POSIXct(strptime(tidy$date, format="%Y-%m-%d", tz="America/Chicago"))-11*60*60
bram$datetime <- tidy$datetime
bram$date <- tidy$date
saveRDS(bram, "C:/Users/bcrary/Desktop/Projects/BigCZ/EnviroDIY_DemoApp/Crosslands/cache_bram.RDS")


















