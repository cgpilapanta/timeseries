# ========================================================== General Description =========================================================
# Script developed to load information of residual coordinates times series
# Developed by. Christian Gonzalo Pilapanta Amagua
# Laboratorio de Geodesia Espacial e Hidrografía. UFPR. 2024
# ============================================================== Libraries ===============================================================

library(readr)
library(lubridate)
library(tidyverse)

# ============================================================== Load data ==============================================================

main_dir = "C:/Users/lageh/Downloads/TEG_Cap_02_Data/"

# xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx nGPS Station xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

# ++++++++++++++++++
sta_name = "BOAV"
# ++++++++++++++++++

# Load information

# GPS coordinates data
nGPS_data <- read_table(paste0(main_dir, "GPS/NGL_ENU.", sta_name, "_DLY.txt"), 
                        col_names = FALSE, col_types = cols(X1 = col_date(format = "%Y-%m-%d"), 
                                                            X2 = col_time(format = "%H:%M:%S")))

nGPS_data$datetime <- with(nGPS_data, ymd(nGPS_data$X1) + hms(nGPS_data$X2))

colnames(nGPS_data) <- c("DATE", "TIME", "DEC_YEAR", "MJD", "dN_GPS", "dE_GPS", "dU_GPS", "DATETIME")

# Hydrological loading data
hydl_data <- read_table(paste0(main_dir, "HYDL/HYDL_CF.", sta_name, "_24H.txt"),
                        col_names = FALSE, col_types = cols(X1 = col_date(format = "%Y-%m-%d"), 
                                                            X2 = col_time(format = "%H:%M:%S")))

hydl_data$datetime <- with(hydl_data, ymd(hydl_data$X1) + hms(hydl_data$X2))

colnames(hydl_data) <- c("DATE", "TIME", "DEC_YEAR", "MJD", "dN_HYDL", "dE_HYDL", "dU_HYDL", "DATETIME")

# Non-tidal atmospheric loading data
ntal_data <- read_table(paste0(main_dir, "NTAL/NTAL_CF.", sta_name, "_03H.txt"),
                        col_names = FALSE, col_types = cols(X1 = col_date(format = "%Y-%m-%d"), 
                                                            X2 = col_time(format = "%H:%M:%S")))

ntal_data$datetime <- with(ntal_data, ymd(ntal_data$X1) + hms(ntal_data$X2))

colnames(ntal_data) <- c("DATE", "TIME", "DEC_YEAR", "MJD", "dN_NTAL", "dE_NTAL", "dU_NTAL", "DATETIME")

# Non-tidal oceanic loading data
ntol_data <- read_table(paste0(main_dir, "NTOL/NTOL_CF.", sta_name, "_03H.txt"),
                        col_names = FALSE, col_types = cols(X1 = col_date(format = "%Y-%m-%d"), 
                                                            X2 = col_time(format = "%H:%M:%S")))

ntol_data$datetime <- with(ntol_data, ymd(ntol_data$X1) + hms(ntol_data$X2))

colnames(ntol_data) <- c("DATE", "TIME", "DEC_YEAR", "MJD", "dN_NTOL", "dE_NTOL", "dU_NTOL", "DATETIME")

# Sea-level equation loading data
slel_data <- read_table(paste0(main_dir, "SLEL/SLEL_CF.", sta_name, "_24H.txt"),
                        col_names = FALSE, col_types = cols(X1 = col_date(format = "%Y-%m-%d"), 
                                                            X2 = col_time(format = "%H:%M:%S")))

slel_data$datetime <- with(slel_data, ymd(slel_data$X1) + hms(slel_data$X2))

colnames(slel_data) <- c("DATE", "TIME", "DEC_YEAR", "MJD", "dN_SLEL", "dE_SLEL", "dU_SLEL", "DATETIME")

# GRACE data
grac_data <- read_table(paste0(main_dir, "GRACE/GRAC_CF.", sta_name, "_MES.txt"),
                        col_names = FALSE, col_types = cols(X1 = col_date(format = "%Y-%m-%d"), 
                                                            X2 = col_time(format = "%H:%M:%S")))

grac_data$datetime <- with(grac_data, ymd(grac_data$X1) + hms(grac_data$X2))

colnames(grac_data) <- c("DATE", "TIME", "DEC_YEAR", "MJD", "dU_GRACE", "DATETIME")

# xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx merge Data xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

# Put all data frames into list
data_list_1 <- list(nGPS_data, hydl_data, ntal_data, ntol_data, slel_data)
data_list_2 <- list(nGPS_data, hydl_data, ntal_data, ntol_data, slel_data, grac_data)      

# Merge all data frames together
temp_data_1 <- data_list_1 %>% reduce(full_join, by='DATETIME')
temp_data_2 <- data_list_2 %>% reduce(full_join, by='DATETIME')

# Remove NA Values
clean_data_1 <- na.omit(temp_data_1)
clean_data_2 <- na.omit(temp_data_2)

# Create full info data frame
full_data <- select(clean_data_1, DATETIME, dE_GPS, dN_GPS, dU_GPS, dE_HYDL, dN_HYDL, dU_HYDL, 
                    dE_NTAL, dN_NTAL, dU_NTAL, dE_NTOL, dN_NTOL, dU_NTOL, dE_SLEL, dN_SLEL, dU_SLEL)

full_dU_w <- select(clean_data_1, DATETIME, dU_GPS, dU_HYDL, dU_NTAL, dU_NTOL, dU_SLEL)

full_dU_g <- select(clean_data_2, DATETIME, dU_GPS, dU_HYDL, dU_NTAL, dU_NTOL, dU_SLEL, dU_GRACE)

# Remove temporal files
rm(data_list_1, data_list_2, temp_data_1, temp_data_2, clean_data_1, clean_data_2)