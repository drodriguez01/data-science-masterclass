suppressPackageStartupMessages(library(tidyverse))

ventas <- read_csv(
  "datasets/superstore_dirty.csv",
  locale = locale(encoding = "latin1"),
  show_col_types = FALSE
)

cat("\nValores faltantes por columna\n")

print(
  colSums(is.na(ventas))
)


# Verificación de tipos de datos iniciales
glimpse(ventas |> select(`Order Date`, `Ship Date`))

# Conversión a fecha con lubridate
ventas <- ventas |>
  mutate(
    `Order Date` = parse_date_time(
      `Order Date`,
      orders = c("ymd", "mdy", "dmy")
    ),
    `Ship Date` = parse_date_time(`Ship Date`, orders = c("ymd", "mdy", "dmy"))
  )

# Cálculo de la diferencia de días (tiempo de entrega)
ventas <- ventas |>
  mutate(
    Delivery_Days = as.numeric(
      difftime(`Ship Date`, `Order Date`, units = "days")
    )
  )

# Promedio de días de entrega (valor sin redondear)
cat(
  "\nPromedio de días de entrega:",
  round(mean(ventas$Delivery_Days, na.rm = TRUE)), "\n"
)


cat("\nCantidad de duplicados antes\n")
print(sum(duplicated(ventas)))
# 1. Eliminar duplicados manteniendo la primera ocurrencia
ventas <- ventas |> distinct()

cat("\nCantidad de duplicados después\n")
print(sum(duplicated(ventas)))

cat(
  "Nulos restantes en Customer Name antes:",
  sum(is.na(ventas$`Customer Name`)), "\n"
)

# 2. Imputar valores faltantes en 'Customer Name' usando replace_na()
ventas <- ventas |>
  mutate(`Customer Name` = replace_na(
    `Customer Name`, "Cliente No Registrado"
  ))
cat(
  "Nulos restantes en Customer Name después:",
  sum(is.na(ventas$`Customer Name`)), "\n"
)

# Inspección previa de categorías únicas
cat("Regiones únicas antes de limpiar:\n")
print(unique(ventas$Region))

# Limpieza con stringr:
# str_trim() elimina espacios sobrantes
# str_to_title() estandariza a Mayúscula Inicial
ventas <- ventas |>
  mutate(
    Region = str_trim(Region),
    Region = str_to_title(Region)
  )
cat("\nRegiones únicas corregidas:\n")
print(unique(ventas$Region))

# 1. Limpieza de símbolos y conversión a numérico
ventas <- ventas |>
  mutate(
    Sales_Clean = str_replace_all(Sales, "[\\$,]", ""), # elimina '$' y ','  Sales_Clean = str_trim(Sales_Clean),
    Sales_Clean = as.numeric(Sales_Clean)
  )

# 2. Imputar nulos con la mediana
mediana_sales <- median(ventas$Sales_Clean, na.rm = TRUE)

ventas <- ventas |>
  mutate(Sales = replace_na(Sales_Clean, mediana_sales)) |>
  select(-Sales_Clean) # eliminar columna auxiliar

cat("Resumen estadístico de Sales:\n")
print(summary(ventas$Sales))

# Agrupación y resumen con métricas avanzadas
reporte_financiero <- ventas |>
  group_by(Region) |>
  summarise(
    # Métricas de volumen
    Ventas_Totales = sum(Sales, na.rm = TRUE),
    Cantidad_Pedidos = n_distinct(`Order ID`),
    Ticket_Promedio = Ventas_Totales / Cantidad_Pedidos,
    # Métricas de dispersión (media vs. mediana)
    Ventas_Promedio = mean(Sales, na.rm = TRUE),
    Ventas_Mediana = median(Sales, na.rm = TRUE),
    # Métricas de rentabilidad
    Ganancia_Total = sum(Profit, na.rm = TRUE),
    Margen_Ganancia = (Ganancia_Total / Ventas_Totales) * 100,
    .groups = "drop"
  ) |>
  arrange(desc(Ventas_Totales))

print(reporte_financiero)
glimpse(reporte_financiero)
write_csv(reporte_financiero, "datasets/reporte_financiero.csv")

# Resumen por doble dimensión
reporte_region_categoria <- ventas |>
  group_by(Region, Category) |>
  summarise(
    Ventas_Totales = sum(Sales, na.rm = TRUE),
    Ganancia_Total = sum(Profit, na.rm = TRUE),
    Cantidad_Pedidos = n_distinct(`Order ID`),
    .groups = "drop"
  ) |>
  arrange(Region, desc(Ventas_Totales))

print(reporte_region_categoria)
glimpse(reporte_region_categoria)

participacion_region <- ventas |>
  group_by(Region) |>
  summarise(
    Ventas_Totales = sum(Sales, na.rm = TRUE)
  ) |>
  mutate(
    Participacion = round(
      Ventas_Totales / sum(Ventas_Totales) * 100,
      2
    )
  ) |>
  arrange(desc(Participacion))


print(participacion_region)

total_ventas <- sum(ventas$Sales, na.rm = TRUE)
print(total_ventas)

# Exportación ordenada a la carpeta de destino
# Crear la carpeta si no existe (buena práctica de automatización/idempotencia)
if (!dir.exists("datasets")) {
  dir.create("datasets")
}

# Exportar dataset limpio (datos detallados a nivel de transacción)
write_csv(ventas, "datasets/superstore_clean.csv")

cat("\n¡Dataset limpio exportado exitosamente a 'datasets/superstore_clean.csv'!\n")
