search <- ls(pattern = "house.power.comp")
if (length(search) == 0) {
        file.url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        zip.name <- "household_power_consumption.zip"
        file.name <- "household_power_consumption.txt"
        if (!file.exists(zip.name)) {
                download.file(url = file.url, destfile = zip.name, 
                              method = "curl", quiet = FALSE)
        }
        if (!file.exists(file.name)) {
                unzip(zipfile = zip.name, setTimes = TRUE)
        }
        initial <- read.table(file.name, nrows = 1000, 
                              sep = ";",
                              stringsAsFactors = FALSE)
        head(initial, n = 10)
        col.classes <- c("character", "character", "numeric", "numeric", 
                         "numeric", "numeric", "numeric", "numeric", "numeric")
        lines <- grep("^1/2/2007|^2/2/2007", readLines(file.name), 
                      value = FALSE)
        col.names <- colnames(read.table(file = file.name, header = TRUE, 
                                         nrows = 1, sep = ";"))
        house.power.comp <- read.table(file = file.name, header = FALSE, 
                                       sep = ";", dec = ".", 
                                       stringsAsFactors = FALSE, 
                                       skip = lines[1] - 1, 
                                       nrows = length(lines), 
                                       colClasses = col.classes, 
                                       na.strings = "?", col.names = col.names)
        str(house.power.comp)
        house.power.comp$Date <- as.Date(house.power.comp$Date, 
                                         format = "%d/%m/%Y")
        house.power.comp$Date <- with(house.power.comp, 
                                      paste(Date, "T", Time, sep = " "))
        house.power.comp$Date <- as.POSIXlt(house.power.comp$Date, 
                                            format = c("%Y-%m-%d T %H:%M:%S"), 
                                            tz = "Europe/Paris")
        file.remove(file.name)
        file.remove(zip.name)
}
rm(list = setdiff(ls(), "house.power.comp"))

png(filename = "plot1.png", width = 480, height = 480, res = 100)
hist(x = house.power.comp$Global_active_power, col = "red", 
     main = "Global Active Power", xlab = "Global Active Power (Kilowatts)")
dev.off()
