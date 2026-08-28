suppressPackageStartupMessages(library(tidyverse))

ventas <- read_csv(
 "datasets/superstore_dirty.csv",
 locale = locale(encoding = "latin1"),
 show_col_types = FALSE
)

cat("\nValores faltantes por columna:\n")
print(colSums(is.na(ventas)))

cat("\nRegistros duplicados totales:\n")
print(sum(duplicated(ventas)))

# Verificación de tipos de datos iniciales
glimpse(ventas %>% select(`Order Date`, `Ship Date`))

ventas <- ventas %>%
  mutate(
    `Order Date` = parse_date_time(`Order Date`, orders = c("ymd", "mdy", "dmy")),
    `Ship Date`  = parse_date_time(`Ship Date`, orders = c("ymd", "mdy", "dmy"))
  )

  glimpse(ventas %>% select(`Order Date`, `Ship Date`))

  # Cálculo de diferencia de días y promedio
ventas <- ventas %>%
  mutate(Delivery_Days = as.numeric(difftime(`Ship Date`, `Order Date`, units = "days")))

cat("\nPromedio de días de entrega:", round(mean(ventas$Delivery_Days, na.rm = TRUE)), "\n")


cat("\nRegistros duplicados antes de distinct :\n")
print(sum(duplicated(ventas)))

# Eliminar duplicados
ventas <- ventas %>% distinct()

cat("\nRegistros duplicados después de distinct :\n")
print(sum(duplicated(ventas)))

cat("Nulos restantes en Customer Name:", sum(is.na(ventas$`Customer Name`)), "\n")

#Imputar valor faltante en custmer name
ventas <- ventas %>%
  mutate(`Customer Name` = replace_na(`Customer Name`, "Cliente No Registrado"))

cat("Nulos restantes en Customer Name después:", sum(is.na(ventas$`Customer Name`)), "\n")

cat("Regiones únicas antes de limpiar:\n")
print(unique(ventas$Region))

ventas <- ventas %>%
  mutate(
    Region = str_trim(Region),
    Region = str_to_title(Region)
  )

cat("Regiones únicas después de limpiar:\n")
print(unique(ventas$Region))

# Columna Sales
ventas <- ventas %>%
  mutate(
    Sales_Clean = str_replace_all(Sales, "[\\$,]", ""), # Elimina '$' y ','
    Sales_Clean = str_trim(Sales_Clean),
    Sales_Clean = as.numeric(Sales_Clean)
  )

  mediana_sales <- median(ventas$Sales_Clean, na.rm = TRUE)

# Imputar columna Sales
  ventas <- ventas %>%
  mutate(Sales = replace_na(Sales_Clean, mediana_sales)) %>%
  select(-Sales_Clean) # Eliminar columna auxiliar

cat("Resumen estadístico de Sales:\n")
print(summary(ventas$Sales))

# Agrupación y resumen con métricas avanzadas
reporte_financiero <- ventas %>%
 group_by(Region, Category) %>%
 summarise(
   # Métricas de volumen
   Ventas_Totales   = sum(Sales, na.rm = TRUE),
   Cantidad_Pedidos = n_distinct(`Order ID`),
   Ticket_Promedio  = Ventas_Totales / Cantidad_Pedidos,
  
   # Métricas de dispersión (Media vs Mediana)
   Ventas_Promedio  = mean(Sales, na.rm = TRUE),
   Ventas_Mediana   = median(Sales, na.rm = TRUE),
  
   # Métricas de rentabilidad
   Ganancia_Total   = sum(Profit, na.rm = TRUE),
   Margen_Ganancia  = (Ganancia_Total / Ventas_Totales) * 100,
  
   .groups = "drop"
 ) %>%
 arrange(desc(Ventas_Totales))

glimpse(reporte_financiero)


# Doble dimensión
reporte_region_categoria <- ventas %>%
  group_by(Region, Category) %>%
  summarise(
    Ventas_Totales   = sum(Sales, na.rm = TRUE),
    Ganancia_Total   = sum(Profit, na.rm = TRUE),
    Cantidad_Pedidos = n_distinct(`Order ID`),
    .groups          = "drop"
  ) %>%
  arrange(Region, desc(Ventas_Totales))

  glimpse(reporte_region_categoria)

  participacion_region <- ventas %>%
 group_by(Region, Category) %>%
 summarise(
   Ventas_Totales = sum(Sales, na.rm = TRUE)
 ) %>%
 mutate(
   Participacion = round(
     Ventas_Totales / sum(Ventas_Totales) * 100,
     2
   )
 ) %>%
 arrange(desc(Region))

 print(participacion_region)
 
 # Crear la carpeta si no existe (buena práctica de automatización)
if (!dir.exists("datasets")) {
 dir.create("datasets")
}

# Exportar dataset limpio (datos detallados nivel transacción)
write_csv(ventas, "datasets/superstore_clean.csv")
write_csv(ventas, "datasets/reporte_financiero.csv")

cat("\n¡Dataset limpio exportado exitosamente a 'datasets/superstore_clean.csv'!\n")





