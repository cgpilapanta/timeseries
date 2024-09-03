# ========================================================== General Description =========================================================
# Script developed to load information of residual coordinates times series
# Developed by. Christian Gonzalo Pilapanta Amagua
# Laboratorio de Geodesia Espacial e Hidrografía. UFPR. 2024
# ============================================================== Libraries ===============================================================

library(ggplot2)
library(Hmisc)

# ======================================================== Pre-analyzing data ============================================================

# Boxplot of data with outlier
boxplot(norm_dU_g$HYDL, main = "Boxplot - Original data")

# IQR Calculation
quartiles <- quantile(norm_dU_g$HYDL, probs=c(.25, .75), na.rm = FALSE)
IQR <- IQR(norm_dU_g$HYDL)

# Limit for outliers
Lower <- quartiles[1] - 1.5*IQR
Upper <- quartiles[2] + 1.5*IQR 

# Remove outliers from a single variable in R
data_no_outlier <- subset(norm_dU_g$HYDL, norm_dU_g$HYDL > Lower & norm_dU_g$HYDL < Upper)

# Boxplot of data without outlier
boxplot(data_no_outlier, main = "Boxplot - Data without outlier")

# Remove outliers from data including multi-variables in R
norm_no_outlier <- subset(norm_dU_g, norm_dU_g$HYDL > Lower & norm_dU_g$HYDL < Upper)

# Boxplot of data without outlier
boxplot(norm_no_outlier[, -which(names(full_dU_g) == "DATETIME")], main = "Boxplot - Data without outlier")