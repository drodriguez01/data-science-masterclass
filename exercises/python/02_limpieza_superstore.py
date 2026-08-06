# =====================================================
# Ejercicio 2
# Limpieza y preparación de datos - Superstore
# =====================================================

import pandas as pd


# 1. Cargar dataset

ventas = pd.read_csv(
    "datasets/superstore.csv",
    encoding="latin-1"
)


# 2. Revisar valores faltantes

print("\nValores faltantes:")
print(ventas.isnull().sum())


# 3. Revisar duplicados

print("\nRegistros duplicados:")
print(ventas.duplicated().sum())


# 4. Convertir fechas

ventas["Order Date"] = pd.to_datetime(
    ventas["Order Date"]
)

ventas["Ship Date"] = pd.to_datetime(
    ventas["Ship Date"]
)


print("\nTipos de datos:")
print(
    ventas[
        ["Order Date", "Ship Date"]
    ].dtypes
)


# 5. Crear nueva variable:
# días de entrega

ventas["Delivery Days"] = (
    ventas["Ship Date"]
    -
    ventas["Order Date"]
).dt.days


print("\nEjemplo de días de entrega:")

print(
    ventas[
        [
            "Order Date",
            "Ship Date",
            "Delivery Days"
        ]
    ].head()
)


# 6. Promedio de entrega

print("\nPromedio días de entrega:")

print(
    ventas["Delivery Days"].mean()
)