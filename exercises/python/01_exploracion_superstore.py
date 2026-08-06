# =====================================================
# Ejercicio 1
# Exploración dataset Superstore
# =====================================================

import pandas as pd


# Cargar datos

ventas = pd.read_csv(
    "datasets/superstore.csv",
    encoding="latin-1"
)

# Primeras filas

print("\nPrimeros registros")
print(ventas.head())


# Dimensiones

print("\nCantidad de filas y columnas")
print(ventas.shape)


# Columnas

print("\nColumnas del dataset")
print(ventas.columns)


# Información general

print("\nInformación del dataset")
ventas.info()


# Estadísticas numéricas

print("\nEstadísticas")
print(ventas.describe())


# Categorías existentes

print("\nCategorías")
print(ventas["Category"].unique())


# Regiones existentes

print("\nRegiones")
print(ventas["Region"].unique())