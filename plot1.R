# plot1.R
#
# Makes the first plot of the course project in week 1

# This header is the same for all 4 plotting scripts.

# Uncomment if you want to run the plotting in a different folder
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
png(filename = "plot1.png", width = 480, height = 480, units = "px")
# plot the histogramm of global active power values
hist(tab$Global_active_power, col = 'Red',
     xlab = "Global Active Power (kilowatts)", main = "Global Active Power")
dev.off() # close device