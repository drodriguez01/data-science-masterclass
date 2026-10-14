import pandas as pd


# 1. Cargar dataset

ventas = pd.read_csv(
    "datasets/superstore_dirty.csv",
    encoding="latin-1"
)

print("\nValores faltantes:") 
print(ventas.isnull().sum()) 

print("\nRegistros duplicados:") 
print(ventas.duplicated().sum()) 

# 1. Eliminar duplicados manteniendo la primera ocurrencia 
ventas = ventas.drop_duplicates() 

print("\nRegistros duplicados:") 
print(ventas.duplicated().sum()) 

print("Nulos restantes antes en Customer Name:", ventas["Customer Name"].isnull().sum())
# 2. Imputar valores faltantes en 'Customer Name' 
ventas["Customer Name"] = ventas["Customer Name"].fillna("Cliente No Registrado") 
print("Nulos restantes después en Customer Name:", ventas["Customer Name"].isnull().sum())

# Inspección previa de categorías únicas 
print("Regiones únicas antes de limpiar:") 
print(ventas["Region"].unique()) 

# Encadenamiento de métodos de texto (str) 
ventas["Region"] = ventas["Region"].astype(str).str.strip().str.title() 

# Inspección previa de categorías únicas 
print("Regiones únicas después de limpiar:") 
print(ventas["Region"].unique()) 

# Mostrar primero el estado actual de la columna 
print(ventas["Sales"].head(10)) 
print(ventas["Sales"].dtype) 

# 1. Eliminar símbolos de moneda y comas 
ventas["Sales"] = ( 
 ventas["Sales"] 
 .astype(str) 
 .str.replace("$", "", regex=False) 
 .str.replace(",", "", regex=False) 
 .str.strip() 
)

print(ventas["Sales"].head(10)) 

# 2. Convertir a numérico (fuerza los valores no convertibles a NaN) 
ventas["Sales"] = pd.to_numeric(ventas["Sales"], errors="coerce") 

# 3. Imputar nulos con la mediana (más robusta que la media ante outliers) 
mediana_ventas = ventas["Sales"].median() 

ventas["Sales"] = ventas["Sales"].fillna(mediana_ventas) 
print("Resumen estadístico de Sales:") 
print(ventas["Sales"].describe()) 

print("\nValores faltantes:") 
print(ventas.isnull().sum()) 

# Agrupación y agregación de métricas 
# Formato: nombre_nuevo = (columna_original, operación) 
reporte_region = ventas.groupby("Region").agg( 
 Ventas_Totales=("Sales", "sum"), 
 Ventas_Promedio=("Sales", "mean"), 
 Cantidad_Pedidos=("Order ID", "count") 
).reset_index() 

print("\nReporte Consolidado por Región:") 
print(reporte_region)

# Guardamos el DataFrame limpio en un nuevo archivo CSV 
# index=False evita que pandas cree una columna extra con el índice numérico 
ventas.to_csv("datasets/superstore_clean.csv", index=False) 

print("¡El dataset limpio ha sido exportado exitosamente a  'datasets/superstore_clean.csv'!\n") 










