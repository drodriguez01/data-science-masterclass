# =====================================================
# Ejercicio 1
# Exploración dataset Superstore
# Lenguaje: R
# =====================================================


# Librerías

library(readr)
library(dplyr)


# -----------------------------------------------------
# 1. Cargar dataset
# -----------------------------------------------------

ventas <- read_csv(
  "datasets/superstore.csv"
)


# -----------------------------------------------------
# 2. Primeros registros
# -----------------------------------------------------

cat("\nPrimeros registros\n")

print(
  head(ventas)
)


# -----------------------------------------------------
# 3. Dimensiones del dataset
# -----------------------------------------------------

cat("\nDimensiones del dataset\n")

print(
  dim(ventas)
)


# -----------------------------------------------------
# 4. Nombre de columnas
# -----------------------------------------------------

cat("\nColumnas disponibles\n")

print(
  names(ventas)
)


# -----------------------------------------------------
# 5. Estructura del dataset
# -----------------------------------------------------

cat("\nEstructura del dataset\n")

str(ventas)


# -----------------------------------------------------
# 6. Resumen estadístico
# -----------------------------------------------------

cat("\nResumen estadístico\n")

summary(ventas)


# -----------------------------------------------------
# 7. Categorías disponibles
# -----------------------------------------------------

cat("\nCategorías\n")

print(
  unique(ventas$Category)
)


# -----------------------------------------------------
# 8. Regiones disponibles
# -----------------------------------------------------

cat("\nRegiones\n")

print(
  unique(ventas$Region)
)