import pandas as pd

# Cargar el archivo
ventas = pd.read_csv("datasets/superstore_caso_estudio.csv")

print(ventas["Sales"].dtype) 

# 1. Eliminar símbolos de moneda y comas 
ventas["Sales"] = ( 
 ventas["Sales"] 
 .astype(str) 
 .str.replace("$", "", regex=False) 
 .str.replace(",", "", regex=False) 
 .str.strip() 
)

# 2. Convertir a numérico (fuerza los valores no convertibles a NaN) 
ventas["Sales"] = pd.to_numeric(ventas["Sales"], errors="coerce") 

# 3. Imputar nulos con la mediana (más robusta que la media ante outliers) 
mediana_ventas = ventas["Sales"].median() 

ventas["Sales"] = ventas["Sales"].fillna(mediana_ventas) 

print("Mediana de ventas: " , mediana_ventas)
print("\n- Resumen estadístico de Sales:") 
print(ventas["Sales"].describe()) 
print("Valores nulos restantes:", ventas["Sales"].isna().sum())

# Calcular la media y la desviación estándar
media = ventas["Sales"].mean()
desviacion = ventas["Sales"].std()

# Calcular el Z-Score de cada venta
ventas["Z_Score"] = (ventas["Sales"] - media) / desviacion

# Identificar los posibles valores atípicos
outliers_z = ventas[
    (ventas["Z_Score"] > 3) |
    (ventas["Z_Score"] < -3)
]

# Mostrar los resultados
print("\n- Media de las ventas:", round(media, 3))
print("\n- Desviación estándar:", round(desviacion, 3))

print("\nLímite inferior:", round(media - 3 * desviacion, 3))
print("Límite superior:", round(media + 3 * desviacion, 3))

print("\nCantidad de valores atípicos:", len(outliers_z))

print("\nLas 10 ventas más altas identificadas como atípicas:")
print(
    outliers_z[["Sales", "Z_Score"]]
    .sort_values("Sales", ascending=False)
    .head(10)
)