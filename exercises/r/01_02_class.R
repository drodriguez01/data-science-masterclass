# Librerías

library(readr)
library(dplyr)

# -----------------------------------------------------
# 1. Cargar dataset
# -----------------------------------------------------
ventas <- read_csv(
  "datasets/superstore.csv",
  show_col_types = FALSE
)

cat("\n Valores Faltantes \n")
print(colSums(is.na(ventas)))

#Explorar variables categorícas
unique(ventas$Category)

table(ventas$Category)
table(ventas$Region)
table(ventas$Segment)

print("\nTipo de datos:\n")
print(class(ventas$Sales))

resultado <- ventas %>%
    filter(
        Category == "Technology",
        Region == "West"
    )

    print("\nTotal de ventas:")
    print(sum(resultado$Sales))

    #Resumen estadistíco 
    summary(ventas)
    cat("\nPromedio: ", mean(ventas$Sales),"\n")
    cat("\nMediana: ", median(ventas$Sales),"\n")
    cat("\nMínimo: ", min(ventas$Sales),"\n")
    cat("\nMáximo: ", max(ventas$Sales),"\n")
    cat("\nDesviación Estándar: ", sd(ventas$Sales),"\n")

    #ventas por categoría
    cat("\nVentas por Categoría:\n")
    ventas_por_categoria <- ventas %>%
    group_by(Category) %>%
    summarise(
        ventas_totales = sum(Sales),
        venta_promedio = mean(Sales),
        cantidad = n()
    )

    print(ventas_por_categoria)

    cat("\nVentas por Categoría y Región:\n")
    ventas_region_categoria <- ventas %>%
    group_by(Region, Category) %>%
    summarise(
        ventas_totales = sum(Sales),
        venta_promedio = mean(Sales),
        cantidad = n()
    )

    print(ventas_region_categoria)