# =====================================================
# Ejercicio 4
# Visualización de datos - Superstore
# Lenguaje: R
# =====================================================


library(readr)
library(dplyr)
library(ggplot2)


# -----------------------------------------------------
# Cargar datos
# -----------------------------------------------------

ventas <- read_csv(
  "datasets/superstore.csv",
  show_col_types = FALSE
)



# =====================================================
# 1. Ventas por categoría
# =====================================================

ventas_categoria <- ventas %>%
  group_by(Category) %>%
  summarise(
    Total_Sales = sum(Sales)
  )


grafico_categoria <- ggplot(
  ventas_categoria,
  aes(
    x = Category,
    y = Total_Sales
  )
) +
  geom_col(
    fill = "steelblue"
  ) +
  labs(
    title = "Ventas totales por categoría",
    x = "Categoría",
    y = "Ventas"
  ) +
  theme_minimal()

ggsave(
  "graficos/01_ventas_categoria.png",
  grafico_categoria,
  width = 8,
  height = 5
)



# =====================================================
# 2. Ganancia por región
# =====================================================

ganancia_region <- ventas %>%
  group_by(Region) %>%
  summarise(
    Total_Profit = sum(Profit)
  )


grafico_region <- ggplot(
  ganancia_region,
  aes(
    x = Region,
    y = Total_Profit
  )
) +
  geom_col(
    fill = "darkgreen"
  ) +
  labs(
    title = "Ganancia por región",
    x = "Región",
    y = "Ganancia"
  ) +
  theme_minimal()


ggsave(
  "graficos/02_ganancia_region.png",
  grafico_region,
  width = 8,
  height = 5
)



# =====================================================
# 3. Relación ventas y ganancias
# =====================================================

grafico_ventas_profit <- ggplot(
  ventas,
  aes(
    x = Sales,
    y = Profit,
    color = Category
  )
) +
  geom_point(
    alpha = 0.5
  ) +
  labs(
    title = "Relación entre ventas y ganancias",
    x = "Ventas",
    y = "Ganancia"
  ) +
  theme_minimal()


ggsave(
  "graficos/03_ventas_vs_profit.png",
  grafico_ventas_profit,
  width = 8,
  height = 5
)