##Read the code

###set working directory
setwd ("C:/Users/Mati Dodel/Dropbox/Coursera/Data Science Specialization/Exploratory Data Analysis")
getwd ()

Sys.setlocale('LC_TIME', 'C') ###set system to English 

###Check if directory exists
if (!file.exists("courseproject")){
        dir.create("courseproject")
}

###Donwload file and save downloaddate
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl, destfile="./courseproject/electricpowerconsumption2.zip")
dateDownloaded <- date()

###load data.table package to load csv quickly
library(data.table)


dt<-fread(unzip("./courseproject/electricpowerconsumption2.zip"), na.strings=c('?'), verbose=T)

###Load dplyr package, just a personal preference on how to work with databases
library(dplyr)
dt2<- tbl_df(dt)

##Filter the database
dt2<- filter(dt2, Date == "2/2/2007" | Date == "1/2/2007")

###correct the variables classes due to fread
dt2<-transmute(dt2, Global_active_power=as.numeric(Global_active_power), 
               Global_reactive_power=as.numeric(Global_reactive_power), 
               Voltage=as.numeric(Voltage), 
               Global_intensity=as.numeric(Global_intensity),
               Sub_metering_1=as.numeric(Sub_metering_1),
               Sub_metering_2=as.numeric(Sub_metering_2),
               Sub_metering_3=as.numeric(Sub_metering_3),
               date=Date,
               time=Time)

###correct the format of date, merge with time and create datetime3
dt2<-mutate (dt2, date=gsub("2/2/2007", "02/02/2007", dt2$date))
dt2<-mutate (dt2, date=gsub("1/2/2007", "01/02/2007", dt2$date))
dt2<-mutate (dt2, datetime=paste(date,time))

dt2$datetime3<- strptime(dt2$datetime, format = "%d/%m/%Y %H:%M:%S")


##Plot 2

png(filename = "./courseproject/plot2.png", 
    bg = "transparent")
with(dt2, plot(datetime3, Global_active_power, type="l", 
               ylab="Global Active Power (kilowatts)", 
               xlab=""))
dev.off()