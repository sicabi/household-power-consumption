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

png(filename = "plot4.png", width = 480, height = 480, res = 100)
par(mfrow = c(2,2))
plot(house.power.comp$Date, house.power.comp$Global_active_power, 
     type = "l", ylab = "Global Active Power ", axes = TRUE, 
     xlab = "")
plot(house.power.comp$Date, house.power.comp$Voltage, 
     type = "l", ylab = "Voltage", axes = TRUE, 
     xlab = "datetime")
plot(house.power.comp$Date, house.power.comp$Sub_metering_1, 
     type = "l", ylab = "Energy sub metering", xlab = "")
points(house.power.comp$Date, house.power.comp$Sub_metering_2, type = "l", 
       col = "red")
points(house.power.comp$Date, house.power.comp$Sub_metering_3, type = "l", 
       col = "blue")
legend(x = "topright", lty = 1, col = c("black", "red", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       y.intersp = 0.9, bty = "n", cex = 0.7)
plot(house.power.comp$Date, house.power.comp$Global_reactive_power, 
     type = "l", ylab = "Global_reactive_power", axes = TRUE, 
     xlab = "datetime")
dev.off()
