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

## Create Histrogram plot on screen device
hist(x = ds$Global_active_power, col = "red", 
     main = "Global Active Power", 
     xlab = "Global Active Power (kilowatts)")

## Copy my plot to a PNG file of width = 480px, height = 480px
dev.copy(png, file = "plot1.png", width = 480, height = 480, units = "px" )

## closing the PNG device!
dev.off()
