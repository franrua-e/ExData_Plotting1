
#Create temporal file
temp <- tempfile()

#Download file
downloaded_file <- download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
                                 destfile = temp)
unzip(temp)

#Read data set
complete_dataset<-read.table("household_power_consumption.txt", sep=";", 
                             header=TRUE)

#Filter out the dates we don't want
subset_df<- subset(complete_dataset, Date=="1/2/2007" | Date=="2/2/2007")

#Concatenate Date and Time columns to create a new column named "DateTime"
subset_df$DateTime<- paste(subset_df$Date, 
                           subset_df$Time, sep=" ")

#Change the column data type of DateTime column
subset_df$DateTime<- as.POSIXct(subset_df$DateTime,
                                "%d/%m/%Y %H:%M:%S", tz="Europe/Paris")

#Delete the data set to liberate space in memory
rm(complete_dataset)

#Delete Date and Time columns and rearrange the previously created column: DateTime
subset_df<- subset_df[ ,c(10,3:9)]

#Set columns and rows
par(mfrow=c(2,2), mar=c(4,4,2,1), oma=c(0,0,2,0))

with(subset_df,{
  plot(as.numeric(Global_active_power) ~ DateTime, type="l", 
       ylab="Global Active Power (kilowatts)", xlab="")
  plot(as.numeric(Voltage)~DateTime, type="l",
       ylab="Voltage", xlab="datetime")
  #Plot the different sub metering vs. datetime
  plot(as.numeric(Sub_metering_1) ~ DateTime, type="l", 
       ylab="Energy sub metering", xlab="")
  lines(Sub_metering_2~DateTime,col='Red')
  lines(Sub_metering_3~DateTime,col='Blue')
  
  #Add the legends
  legend("topright", col=c("black", "red", "blue"), lwd=c(1,1,1), 
         c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
         cex=0.1) 
  plot(as.numeric(Global_reactive_power)~ DateTime, type="l",
       ylab="Global_reactive_power", xlab="datetime")
  })



#Copy the screen device to file device
dev.copy(png, "plot4.png", width=480, height=480)

#"Unplug" the device
dev.off()
