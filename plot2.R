################################################################################
###                         P  R  O  J  E  C  T                              ###
###                             PLOTTING THE                                 ###
###          INDIVIDUAL HOUSEHOLD ELECTRIC POWER CONSUMPTION DATA SET        ###
### https://archive.ics.uci.edu/ml/datasets/Individual+household+electric+power+consumption
###                                                                          ###
###                               SCRIPT 2                                   ###
###                 DOWNLOAD, EXTRACT AND TIDY THE DATA SET, THEN,           ###
###                  PLOT A TIME SERIES ABOUT GLOBAL ACTIVE POWER            ###
###                         CONSUMPTION IN THE HOUSEHOLD                     ###
###                                                                          ###
### This R script downloads and extracts the power consumption data set into ###
### our WORKING directory. If the data set has already been loaded into the  ###
### R environment, it just plots the time-series into a png-file. Please,    ###
### make sure you've alredy set your R working directory before running the  ###
### script to facilitate locating the plot file.                             ###
###                                                                          ###
################################################################################


################################################################################
###  1. Download and extract the data set into the WORKING directory         ###
################################################################################

# 1. If the data set is not loaded, get and clean the data set------------------
search <- ls(pattern = "house.power.comp")
if (length(search) == 0) {
        # 1.1 Assign the files' names 
        file.url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        zip.name <- "household_power_consumption.zip"
        file.name <- "household_power_consumption.txt"
        # 1.2 Download and unzip the data set
        if (!file.exists(zip.name)) {
                download.file(url = file.url, destfile = zip.name, 
                              method = "curl", quiet = FALSE)
        }
        if (!file.exists(file.name)) {
                unzip(zipfile = zip.name, setTimes = TRUE)
        }
        # 1.3 Load the first 1000 rows to see the format of each variable
        initial <- read.table(file.name, nrows = 1000, 
                              sep = ";",
                              stringsAsFactors = FALSE,
                              header = TRUE)
        head(initial, n = 10)
        # 1.4 Define the variables namess and types   
        col.names <- colnames(initial) 
        col.classes <- c("character", "character", "numeric", "numeric", 
                         "numeric", "numeric", "numeric", "numeric", "numeric")
        # 1.5 Extract the rows id for Februray 1st and 2nd, 2007 from the data set        
        lines <- grep("^1/2/2007|^2/2/2007", readLines(file.name), 
                      value = FALSE)
        # 1.5 Import the extracted lines into a data.frame. using the rows id
        house.power.comp <- read.table(file = file.name, header = FALSE, 
                                       sep = ";", dec = ".", 
                                       stringsAsFactors = FALSE, 
                                       skip = lines[1] - 1, 
                                       nrows = length(lines), 
                                       colClasses = col.classes, 
                                       na.strings = "?", col.names = col.names)
        # 1.6 Clean the data frame
        str(house.power.comp)
        house.power.comp$Date <- as.Date(house.power.comp$Date, 
                                         format = "%d/%m/%Y")
        house.power.comp$Date <- with(house.power.comp, 
                                      paste(Date, "T", Time, sep = " "))
        # 1.7 Assign the time format (household located in Sceaux, near Paris)
        house.power.comp$Date <- strptime(house.power.comp$Date, 
                                          format = c("%Y-%m-%d T %H:%M:%S"), 
                                          tz = "Europe/Paris") 
        # 1.8 Delete downloaded and extracted files to save disk space
        file.remove(file.name)
        file.remove(zip.name)
}
# 2. Only Keep the clean data.frame in the R environment------------------------
rm(list = setdiff(ls(), "house.power.comp"))

################################################################################
###  2. Plot a time-series into a png-file                                   ###
################################################################################

# 1. Open the PNG graphic device------------------------------------------------
png(filename = "plot2.png", width = 480, height = 480, res = 100)
# 2. Draw the time-series-------------------------------------------------------
plot(house.power.comp$Date, house.power.comp$Global_active_power, 
     type = "l", ylab = "Global Active Power (kilowatts)", axes = TRUE, 
     xlab = "")
# 3. Close the PNG graphic device-----------------------------------------------
dev.off()

