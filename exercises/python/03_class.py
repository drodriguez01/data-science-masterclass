import pandas as pd 
import numpy as np 

# Carga del dataset con codificación de texto latina 
ventas = pd.read_csv("datasets/superstore.csv", encoding="latin-1") 

print(ventas.columns)

# Estandarización de nombres de columnas
# ventas.columns = ventas.columns.str.replace(" ", "_")
# ventas.columns = ventas.columns.str.lower()
ventas.columns = ventas.columns.str.lower().str.replace(" ", "_")

print(ventas.columns)

# ----------------------------------------- 
# 1. Ventas por categoría 
# ----------------------------------------- 
ventas_categoria = ( 
 ventas 
 .groupby("category")["sales"] 
 .sum() 
 .sort_values(ascending=False) 
) 
print("\nVentas por categoría:") 
print(ventas_categoria)


conteo_ordenes = ventas["category"].value_counts() 
print("\nConteo transacciones por categoría:") 
print(conteo_ordenes)

# ----------------------------------------- 
# 2. Ganancia por región 
# ----------------------------------------- 
ganancia_region = ( 
 ventas 
 .groupby("region")["profit"] 
 .sum() 
 .sort_values(ascending=False) 
) 
print("\nGanancia por región:") 
print(ganancia_region) 

cuadro_categoria = ( 
 ventas 
 .groupby("category") 
 .agg( 
 ventas_totales=("sales", "sum"), 
 ganancia_total=("profit", "sum"), 
 unidades_vendidas=("quantity", "sum"), 
 ticket_promedio=("sales", "mean") 
 ) 
 .round(2) 
) 

# Creación de variable calculada: Margen Porcentual (%) 
cuadro_categoria["margen_%"] = ( 
 (
     cuadro_categoria["ganancia_total"] / cuadro_categoria["ventas_totales"]
 ) * 100 ).round(2) 

cuadro_categoria = cuadro_categoria.sort_values("margen_%", ascending=False) 

print("\n--- CUADRO DE MANDO INTEGRAL POR CATEGORÍA ---") 
print(cuadro_categoria)

analisis_descuentos = ( 
 ventas 
 .groupby("region") 
 .agg( 
 ganancia_promedio=("profit", "mean"), 
 descuento_promedio=("discount", "mean") 
 ) 
 .sort_values("descuento_promedio", ascending=False) 
 .round(2)
) 

print("\nAnálisis de descuentos por región:") 
print(analisis_descuentos)

top_productos = ( 
 ventas 
 .groupby("product_name")["sales"] 
 .sum() 
 .sort_values(ascending=False) 
 .head(5) 
) 

print("\nTop 10 productos:") 
print(top_productos) 

top_clientes = ( 
 ventas 
 .groupby("customer_name")["sales"] 
 .sum() 
 .sort_values(ascending=False) 
 .head(5) 
) 
print("\nTop 10 clientes:") 
print(top_clientes) 

matriz_region_categoria = ( 
 ventas 
 .groupby(["region", "category"]) 
 .agg( 
 ventas=("sales", "sum"), 
 ganancia=("profit", "sum") 
 ) 
 .reset_index() 
 .sort_values("ganancia", ascending=True) 
) 

print("\n--- ANÁLISIS CRUZADO: REGIÓN Y CATEGORÍA ---") 
print(matriz_region_categoria)


subcat_ganancia = ( 
 ventas 
 .groupby("sub-category")["profit"] 
 .sum() 
 .sort_values(ascending=True) 
 .head(5) 
) 

print("\n--- Subcategorías con menores ganancias---") 
print(subcat_ganancia)

analisis_pareto = ( 
 ventas 
 .groupby("customer_name") 
 .agg( 
 ventas_totales=("sales", "sum"), 
 total_ordenes=("order_id", "nunique") 
 ) 
 .sort_values("ventas_totales", ascending=False) 
) 

# Cálculo de la suma global de ventas 
venta_global = ventas["sales"].sum() 

# Porcentaje de aporte individual 
analisis_pareto["aporte_porcentual"] = ( 
 (analisis_pareto["ventas_totales"] / venta_global) * 100 
).round(2) 

# Porcentaje acumulado (suma acumulativa) 
analisis_pareto["acumulado_porcentual"] = analisis_pareto["aporte_porcentual"].cumsum().round(2) 

print("\n--- ANÁLISIS DE PARETO DE CLIENTES (TOP 10) ---") 
print(analisis_pareto.head(10))

clientes_top_10 = analisis_pareto[analisis_pareto["acumulado_porcentual"] <= 10]

print("\n--- CLIENTES QUE REPRESENTAN EL 10% DE LAS VENTAS ---") 
print(clientes_top_10)












