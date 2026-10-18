# =====================================================
# CÓDIGO DE COMPARACIÓN EN R (Sucio vs. Limpio)
# =====================================================
suppressPackageStartupMessages(library(tidyverse))

df_sucio <- read_csv("datasets/superstore_dirty.csv", locale = locale(encoding = "latin1"))
df_limpio <- read_csv("datasets/superstore_clean.csv")

cat(rep("=", 50), "\n", sep = "")
cat(" COMPARATIVA DE DATASETS (R / tidyverse)\n")
cat(rep("=", 50), "\n", sep = "")

# A. Cantidad de filas
filas_sucio <- nrow(df_sucio)
filas_limpio <- nrow(df_limpio)
cat(sprintf(" Filas en Dataset Sucio: %d\n", filas_sucio))
cat(sprintf(" Filas en Dataset Limpio: %d\n", filas_limpio))
cat(sprintf(" -> Filas duplicadas eliminadas: %d\n\n", filas_sucio - filas_limpio))

# B. Valores nulos
nulos_sucio <- sum(is.na(df_sucio))
nulos_limpio <- sum(is.na(df_limpio))
cat(" Total de Valores Nulos (NA):\n")
cat(sprintf(" -> En dataset sucio: %d\n", nulos_sucio))
cat(sprintf(" -> En dataset limpio: %d\n\n", nulos_limpio))

# C. Formato / tipos de datos en 'Sales'
cat(" Tipo de dato en la columna 'Sales':\n")
cat(sprintf(" -> En dataset sucio: %s\n", class(df_sucio$Sales)))
cat(sprintf(" -> En dataset limpio: %s\n\n", class(df_limpio$Sales)))

# D. Categorías únicas en 'Region'
reg_sucio <- n_distinct(df_sucio$Region, na.rm = TRUE)
reg_limpio <- n_distinct(df_limpio$Region, na.rm = TRUE)
cat(" Regiones distintas detectadas:\n")
cat(sprintf(" -> En dataset sucio: %d variaciones\n", reg_sucio))
cat(sprintf(" ->  En dataset limpio: %d regiones estandarizadas\n", reg_limpio))
cat(rep("=", 50), "\n", sep = "")
