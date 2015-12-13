# plot2.R

# Makes the second plot of the course project in week 1
# Global active power for the two days.

# This header is the same for all 4 plotting scripts.

setwd("d:/Projects/ExplorDataAnalys/Week1/Exdata_plotting1")

# Define filenames for the URL, intermediate zipfile, and the data txt file
fileURL <- paste("https://d396qusza40orc.cloudfront.net/", 
                 "exdata%2Fdata%2Fhousehold_power_consumption.zip", sep = "")
zipfile <- "./data/household_power_consumption.zip"
filename <- "./data/household_power_consumption.txt"

# A series of checks to reduce the computational load

# First: Check if the data-subfolder exists. If not, create
if(!file.exists("./data")) {dir.create("./data")}

# Second: Check if the data as a zipfile has already been downloaded into the
# data subfolder
if (!file.exists(zipfile)) {download.file(fileURL, zipfile, mode = "wb")}

# Third: Check if the data has already been unzipped
if (!file.exists(filename)) {unzip(zipfile, exdir = "./data")}

# Fourth: Check if the preprocessed data from the two days in feb. 2007 is
# already in  the workspace

if (!exists("tab")) {
    # Read data with ";" as separator
    dummy <- read.table(filename, sep = ";")
    # Because the first row in the txt file is not used as the names of the
    # of the data.frame automatically, change that manually.
    tab <- dummy[2:length(dummy[, 1]), ]
    names(tab) <- lapply(dummy[1, ], as.character)
    
    # Select only the relevant days (2007-02-01 and 2007-02-02)
    tab <- tab[(tab$Date == "1/2/2007" | tab$Date == "2/2/2007"), ]
    
    # Convert factor entries in table to numerics.
    for (i in 3:9) {
        tab[, i] <- as.numeric(as.character(tab[, i]))
    }
}


# In the png device, the desired size of 480x480 px is the default, I set
# them manually anyway for good measure
png(filename = "plot2.png", width = 480, height = 480, units = "px")
# plot Global Active Power as a function of time for two days

# Define vectors for the x-axis ticks and labels
v1 <- c(0, 1440, 2880)
v2 <- c("Thu", "Fri", "Sat")

plot(tab$Global_active_power, type = 'l', xlab = '',
     ylab = "Global Active Power (kilowatts)", xaxt = 'n')

# Insert the ticks via axis function
axis(side = 1, at = v1, labels = v2)

dev.off() # close device

