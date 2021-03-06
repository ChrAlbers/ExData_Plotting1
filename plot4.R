# plot4.R

# Makes the fourth plot of the course project in week 1
# For different plots in one figure: Global Active power (same as plot2),
# Voltage over time, Sub Energy Metering (same as plot 3), 
# Global reactive power

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
png(filename = "plot4.png", width = 480, height = 480, units = "px")

# As before, define the vectors for x-axis ticks and labels
v1 <- c(0, 1440, 2880)
v2 <- c("Thu", "Fri", "Sat")

# Set the figure to 4 subplots with par()
par(mfrow = c(2, 2))    

# Plot 1 (upper left)
plot(tab$Global_active_power, type = 'l', xlab = '',
     ylab = "Global Active Power (kilowatts)", xaxt = 'n')
axis(side = 1, at = v1, labels = v2)

# Plot 2 (upper right)
plot(tab$Voltage, type = "l", xlab = "datetime", ylab = "Voltage", xaxt = "n")
axis(side = 1, at = v1, labels = v2)

# Plot 3 (lower left)
plot(tab$Sub_metering_1, type = 'l', xlab = '',
     ylab = "Energy sub metering", xaxt = 'n')
axis(side = 1, at = v1, labels = v2)
lines(tab$Sub_metering_2, col = "red")
lines(tab$Sub_metering_3, col = "blue")

# The difference to plot3.R is that the box of the legend has no lines
# here. Switched off via box.lty = 0
legend("topright", legend = names(tab)[7:9], lty = 1,
       col = c("black", "red", "blue"), box.lty = 0)

# Plot 4 (lower right)
plot(tab$Global_reactive_power, type = "l", xlab = "datetime", ylab = names(tab)[4],
     xaxt = "n")
axis(side = 1, at = v1, labels = v2)

dev.off() # close device

