# =====================================================
# Ejercicio 4
# Visualización de datos - Superstore
# =====================================================

import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns


# Cargar datos

ventas = pd.read_csv(
    "datasets/superstore.csv",
    encoding="latin-1"
)


# =====================================================
# 1. Ventas por categoría
# =====================================================

ventas_categoria = (
    ventas
    .groupby("Category")["Sales"]
    .sum()
    .reset_index()
)


plt.figure(figsize=(8,5))

sns.barplot(
    data=ventas_categoria,
    x="Category",
    y="Sales"
)

plt.title(
    "Ventas totales por categoría"
)

plt.xlabel(
    "Categoría"
)

plt.ylabel(
    "Ventas"
)

plt.xticks(rotation=45)

plt.tight_layout()

plt.show()


# =====================================================
# 2. Ganancia por región
# =====================================================

ganancia_region = (
    ventas
    .groupby("Region")["Profit"]
    .sum()
    .reset_index()
)


plt.figure(figsize=(8,5))

sns.barplot(
    data=ganancia_region,
    x="Region",
    y="Profit"
)

plt.title(
    "Ganancia por región"
)

plt.xlabel(
    "Región"
)

plt.ylabel(
    "Ganancia"
)

plt.tight_layout()

plt.show()


# =====================================================
# 3. Relación ventas - ganancias
# =====================================================

plt.figure(figsize=(8,5))

sns.scatterplot(
    data=ventas,
    x="Sales",
    y="Profit",
    hue="Category"
)


plt.title(
    "Relación entre ventas y ganancias"
)

plt.xlabel(
    "Ventas"
)

plt.ylabel(
    "Ganancia"
)

plt.tight_layout()

plt.show()