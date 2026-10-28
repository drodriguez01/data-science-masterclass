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

#Detectemos los valores atípicos con el método IQR
# Calcular cuartiles
Q1 = ventas["Sales"].quantile(0.25)
Q3 = ventas["Sales"].quantile(0.75)

# Calcular IQR
IQR = Q3 - Q1

# Calcular límites
limite_inferior = Q1 - 1.5 * IQR
limite_superior = Q3 + 1.5 * IQR

# Identificar valores atípicos
outliers = ventas[
    (ventas["Sales"] < limite_inferior) |
    (ventas["Sales"] > limite_superior)
]

# Mostrar resultados
print("Q1:", round(Q1, 3))
print("Q3:", round(Q3, 3))
print("IQR:", round(IQR, 3))
print("Límite inferior:", round(limite_inferior, 3))
print("Límite superior:", round(limite_superior, 3))

print("\nCantidad de valores atípicos:", len(outliers))

print("\nLas 10 ventas más altas identificadas como atípicas:")
print(
    outliers[["Sales"]]
    .sort_values("Sales", ascending=False)
    .head(10)
)