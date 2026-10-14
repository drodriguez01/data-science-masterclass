# =====================================================
# SCRIPT PARA GENERAR DATASET SUCIO (superstore_dirty.csv)
# =====================================================
import pandas as pd
import numpy as np
# Cargar el dataset original
df = pd.read_csv("datasets/superstore.csv", encoding="latin-1")
df_dirty = df.copy()
np.random.seed(42) # Garantiza reproducibilidad
# 1. Introducir valores nulos (NaN)
mask_sales = np.random.rand(len(df_dirty)) < 0.05
df_dirty.loc[mask_sales, "Sales"] = np.nan
mask_customer = np.random.rand(len(df_dirty)) < 0.03
df_dirty.loc[mask_customer, "Customer Name"] = np.nan
# 2. Introducir filas duplicadas
duplicados = df_dirty.sample(frac=0.04)
df_dirty = pd.concat([df_dirty, duplicados], ignore_index=True)
# 3. Espacios extra e inconsistencias de mayúsculas/minúsculas en Region
df_dirty["Region"] = df_dirty["Region"].apply(
lambda x: f" {x.lower()} " if np.random.rand() < 0.2
else (x.upper() if np.random.rand() < 0.1 else x)
)
# 4. Convertir la columna Sales a texto "sucio" con '$' y ','
df_dirty["Sales"] = df_dirty["Sales"].apply(
lambda x: f"$ {x:,.2f}" if pd.notnull(x) and np.random.rand() < 0.3 else x
)
# Guardar el nuevo dataset
df_dirty.to_csv("datasets/superstore_dirty.csv", index=False)
print("¡Archivo 'superstore_dirty.csv' generado exitosamente!")