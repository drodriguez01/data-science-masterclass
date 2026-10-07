library(readr)
library(dplyr)

ventas <- read_csv(
  "datasets/superstore.csv",
  show_col_types = FALSE
)

# head(ventas)
# dim(ventas)
# names(ventas)
# str(ventas)
# summary(ventas)

unique(ventas$Category)
unique(ventas$Region)

cat("\n Valores faltantes\n")
# print(colSums(is.na(ventas)))

cat("\n Porcentaje de valores faltantes \n")
faltantes <- colMeans(is.na(ventas)) * 100

# print(faltantes)

cat("\n unique a una columna \n")
print(unique(ventas$Region))

cat("\n table a una columna \n")
print(table(ventas$Region))

technology <- ventas %>%
  filter(
    Category == "Technology",
    Region == "West"
  )

cat("\n Head a technology \n")
print(head(technology))

cat("\n nrow a technology \n")
print(nrow(technology))

print("\nTotal de ventas en Technology west:")
print(sum(technology$Sales))

summary(ventas$Sales)

mean(ventas$Sales)
median(ventas$Sales)
min(ventas$Sales)
max(ventas$Sales)

cat("\nPromedio:", mean(ventas$Sales))
cat("\nMediana:", median(ventas$Sales))
cat("\nMínimo:", min(ventas$Sales))
cat("\nMáximo:", max(ventas$Sales))
cat("\nDesviación estándar:", sd(ventas$Sales))

ventas_por_categoria <- ventas %>%
  group_by(Category) %>%
  summarise(
    ventas_totales = sum(Sales),
    venta_promedio = mean(Sales),
    cantidad = n()
  )

print(ventas_por_categoria)

ventas_por_categoria_region <- ventas %>%
  group_by(Region, Category) %>%
  summarise(
    ventas_totales = sum(Sales),
    venta_promedio = mean(Sales),
    cantidad = n()
  )  %>%
  ungroup()

print(ventas_por_categoria_region)

ventas_region <- ventas %>%
  group_by(Region) %>%
  summarise(
    ventas_totales = sum(Sales)
  ) %>%
  arrange(desc(ventas_totales))

print(ventas_region)






