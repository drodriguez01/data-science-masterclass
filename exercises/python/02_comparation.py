
import pandas as pd

df_sucio = pd.read_csv("datasets/superstore_dirty.csv", encoding="latin-1")
df_limpio = pd.read_csv("datasets/superstore_clean.csv")

print("=" * 50)
print(" COMPARATIVA DE DATASETS ")
print("=" * 50)

# A. Cantidad de filas
print(f" Filas en Dataset Sucio: {len(df_sucio):,}")
print(f" Filas en Dataset Limpio: {len(df_limpio):,}")
print(
f" -> Filas duplicadas eliminadas: {len(df_sucio) - len(df_limpio):,}\n"
)

# B. Valores Nulos
print(" Total de Valores Nulos (NaN):")

print(f" -> En dataset sucio: {df_sucio.isnull().sum().sum()}")
print(f" -> En dataset limpio: {df_limpio.isnull().sum().sum()}\n")

# C. Formato / Tipos de Datos en 'Sales'
print(" Tipo de dato en la columna 'Sales':")
print(f" -> En dataset sucio: {df_sucio['Sales'].dtype} (Texto/Objeto)")
print(f" -> En dataset limpio: {df_limpio['Sales'].dtype} (Numérico Flotante)\n")

# D. Categorías únicas en 'Region' (Demuestra limpieza de texto)
print(" Regiones distintas detectadas:")
print(f" -> En dataset sucio: {df_sucio['Region'].nunique()} variaciones")
print(f" -> En dataset limpio: {df_limpio['Region'].nunique()} regiones estandarizadas")
print("=" * 50)