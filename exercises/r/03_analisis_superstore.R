# =====================================================
# Ejercicio 3
# Análisis de datos - Superstore
# =====================================================

library(readr)
library(dplyr)


# Cargar datos

ventas <- read_csv(
  "datasets/superstore.csv",
  show_col_types = FALSE
)


# =====================================================
# 1. Ventas por categoría
# =====================================================

cat("\nVentas por categoría\n")

ventas_categoria <- ventas %>%
  group_by(Category) %>%
  summarise(
    Total_Sales = sum(Sales)
  ) %>%
  arrange(desc(Total_Sales))


print(ventas_categoria)


# =====================================================
# 2. Ganancia por región
# =====================================================

cat("\nGanancia por región\n")

ganancia_region <- ventas %>%
  group_by(Region) %>%
  summarise(
    Total_Profit = sum(Profit)
  ) %>%
  arrange(desc(Total_Profit))


print(ganancia_region)



# =====================================================
# 3. Top 10 productos
# =====================================================

cat("\nTop 10 productos\n")

top_productos <- ventas %>%
  group_by(`Product Name`) %>%
  summarise(
    Total_Sales = sum(Sales)
  ) %>%
  arrange(desc(Total_Sales)) %>%
  head(10)


print(top_productos)



# =====================================================
# 4. Top 10 clientes
# =====================================================

cat("\nTop 10 clientes\n")

top_clientes <- ventas %>%
  group_by(`Customer Name`) %>%
  summarise(
    Total_Sales = sum(Sales)
  ) %>%
  arrange(desc(Total_Sales)) %>%
  head(10)


print(top_clientes)