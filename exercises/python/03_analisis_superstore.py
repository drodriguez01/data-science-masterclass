# =====================================================
# Ejercicio 3
# Análisis de negocio - Superstore
# =====================================================

import pandas as pd


# Cargar datos

ventas = pd.read_csv(
    "datasets/superstore.csv",
    encoding="latin-1"
)


# -----------------------------------------
# 1. Ventas por categoría
# -----------------------------------------

ventas_categoria = (
    ventas
    .groupby("Category")["Sales"]
    .sum()
    .sort_values(ascending=False)
)


print("\nVentas por categoría")
print(ventas_categoria)


# -----------------------------------------
# 2. Ganancia por región
# -----------------------------------------

ganancia_region = (
    ventas
    .groupby("Region")["Profit"]
    .sum()
    .sort_values(ascending=False)
)


print("\nGanancia por región")
print(ganancia_region)


# -----------------------------------------
# 3. Top 10 productos vendidos
# -----------------------------------------

productos = (
    ventas
    .groupby("Product Name")["Sales"]
    .sum()
    .sort_values(ascending=False)
    .head(10)
)


print("\nTop 10 productos")
print(productos)


# -----------------------------------------
# 4. Cliente con mayor compra
# -----------------------------------------

clientes = (
    ventas
    .groupby("Customer Name")["Sales"]
    .sum()
    .sort_values(ascending=False)
    .head(10)
)


print("\nTop 10 clientes")
print(clientes)