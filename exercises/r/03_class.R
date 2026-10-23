# Carga de la librería principal (tidyverse) de forma silenciosa
suppressPackageStartupMessages(library(tidyverse))

# Carga del dataset con codificación latina
ventas <- read_csv(
  "datasets/superstore.csv",
  locale = locale(encoding = "latin1")
)

print(names(ventas))

colnames(ventas) <- str_replace_all(colnames(ventas), " ", "_")
colnames(ventas) <- str_replace_all(colnames(ventas), "-", "_")
colnames(ventas) <- tolower(colnames(ventas))

print(names(ventas))

ventas_categoria <- ventas |>
  group_by(category) |>
  summarise(sales = sum(sales, na.rm = TRUE)) |>
  arrange(desc(sales))

cat("\nVentas por categoría:\n")
print(ventas_categoria)

conteo_ordenes <- ventas |>
  # count(category, sort = TRUE)
  count(category) |>
  arrange(category)

cat("\nConteo de transacciones por categoría:\n")
print(conteo_ordenes)

# -----------------------------------------
# 2. Ganancia por región
# -----------------------------------------
ganancia_region <- ventas |>
  group_by(region) |>
  summarise(profit = sum(profit, na.rm = TRUE)) |>
  arrange(desc(profit))

cat("\nGanancia por región:\n")
print(ganancia_region)

cuadro_categoria <- ventas |>
  group_by(category) |>
  summarise(
    ventas_totales = sum(sales, na.rm = TRUE),
    ganancia_total = sum(profit, na.rm = TRUE),
    unidades_vendidas = sum(quantity, na.rm = TRUE),
    ticket_promedio = mean(sales, na.rm = TRUE)
  ) |>
  mutate(
    margen_porcentual = round((ganancia_total / ventas_totales) * 100, 2)
  ) |>
  arrange(desc(margen_porcentual))

cat("\n--- CUADRO DE MANDO INTEGRAL POR CATEGORÍA ---\n")
print(cuadro_categoria, width = Inf)

analisis_descuentos <- ventas |>
  group_by(region) |>
  summarise(
    ganancia_promedio = mean(profit, na.rm = TRUE),
    descuento_promedio = mean(discount, na.rm = TRUE)
  ) |>
  arrange(desc(descuento_promedio))

cat("\nAnálisis de descuentos por región:\n")
print(analisis_descuentos)

# -----------------------------------------
# 3. Top 10 productos vendidos
# -----------------------------------------
top_productos <- ventas |>
  group_by(product_name) |>
  summarise(sales = sum(sales, na.rm = TRUE)) |>
  arrange(desc(sales)) |>
  slice_head(n = 10)

cat("\nTop 10 productos:\n")
print(top_productos)

top_clientes <- ventas |>
  group_by(customer_name) |>
  summarise(sales = sum(sales, na.rm = TRUE)) |>
  arrange(desc(sales)) |>
  slice_head(n = 10)

cat("\nTop 10 clientes:\n")

print(top_clientes)

matriz_region_categoria <- ventas |>
  group_by(region, category) |>
  summarise(
    ventas = sum(sales, na.rm = TRUE),
    ganancia = sum(profit, na.rm = TRUE),
    .groups = "drop"
  ) |>
  arrange(ganancia)

cat("\n--- ANÁLISIS CRUZADO: REGIÓN Y CATEGORÍA ---\n")
print(matriz_region_categoria)

subcat_perdidas <- ventas |>
  group_by(sub_category) |>
  summarise(profit = sum(profit, na.rm = TRUE)) |>
  arrange(profit) |>
  slice_head(n = 5)
cat("\nTop 5 sub-categorías con pérdidas:\n")
print(subcat_perdidas)

# analisis_pareto <- ventas |>
#   group_by(customer_name) |>
#   summarise(
#     ventas_totales = sum(sales, na.rm = TRUE),
#     total_ordenes = n_distinct(order_id)
#   ) |>
#   arrange(desc(ventas_totales)) |>
#   mutate(
#     # aporte_porcentual = round((ventas_totales / venta_global) * 100, 2),
#     aporte_porcentual = (ventas_totales / venta_global) * 100,
#     # acumulado_porcentual = round(cumsum(aporte_porcentual), 2)
#     acumulado_porcentual = cumsum(aporte_porcentual)
#   )

# cat("\n--- ANÁLISIS DE PARETO DE CLIENTES (TOP 10) ---\n")
# print(head(analisis_pareto, 10))

venta_global <- sum(ventas$sales, na.rm = TRUE)
analisis_pareto <- function(datos, venta_global) {
  # Análisis de Pareto por cliente
  resultado <- datos |>
    group_by(customer_name) |>
    summarise(
      ventas_totales = sum(sales, na.rm = TRUE),
      total_ordenes = n_distinct(order_id),
      .groups = "drop"
    ) |>
    arrange(desc(ventas_totales)) |>
    mutate(
      aporte_porcentual = (ventas_totales / venta_global) * 100,
      acumulado_porcentual = cumsum(aporte_porcentual)
    )

  return(resultado)
}

# Llamada de la función
# resultado_pareto <- analisis_pareto(venta_global)

print(analisis_pareto(ventas, venta_global))

# print(analisis_pareto(ventas_2020, venta_global))
# print(analisis_pareto(ventas_2021, venta_global))

# clientes_top_10 <- resultado_pareto |>
#   filter(acumulado_porcentual <= 10)

# print(head(resultado_pareto, 16))
# cat(
#   "\nNúmero de clientes que generan el primer 10% de la venta total:",
#   nrow(clientes_top_10), "\n"
# )
