# library(tidyverse)
suppressPackageStartupMessages(library(tidyverse))

ventas <- read_csv("datasets/superstore.csv", locale = locale(encoding = "latin1"))

# print(names(ventas))
colnames(ventas) <- str_replace_all(colnames(ventas), " ", "_")
colnames(ventas) <- str_replace_all(colnames(ventas), "-", "_")
# print(names(ventas))

# Función
analizar_top_productos <- function(datos, variable_grupo, variable_orden, top_n = 10) {
  datos %>%
    group_by({{ variable_grupo }}) %>%
    summarise(
      Ventas = sum(Sales, na.rm = TRUE),
      Ganancia = sum(Profit, na.rm = TRUE),
      Cantidad = sum(Quantity, na.rm = TRUE)
    ) %>%
    arrange({{ variable_orden }}) %>%
    slice_head(n = top_n)
}

cat("\nVentas por categoría\n")

# ventas_categoria <- ventas %>%
#   group_by(Category) %>%
#   summarise(
#     Total_Sales = sum(Sales)
#   ) %>%
#   arrange(desc(Total_Sales))

# print(ventas_categoria)

conteo_ordenes <- ventas %>%
  count(Category) %>%
  arrange(desc(n))

  cat("\nConteo de transacciones por categoría:\n")
print(conteo_ordenes)

# Cuadro Categoría
cuadro_categoria <- ventas %>%
  group_by(Category) %>%
  summarise(
    Ventas_Totales   = sum(Sales, na.rm = TRUE),
    Ganancia_Total   = sum(Profit, na.rm = TRUE),
    Unidades_Vendidas = sum(Quantity, na.rm = TRUE),
    Ticket_Promedio  = mean(Sales, na.rm = TRUE)
  ) %>%
  mutate(
    Margen_porcentual = round((Ganancia_Total / Ventas_Totales) * 100, 2)
  ) %>%
  arrange(desc(Margen_porcentual))

cat("\n--- CUADRO DE MANDO INTEGRAL POR CATEGORÍA ---\n")
print(cuadro_categoria, width = Inf)

# Análisis de descuentos
analisis_descuentos <- ventas %>%
  group_by(Region) %>%
  summarise(
    Ganancia_Promedio  = mean(Profit, na.rm = TRUE),
    Descuento_Promedio = mean(Discount, na.rm = TRUE)
  ) %>%
  arrange(desc(Descuento_Promedio))

cat("\nAnálisis de Descuentos por Región:\n")
print(analisis_descuentos)

# Matriz Región y Categoría
matriz_region_categoria <- ventas %>%
  group_by(Region, Category) %>%
  summarise(
    Ventas   = sum(Sales, na.rm = TRUE),
    Ganancia = sum(Profit, na.rm = TRUE),
    .groups  = "drop"
  )  %>%
arrange(Ganancia)

cat("\n--- ANÁLISIS CRUZADO: REGIÓN Y CATEGORÍA ---\n")
print(matriz_region_categoria)

# Subcategorías con menor ganancia
subcat_perdidas <- ventas %>%
  group_by(Sub_Category) %>%
  summarise(Profit = sum(Profit, na.rm = TRUE)) %>%
  arrange(Profit) %>%
  slice_head(n = 5)

cat("\nTop 5 Sub-Categorías con Pérdidas:\n")
print(subcat_perdidas)

# Cuadro pareto
venta_global <- sum(ventas$Sales, na.rm = TRUE)

analisis_pareto <- ventas %>%
  group_by(Customer_Name) %>%
  summarise(
    Ventas_Totales = sum(Sales, na.rm = TRUE),
    Total_Ordenes  = n_distinct(Order_ID)
  ) %>%
  arrange(desc(Ventas_Totales)) %>%
  mutate(
    Aporte_porcentual    = round((Ventas_Totales / venta_global) * 100, 2),
    Acumulado_porcentual = round(cumsum(Aporte_porcentual), 2)
  )

cat("\n--- ANÁLISIS DE PARETO DE CLIENTES (TOP 10) ---\n")
print(head(analisis_pareto, 10))

# Clientes que representan el 10% de mis ventas
clientes_top_10 <- analisis_pareto %>%
  filter(Acumulado_porcentual <= 10)

cat("\nNúmero de clientes que generan el primer 10% de la venta total:"
, nrow(clientes_top_10), "\n")


# Analisis de productos
# analisis_productos <- ventas %>%
#  group_by(Product_Name) %>%
#  summarise(
#    Ventas = sum(Sales, na.rm = TRUE),
#    Ganancia = sum(Profit, na.rm = TRUE),
#    Cantidad = sum(Quantity, na.rm = TRUE)
#  ) %>%
#  arrange(Ganancia) %>%
#  slice_head(n = 10)

# cat("\nAnálisis de Productos:\n")
# print(analisis_productos)


cat("\nTop Productos\n")
print(analizar_top_productos(ventas, Product_Name, Ganancia, 5))

# Columna Fecha y introducir el tiempo  Order_Date
ventas <- ventas %>%
mutate(Order_Date = lubridate::mdy(Order_Date))

analisis_mensual <- ventas %>%
mutate(Mes = lubridate::month(Order_Date, label= TRUE)) %>%
group_by(Mes) %>%
summarise(
    Ventas = sum(Sales, na.rm = TRUE)
)

print(analisis_mensual)







