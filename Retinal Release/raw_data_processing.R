# ================================ OVERVIEW ====================================
# Given retinal release data, the script fits an appropriate curve, identifies
# the half-life, and graphs the curve and the data together. Note that the data
# must be in CSV file format.

# =============================== USER INPUT ===================================

data_file_location <- "rrtest1.csv"
# Change this to the CSV file containing the data. Please make sure that the 
# first data point is the point when photoactivation begins. No normalization is
# required; the script does it automatically.

curve_first_data_point <- 13
# Enter in the "index" of the first data point to be encompassed in the curve. 
# For instance, if the first point to be encompassed in the curve is the fifth 
# point in the dataset, enter "5".
# The program will omit earlier data points, and set the timepoint
# of this new datapoint as "0.00". 

x_label <- "Time"
# Change this to the desired x-axis label for the graph. The default is "Time"

y_label <- "Fluoresence"
# Change this to the desired y-axis label for the graph. THe default is 
# "Fluoresence".

decimals <- 3
# the number of decimals to display for each variable in the equation


# ================================== SCRIPT ====================================

# read the csv file (columns must be in the format: time against fluorescence)
df <- read.csv(data_file_location)

colnames(df) <- c("Time", "Fluorescence")
data_size <- length(df$Time)

df <- data.frame(df$Time[curve_first_data_point:data_size],
                 df$Fluorescence[curve_first_data_point:data_size])
colnames(df) <- c("Time", "Fluorescence")

# normalizes the data so that the maximum fluorescence is 1, and shifts the data
# so the first data point is at time = 0.
df$Fluorescence <- df$Fluorescence/max(df$Fluorescence)
df$Time <- df$Time - df$Time[1]

# plot the raw data
plot(df, xlab=x_label, ylab=y_label)

# obtain the parameters of the curve that best fits the data
model <- nls(Fluorescence ~ y0 + a * (1-exp(-k * Time)), data = df, start = list(y0 = 0, a = 1, k = 1))
summary(model)

# extracts the parameter values
z<- model$m$getPars()
y0 <- unname(z["y0"])
a <- unname(z["a"])
k <- unname(z["k"])

# sketches the line of the curve
X <- 0:(df$Time[length(df$Time)])
Y <- y0 + a * (1-exp(-k * X)) 
lines(X, Y, lty=2, lwd=1.5)

# outputs the half life
print(paste("Estimated T1/2: ", as.character(log(2)/k)))

# formats the variables to be equation ready
y0 <- format(round(y0, decimals), nsmall = decimals)
a <- format(round(a, decimals), nsmall = decimals)
k <- format(round(k, decimals), nsmall = decimals)

# print the equation
print(paste("Equation: f(t) = ", y0, " + ", a, " * (1 - exp(-", k, "t))", sep = ""))



# do the publication-ready formatting afterwards



