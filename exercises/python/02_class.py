import pandas as pd

# 1. Cargar dataset

ventas = pd.read_csv(
    "datasets/superstore_dirty.csv",
    encoding="latin-1"
)

print("\nRegistros duplicados:")
print(ventas.duplicated().sum())

print("\nValores faltantes:")
print(ventas.isnull().sum())

# 1. Eliminar duplicados manteniendo la primera ocurrencia
ventas = ventas.drop_duplicates()

print("\nRegistros duplicados:")
print(ventas.duplicated().sum())

print("Nulos restantes en Customer Name antes de hacer la imputación:", ventas["Customer Name"].isnull().sum())

# 2. Imputar valores faltantes en 'Customer Name'
ventas["Customer Name"] = ventas["Customer Name"].fillna("Cliente No Registrado")

print("Nulos restantes en Customer Name después de hacer la imputación:", ventas["Customer Name"].isnull().sum())

print(ventas["Sales"].head(10))
print(ventas["Sales"].dtype)

ventas["Sales"] = (
 ventas["Sales"]
 .astype(str)
 .str.replace("$", "", regex=False)
 .str.replace(",", "", regex=False)
 .str.strip()
)

print(ventas["Sales"].head(10))
print(ventas["Sales"].dtype)
ventas["Sales"] = pd.to_numeric(ventas["Sales"], errors="coerce")
print(ventas["Sales"].dtype)

# print("\nValores faltantes antes:")
# print(ventas.isnull().sum())

mediana_ventas = ventas["Sales"].median()
ventas["Sales"] = ventas["Sales"].fillna(mediana_ventas)

# print("\nValores faltantes después:")
# print(ventas.isnull().sum())

# Inspección previa de categorías únicas
print("Regiones únicas antes de limpiar:")
print(ventas["Region"].unique())

# Aplicación de encadenamiento de métodos de string (str)
ventas["Region"] = ventas["Region"].astype(str).str.strip().str.title()

print("Regiones únicas después de limpiar:")
print(ventas["Region"].unique())

# Agrupación y agregación de métricas
reporte_region = ventas.groupby(["Region","Category"]).agg(
 Ventas_Totales=("Sales", "sum"),
 Ventas_Promedio=("Sales", "mean"),
 Cantidad_Pedidos=("Order ID", "count")
).reset_index()

print("\nReporte Consolidado por Región:")
print(reporte_region)

# Obtener un KPI
print(ventas["Order Date"].dtype)
print(ventas["Ship Date"].dtype)

# Conversión a datetime
ventas["Order Date"] = pd.to_datetime(ventas["Order Date"])
ventas["Ship Date"] = pd.to_datetime(ventas["Ship Date"])

print(ventas["Order Date"].dtype)
print(ventas["Ship Date"].dtype)

ventas['Delivery Days'] = (ventas['Ship Date'] - ventas["Order Date"]).dt.days
print(ventas['Delivery Days'].head)

print("\nPromedio de entrega: ", ventas['Delivery Days'].mean())

# Exportar un DataFrame a un archivo
ventas.to_csv("datasets/superstore_clean.csv", index=False)

print(
"¡El dataset limpio ha sido exportado exitosamente a 'datasets/superstore_clean.csv'!\n"
)


