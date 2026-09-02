
import pandas as pd


# Cargar datos

ventas = pd.read_csv(
    "datasets/superstore.csv",
    encoding="latin-1"
)

# ventas.columns = ventas.columns.str.replace(" ","_")

ventas_categoria = (
    ventas
    .groupby("Category")["Sales"]
    .sum()
    .sort_values(ascending=False)
)
print(ventas_categoria)

conteo_ordenes = ventas["Category"].value_counts()

print("\n Conteo de transacciones por categoría:")
print(conteo_ordenes)


ganancia_region = (
    ventas
    .groupby("Region")["Profit"]
    .sum()
    .sort_values(ascending=False)
)


print("\nGanancia por región")
print(ganancia_region)

cuadro_categoria = (
    ventas
    .groupby("Category")
    .agg(
        Ventas_Totales=("Sales", "sum"),
        Ganancia_Total=("Profit", "sum"),
        Unidades_Vendidas=("Quantity", "sum"),
        Ticket_Promedio=("Sales", "mean")
    )
    .round(2)
)

cuadro_categoria['Margen_porcentaje'] = (
    (cuadro_categoria['Ganancia_Total'] / cuadro_categoria['Ventas_Totales']) * 100
).round(2)

cuadro_categoria = cuadro_categoria.sort_values("Margen_porcentaje",ascending= False)

print("\n--- CUADRO DE MANDO INTEGRAL POR CATEGORÍA ---")
print(cuadro_categoria)

analisis_descuentos = (
    ventas
    .groupby("Region")
    .agg(
        Ganancia_Promedio=("Profit", "mean"),
        Descuento_Promedio=("Discount", "mean")
    )
    .sort_values("Descuento_Promedio", ascending=False)
    .round(2)
)
print("\nAnálisis de Descuentos por Región")
print(analisis_descuentos)

matriz_region_categoria = (
    ventas
    .groupby(["Region","Category"])
    .agg(
        Ventas =("Sales","sum"),
        Ganancia =("Profit","sum")
    )
    .reset_index()
    .round(2)
)

print("\n--- ANÁLISIS CRUZADO: REGIÓN Y CATEGORÍA ---")
print(matriz_region_categoria)

subcat_perdidas = (
    ventas
    .groupby("Sub-Category")['Profit']
    .sum()
    .sort_values(ascending= True)
    .head(5)
)
print("\nTop 5 Sub-Categorías con Pérdidas:")
print(subcat_perdidas)

print(ventas.dtypes)
analisis_pareto = (
    ventas
    .groupby("Customer Name")
    .agg(
        Ventas_Totales=("Sales", "sum"),
        Total_Ordenes=("Order ID", "nunique")
    )
    .sort_values("Ventas_Totales", ascending=False)
)

# Cálculo de la suma global de ventas
venta_global = ventas["Sales"].sum()

# Porcentaje de aporte individual
analisis_pareto["Acumulado_porcentual"] = ((analisis_pareto["Ventas_Totales"] / venta_global) * 100).round(2)

print("\n--- ANÁLISIS DE PARETO DE CLIENTES (TOP 10) ---")
print(analisis_pareto.head(10))

clientes_top_10 = analisis_pareto[analisis_pareto["Acumulado_porcentual"] <= 10]

print("\nNúmero de clientes que generan el primer 10% de la venta total:")
print(len(clientes_top_10))



# print(f"\nNúmero de clientes que generan el primer 10% de la venta total: {len(clientes_top_10)}")





