# Assuming These packages if there are not installed 
install.packages("dplyr", "tidyr", "lubridate")

#Load required packages
library(dplyr)#A grammer of data manipulation.
library(tidyr) #Tidy Messy Data.
library(lubridate) #tools that make it easier to parse and manipulate dates.

filename <- 'exdata_data_household_power_consumption.zip'
# Assuming you don't have the zip Dataset file, so downlaod it [size: 20 Mb]
download.file(
  'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip',
  filename )

# Now, unzip the file
unzip(filename) #The zip file had a "household_power_consumption.txt" file inside

#Importing the  Dataset
ds <- as_tibble(read.table(file = "household_power_consumption.txt",
                           sep = ";", header = TRUE, nrows = 2075260, na.strings = "?"))

#uniting the Date and Time column to make the dataset more tidy
ds <- ds %>% 
  unite(col = "date_time", Date, Time) %>%
  mutate(date_time = dmy_hms(date_time))

#we are interested in using data from the dates 2007-02-01 and 2007-02-02.
#i.e. ["2007-02-01 00:00:00" ,"2007-02-02 23:59:00"]
ds <- filter(ds, (ymd_hms(date_time) >= ymd("2007-02-01")) & (ymd_hms(date_time) < ymd("2007-02-03")))

par(mfrow = c(2, 2))

#plot on screen device: mfrow[1, 1]
with(data = ds, plot( x = date_time,
                      y = Global_active_power,
                      type = "s",
                      ylab = "Global Active Power ",
                      xlab = ""))
  
#plot on screen device: mfrow[1, 2]
with(data = ds, plot( x = date_time,
                      y =  Voltage,
                      type = "s",
                      ylab = "Voltage ",
                      xlab = "datatime"))

#plot on screen device: mfrow[2, 1]
#where x = date_time and y = Sub_metering_1 because it envelopes the
#other Sub_metering_*
with(data = ds, plot(x = date_time, y = Sub_metering_1, type = "n", 
                             ylab = "Energy sub metering", xlab = ""))
with(data = ds, lines(date_time, Sub_metering_1, col = "black"))
with(data = ds, lines(date_time, Sub_metering_2, col = "red"))
with(data = ds, lines(date_time, Sub_metering_3, col = "blue"))
legend("topright", pch = "_", col = c("black", "red", "blue"),
       legend = c("Sub_metering_1", "Sub_metering_2","Sub_metering_3"),
       cex = 0.8, bty = "n")

#plot on screen device: mfrow[2, 2]
with(data = ds, plot( x = date_time,
                      y =  Global_reactive_power,
                      type = "s",
                      xlab = "datatime"))


## Copy my plot to a PNG file of width = 480px, height = 480px
dev.copy(png, file = "plot4.png", width = 480, height = 480, units = "px" )

## closing the PNG device!
dev.off()

