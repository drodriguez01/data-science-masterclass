
import pandas as pd

ventas = pd.read_csv(
    "datasets/superstore.csv",
    encoding="latin-1"
)

print("\nTipos de datos\n")
print(ventas.dtypes)

print("\nValores faltanes ")
print(ventas.isnull().sum())

print("\nPorcentaje de faltantes ")
faltantes = ventas.isnull().mean() * 100
print(faltantes.sort_values(ascending=False))

print(ventas["Category"].unique())
print(ventas["Category"].value_counts())

print(ventas["Region"].value_counts())
print(ventas["Segment"].value_counts())

technology = ventas[
    (ventas["Category"] == "Technology") &
    (ventas["Region"]  == "West")
]

print("\nHead ")
print(technology.head())

print("\nShape ")
print(technology.shape)

print("\nTamaño ")
print(len(technology))

print("\nTotal de Ventas de Technology región West ")
print(technology["Sales"].sum())
print(ventas["Sales"].dtype)

print(ventas["Sales"].describe())
print("Promedio:", ventas["Sales"].mean())
print("Mediana:", ventas["Sales"].median())
print("Minimo:", ventas["Sales"].min())
print("Máxima:", ventas["Sales"].max())
print("Desviación estándar:", ventas["Sales"].std())

print("Ventas por Categoría:\n")
ventas_por_categoria = (
    ventas
    .groupby("Category")
    .agg(
        ventas_totales=("Sales", "sum"),
        venta_promedio=("Sales", "mean"),
        cantidad=("Sales", "count")
    )
)

print(ventas_por_categoria)

ventas_categoria_region = (
    ventas
    .groupby(["Region", "Category"])
    .agg(
        ventas_totales=("Sales", "sum"),
        promedio=("Sales", "mean"),
        cantidad=("Sales", "count")
    )
    .reset_index()
)
print(ventas_categoria_region)






