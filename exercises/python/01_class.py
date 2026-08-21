import pandas as pd


# Cargar datos
ventas = pd.read_csv(
    "datasets/superstore.csv",
    encoding="latin-1"
)

print(ventas.dtypes)

# ventas = ventas.drop(columns=["Unnamed: 21"])
# print("\nValores Faltantes:")
# print(ventas.isnull().sum())
print("\nCategorias:")
print(ventas["Category"].unique())
print(ventas["Category"].value_counts())

print("\nFiltro de Categoría Technology:")
technology = ventas[
    ventas["Category"] == "Technology"
]

print(technology.head())
print(technology.shape)
print(len(technology))

print("\nFiltro de Categoría y Región:")

region_category = ventas[
    (ventas["Category"] == "Technology") &
    (ventas["Region"] == "West")
]

print(region_category.shape)
print("\nTotal de Ventas Categoría Technology y Región West:")
print(region_category['Sales'].sum())

print("\nEstadísticas")
print(ventas.describe())
print("Promedio:", ventas['Sales'].mean())
print("Mediana:", ventas['Sales'].median())
print("Mínima:", ventas['Sales'].min())
print("Máxima:", ventas['Sales'].max())
print("Desviación Estándar:", ventas['Sales'].std())

print("\nVentas Agrupación: ")
ventas_por_categoria = (
    ventas
    .groupby("Category")
    .agg(
        ventas_totales = ("Sales","sum"),
        venta_promedio = ("Sales","mean"),
        cantidad = ("Sales","count")
    )
)

print(ventas_por_categoria)

print("\nVentas Agrupación categoría y la región: ")
ventas_region_categoria = (
    ventas
    .groupby(["Region","Category"])
    .agg(
        ventas_totales = ("Sales","sum"),
        venta_promedio = ("Sales","mean"),
        cantidad = ("Sales","count")
    )
)

print(ventas_region_categoria)


print("Ventas por región:")
ventas_region = (
    ventas
    .groupby("Region")["Sales"]
    .sum()
    .sort_values(ascending=False)
)
print(ventas_region)