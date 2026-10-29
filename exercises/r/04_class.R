suppressPackageStartupMessages(library(tidyverse))
# library(readr)
# library(dplyr)
suppressPackageStartupMessages(library(ggplot2))
# library(forcats)
# library(lubridate)
suppressPackageStartupMessages(library(scales))
suppressPackageStartupMessages(library(patchwork))

# Carga del dataset
ventas <- read_csv("datasets/superstore.csv", show_col_types = FALSE)

# Inspección de estructura y resúmenes
glimpse(ventas)
summary(ventas |> select(sales, profit, discount))

ventas_categoria <- ventas |>
  group_by(category) |>
  summarise(total_sales = sum(sales))

grafico_cat <- ggplot(
  ventas_categoria,
  aes(x = category, y = total_sales)
) +
  # 1. Barras
  geom_col(fill = "steelblue") +
  # 2. Etiquetas de valor sobre cada barra
  geom_text(
    aes(
      label = paste0(
        "$",
        round(total_sales / 1000, 1),
        "K"
      )
    ),
    vjust = -0.3
  ) +
  # 3. Línea de referencia del promedio
  geom_hline(
    yintercept = mean(ventas_categoria$total_sales), linetype = "dashed"
  ) +
  # 4. Formato del eje Y
  scale_y_continuous(
    labels = function(x) paste0("$", x / 1000, "K")
  ) +
  # 5. Títulos
  labs(
    title = "Ventas totales por categoría",
    x = "Categoría",
    y = "Ventas (USD)"
  ) +
  # 6. Tema
  theme_minimal() +
  # 7. Personalización tipográfica
  theme(
    plot.title = element_text(
      size = 18,
      face = "bold",
      hjust = 0.5
    ),
    plot.subtitle = element_text(
      hjust = 0.5
    )
  )

#  print(grafico_cat)

top_subcat <- ventas |>
  group_by(sub_category) |>
  summarise(total_sales = sum(sales)) |>
  slice_max(total_sales, n = 8) |>
  mutate(sub_category = fct_reorder(sub_category, total_sales))

grafico_top_subcat <- ggplot(
  top_subcat,
  aes(x = total_sales, y = sub_category, fill = total_sales)
) +
  geom_col(show.legend = FALSE) +
  scale_fill_viridis_c(option = "mako", direction = -1) +
  scale_x_continuous(labels = label_dollar(scale = 1e-3, suffix = "K")) +
  labs(
    title = "Top 8 Subcategorías más vendidas",
    x = "Ventas Totales (USD)",
    y = NULL
  ) +
  theme_minimal()
# print(grafico_top_subcat)

region_metrics <- ventas |>
  group_by(region) |>
  summarise(
    ventas_totales = sum(sales),
    ganancia_total = sum(profit)
  ) |>
  mutate(
    margen_pct = (ganancia_total / ventas_totales) * 100,
    participacion_pct = ganancia_total / sum(ganancia_total) * 100,
    region = fct_reorder(region, ganancia_total, .desc = TRUE)
  )

grafico_region_pro <- ggplot(
  region_metrics,
  aes(x = region, y = ganancia_total, fill = ganancia_total)
) +
  geom_col(show.legend = FALSE) +
  geom_text(
    aes(label = paste0("Margen:\n", round(margen_pct, 1), "%")),
    vjust = 1.5,
    color = "white",
    fontface = "bold",
    size = 3.5
  ) +
  scale_fill_gradient(low = "#a1dab4", high = "#41b6c4") +
  scale_y_continuous(labels = label_dollar(scale = 1e-3, suffix = "K")) +
  labs(
    title = "Ganancia Neta y Margen de Utilidad por Región",
    subtitle = "Comparativa de la contribución real a la utilidad operacional", x = "Región", # nolint: line_length_linter.
    y = "Ganancia Neta (USD)"
  ) +
  theme_clasical()
# print(grafico_region_pro)

