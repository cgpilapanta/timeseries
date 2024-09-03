# ========================================================== General Description =========================================================
# Script developed to load information of residual coordinates times series
# Developed by. Christian Gonzalo Pilapanta Amagua
# Laboratorio de Geodesia Espacial e Hidrografía. UFPR. 2024
# ============================================================== Libraries ===============================================================

library(ggplot2)
library(Hmisc)

# ======================================================== Pre-analyzing data ============================================================

# Summary of data frame
summary(full_dU_g)

# Create boxplot
boxplot(full_dU_g[, -which(names(full_dU_g) == "DATETIME")], main = "Boxplot - Original data")

# Create histogram
hist.data.frame(full_dU_g[, -which(names(full_dU_g) == "DATETIME")])

# Normalizing data
norm_dU_g <- data.frame(full_dU_g$DATETIME, 
                        full_dU_g$dU_GPS - mean(full_dU_g$dU_GPS),
                        full_dU_g$dU_HYDL - mean(full_dU_g$dU_HYDL),
                        full_dU_g$dU_NTAL - mean(full_dU_g$dU_NTAL),
                        full_dU_g$dU_NTOL - mean(full_dU_g$dU_NTOL),
                        full_dU_g$dU_SLEL - mean(full_dU_g$dU_SLEL),
                        full_dU_g$dU_GRACE - mean(full_dU_g$dU_GRACE))

colnames(norm_dU_g) <- c("DATETIME", "GPS", "HYDL", "NTAL", "NTOL", "SLEL", "GRACE")

# Summary of data frame
summary(norm_dU_g)

# Create boxplot
boxplot(norm_dU_g[, -which(names(norm_dU_g) == "DATETIME")], main = "Boxplot - Normalize data")

# Create histogram
hist.data.frame(norm_dU_g[, -which(names(norm_dU_g) == "DATETIME")])

# Plotting data
ggplot(norm_dU_g, aes(x=DATETIME)) + 
  geom_point(aes(y = GPS), color = "Black") +
  geom_line(aes(y = HYDL, color = "HYDL")) +
  geom_line(aes(y = NTAL, color = "NTAL")) +
  geom_line(aes(y = NTOL, color = "NTOL")) +
  geom_line(aes(y = SLEL, color = "SLEL")) +
  geom_line(aes(y = GRACE, color = "GRACE")) +
  labs(y = "dU (mm)", x = "Year", colour = "Loading signals") +
  ggtitle("BOAV Continuous GNSS Station. Up Component + Loading signals")

# ========================================================== Analyzing data ==============================================================

# Cross-lagged correlation analysis
ccf(norm_dU_g$GPS, norm_dU_g$HYDL, xlab = "Lag, years", ylab = "Cross-correlation", main = 'Cross-correlation GPS x HYDL')

# Autocorrelation analysis
acf(as.numeric(norm_dU_g$GPS), lag.max = 48, xlab = "Lag, years", ylab = "Autocorrelation", main = "Autocorrelation")


