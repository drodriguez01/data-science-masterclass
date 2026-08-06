# =====================================================
# Ejercicio 2
# Limpieza y preparación de datos - Superstore
# =====================================================


library(readr)
library(dplyr)


# Cargar dataset

ventas <- read_csv(
  "datasets/superstore.csv",
  show_col_types = FALSE
)


# -----------------------------------------
# 1. Valores faltantes
# -----------------------------------------

cat("\nValores faltantes por columna\n")

print(
  colSums(is.na(ventas))
)


# -----------------------------------------
# 2. Duplicados
# -----------------------------------------

cat("\nCantidad de duplicados\n")

print(
  sum(duplicated(ventas))
)


# -----------------------------------------
# 3. Convertir fechas
# -----------------------------------------

ventas <- ventas %>%
  mutate(
    `Order Date` = as.Date(
      `Order Date`,
      format="%m/%d/%Y"
    ),
    
    `Ship Date` = as.Date(
      `Ship Date`,
      format="%m/%d/%Y"
    )
  )


cat("\nTipos de fecha\n")

print(
  class(ventas$`Order Date`)
)


# -----------------------------------------
# 4. Crear días de entrega
# -----------------------------------------

ventas <- ventas %>%
  mutate(
    Delivery_Days =
      as.numeric(
        `Ship Date` - `Order Date`
      )
  )


cat("\nEjemplo nueva variable\n")

print(
  ventas %>%
    select(
      `Order Date`,
      `Ship Date`,
      Delivery_Days
    ) %>%
    head()
)


# -----------------------------------------
# 5. Promedio días entrega
# -----------------------------------------

cat("\nPromedio días de entrega\n")

print(
  mean(
    ventas$Delivery_Days
  )
)