# Crear gráfico circular
grafico_region_pie <- ggplot(
  region_metrics,
  aes(x = "", y = ganancia_total, fill = region)
) +
  geom_col(width = 1, color = "white") +
  coord_polar(theta = "y") +
  geom_text(
    aes(
      label = paste0(
        region,
        "\n",
        round(participacion_pct, 1),
        "%"
      )
    ),
    position = position_stack(vjust = 0.5),
    color = "white",
    fontface = "bold",
    size = 4
  ) +
  scale_fill_brewer(palette = "Set2") +
  labs(
    title = "Ganancia Neta por Región",
    subtitle = "Participación porcentual de cada región en la ganancia total",
    fill = "Región"
  ) +
  theme_void() +
  theme(
    plot.title = element_text(
      hjust = 0.5,
      face = "bold",
      size = 16
    ),
    plot.subtitle = element_text(hjust = 0.5),
    legend.position = "right"
  )

# print(grafico_region_pie)

grafico_scatter_pro <- ggplot(
  ventas, aes(x = sales, y = profit, color = category)
) +
  geom_point(alpha = 0.5, size = 2.5) +
  geom_hline(
    yintercept = 0, linetype = "dashed", color = "red", linewidth = 0.8
  ) +
  scale_x_continuous(labels = label_dollar()) +
  scale_y_continuous(labels = label_dollar()) +
  labs(
    title = "Análisis de Rentabilidad por Transacción",
    subtitle = "Puntos por debajo de la línea roja ($0)
   representan pérdidas directas",
    x = "Ventas por Pedido (USD)",
    y = "Ganancia / Pérdida por Pedido (USD)",
    color = "Categoría"
  ) +
  theme_minimal()
# print(grafico_scatter_pro)

descuento_df <- ventas |>
  group_by(discount) |>
  summarise(ganancia_promedio = mean(profit))

grafico_descuentos <- ggplot(
  descuento_df,
  aes(x = discount, y = ganancia_promedio)
) +
  geom_line(color = "#DC143C", linewidth = 1.2) +
  geom_point(color = "#DC143C", size = 2.5) +
  geom_hline(yintercept = 0, linetype = "dotted", color = "black") +
  scale_x_continuous(labels = percent_format(accuracy = 1)) +
  scale_y_continuous(labels = label_dollar()) +
  labs(
    title = "Impacto del Descuento en la Ganancia Promedio",
    subtitle = "Descuentos superiores al 20%
   conducen a pérdidas promedio severas",
    x = "Porcentaje de Descuento Aplicado",
    y = "Ganancia Promedio (USD)"
  ) +
  theme_minimal()
# print(grafico_descuentos)

analisis_mensual <- ventas |>
  mutate(order_date = dmy(order_date)) |> # Formato AAAA-MM-DD: usamos ymd()
  filter(!is.na(order_date)) |>
  mutate(
    mes = month(order_date, label = TRUE, abbr = TRUE)
  ) |>
  group_by(mes) |>
  summarise(ventas = sum(sales, na.rm = TRUE))
# Verificar que la tabla tenga los 12 meses cargados
# print(analisis_mensual)

grafico_estacional <- ggplot(
  analisis_mensual,
  aes(x = mes, y = ventas, fill = ventas)
) +
  geom_col(show.legend = FALSE) +
  scale_fill_gradient(low = "#9ebcda", high = "#8c2d04") +
  scale_y_continuous(labels = label_dollar(scale = 1e-3, suffix = "K")) +
  labs(
    title = "Acumulado Histórico de Ventas por Mes",
    subtitle = "Identificación de patrones de estacionalidad en las ventas",
    x = "Mes",
    y = "Ventas Totales (USD)"
  ) +
  theme_minimal()
# print(grafico_estacional)

# Composición del dashboard usando la sintaxis de patchwork
dashboard <- (grafico_cat + grafico_region_pro) /
  (grafico_region_pie + grafico_descuentos) +
  plot_annotation(
    title = "Dashboard Resumen de Rendimiento Operativo - Superstore",
    subtitle = "Consolidado de ventas, rentabilidad,
     transacciones y política de precios",
    theme = theme(
      plot.title = element_text(size = 18, face = "bold"),
      plot.subtitle = element_text(size = 12)
    )
  )

# print(dashboard)
