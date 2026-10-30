import pandas as pd 
import matplotlib.pyplot as plt 
import seaborn as sns 
import matplotlib.ticker as ticker 

# Estilo global profesional 
sns.set_theme(style="whitegrid", palette="muted") 
plt.rcParams['font.family'] = 'sans-serif' 

# 1. Carga con codificación correcta 
ventas = pd.read_csv("datasets/superstore.csv", encoding="latin-1") 

# 2. Parseo de fechas (el CSV trae el formato mes/día/año) 
ventas["order_date"] = pd.to_datetime(ventas["order_date"], format="%m/%d/%Y") 

# Inspección previa 
print("Columnas:", ventas.columns.tolist()) 
print("Dimensiones:", ventas.shape) 
print(ventas[["sales", "profit", "discount"]].describe())
print(ventas[['sales', 'profit']].dtypes)

# ===================================================== 
# EJERCICIO 1 Ventas por categoría 
# ===================================================== 
ventas_cat = ( 
 ventas.groupby("category")["sales"] 
 .sum() 
 .reset_index() 
 .sort_values(by="sales", ascending=False) 
) 
# # 1. Crear el gráfico base 
# fig, ax = plt.subplots(figsize=(9, 4)) 
# sns.barplot( 
#  data=ventas_cat, 
#  x="sales", 
#  y="category", 
#  hue="category", 
#  legend=False, 
#  palette="Blues_r", 
#  ax=ax 
# ) 
# # 2. Escribir el valor al final de cada barra 
# for barra in ax.patches: 
#  ancho = barra.get_width() 
#  ax.text( 
#  ancho + 500, # posición X: un poco a la derecha del final 
#  barra.get_y() + barra.get_height() / 2, # posición Y: centro vertical de la barra  
# f"${ancho/1000:,.1f}K", # texto formateado en miles de dólares  
# va='center', 
#  fontweight='bold' 
#  ) 
# # 3. Ocultar los números del eje X (ya están escritos junto a cada barra)
# ax.set_xticks([]) 
# # 4. Títulos y limpieza visual 
# ax.set_title("Tecnología es la categoría con mayores ingresos totales",  fontsize=12, fontweight="bold", pad=15) 
# ax.set_xlabel("") 
# ax.set_ylabel("") 
# sns.despine(bottom=True, left=True) 
# plt.tight_layout() 
# plt.show()


# Gráfico circular
# plt.figure(figsize=(7, 7))

# plt.pie(
#     ventas_cat["sales"],
#     labels=ventas_cat["category"],
#     autopct="%1.1f%%",
#     startangle=90
# )

# plt.title("Distribución de ventas por categoría")
# plt.tight_layout()
# plt.show()

# ===================================================== 
# EJERCICIO 2 Subcategorías top 8 
# ===================================================== 
top_subcat = ( 
 ventas.groupby("sub_category")["sales"] 
 .sum() 
 .reset_index() 
 .sort_values(by="sales", ascending=False) 
 .head(8) 
) 

# Calcular el porcentaje del Top 8 
total_top8 = top_subcat["sales"].sum() 
total_ventas = ventas["sales"].sum() 
porcentaje = (total_top8 / total_ventas) * 100 

# plt.figure(figsize=(9, 4)) 
# sns.barplot(
# data=top_subcat, 
# x="sales",
# y="sub_category",
# palette="viridis")
# plt.title("Top 8 subcategorías más vendidas", fontweight='bold') 
# plt.xlabel("Ventas (USD)") 
# plt.ylabel("") 
# plt.figtext( 
#  0.5, 0.95, 
#  f"El Top 8 representa el {porcentaje:.2f}% de las ventas totales",  ha="center", 
#  fontsize=10, 
#  fontweight="bold" 
# ) 
# plt.tight_layout(rect=[0, 0.05, 1, 0.95])

# # plt.tight_layout() 
# plt.show()

# ===================================================== 
# EJERCICIO 3 Agrupar las ventas por mes
# ===================================================== 
analisis_mensual = (
ventas
.assign(mes=ventas["order_date"].dt.month)
.groupby("mes", as_index=False)
.agg(ventas=("sales", "sum"))
)
# Convertir el número de mes a su abreviatura (Jan, Feb, ...)
analisis_mensual["mes"] = pd.to_datetime(
analisis_mensual["mes"],
format="%m"
).dt.strftime("%b")

analisis_mensual["ventas"] = analisis_mensual["ventas"].round()

# # Configurar el estilo
# sns.set_theme(style="whitegrid")

# # Crear el gráfico de barras
# plt.bar(
#     analisis_mensual["mes"], 
#     analisis_mensual["ventas"],
#     color="steelblue")

# # Personalizar el gráfico
# plt.title("Ventas mensuales")
# plt.xlabel("Mes")
# plt.ylabel("Ventas totales (USD)")
# plt.tight_layout()
# plt.show()

# ===================================================== 
# EJERCICIO 4 Ganancia y margen por región 
# ===================================================== 
region_metrics = ( 
 ventas.groupby("region") 
 .agg(
ventas_totales=('sales', 'sum'), 
ganancia_total=('profit', 'sum'))  
.reset_index() 
 .sort_values(by="ganancia_total", ascending=False) 
) 
# Cálculo del margen porcentual 
region_metrics['margen_pct'] = ( 
 region_metrics['ganancia_total'] / region_metrics['ventas_totales'] ) * 100 

# fig, axes = plt.subplots(1, 2, figsize=(12, 4.5)) 
# # Ganancia por región 
# grafico1 = sns.barplot( 
#  data=region_metrics, 
#  x="region", 
#  y="ganancia_total", 
#  ax=axes[0], 
#  color="green" 
# ) 
# axes[0].bar_label(grafico1.containers[0], fmt="$%.0f") 
# axes[0].set_title("Ganancia por región") 
# axes[0].set_xlabel("Región") 
# axes[0].set_ylabel("Ganancia (USD)") 
# # Margen por región 
# grafico2 = sns.barplot( 
#  data=region_metrics, 
#  x="region", 
#  y="margen_pct", 
#  ax=axes[1], 
#  color="lightgreen" 
# ) 
# axes[1].bar_label(grafico2.containers[0], fmt="%.1f%%") 
# axes[1].set_title("Margen de ganancia por región") 
# axes[1].set_xlabel("Región") 
# axes[1].set_ylabel("Margen (%)") 
# plt.tight_layout() 
# plt.show()

# ===================================================== 
# EJERCICIO 5 Scatter plot ventas vs. ganancias
# ===================================================== 
# Gráfico de dispersión 
# plt.figure(figsize=(9, 5)) 
# sns.scatterplot( 
#  data=ventas, 
#  x="sales", 
#  y="profit", 
#  hue="category", 
#  alpha=0.6, 
#  s=60 
# ) 
# # Línea de umbral de pérdidas 
# plt.axhline(0, color='red', linestyle='--', linewidth=1.2, 
#  label='Punto de equilibrio (Profit = 0)') 
# plt.title("Análisis de rentabilidad por transacción", fontsize=12, fontweight='bold') 
# plt.xlabel("Ventas por pedido (USD)") 
# plt.ylabel("Ganancia / pérdida por pedido (USD)") 
# plt.legend(title="Categoría") 
# plt.tight_layout() 
# plt.show()

# ===================================================== 
# EJERCICIO 6 Impacto de los descuentos en la ganancia
# ===================================================== 
descuento_df = ventas.groupby("discount")["profit"].mean().reset_index() 

# plt.figure(figsize=(8, 4)) 
# sns.lineplot( 
#  data=descuento_df, 
#  x="discount", 
#  y="profit", 
#  marker="o", 
#  color="crimson", 
#  linewidth=2 
# ) 
# plt.axhline(0, color='black', linestyle=':', alpha=0.7) 
# plt.title("Impacto del descuento en la ganancia promedio", fontweight='bold') 
# plt.xlabel("Porcentaje de descuento aplicado") 
# plt.ylabel("Ganancia promedio (USD)") 
# plt.gca().xaxis.set_major_formatter(ticker.PercentFormatter(1.0)) 
# plt.tight_layout() 
# plt.show()


# ===================================================== 
# INTEGRACIÓN FINAL: Dashboard gerencial (subplots) 
# ===================================================== 
fig, axes = plt.subplots(2, 2, figsize=(14, 8)) 
fig.suptitle("Dashboard resumen de rendimiento - Superstore", fontsize=16, fontweight='bold') 
# Subplot 1: Ventas por categoría 
sns.barplot(
    data=ventas_cat,
    x="sales", 
    y="category", 
    palette="Blues_r", ax=axes[0, 0]
) 
axes[0, 0].set_title("Ventas totales por categoría") 
axes[0, 0].xaxis.set_major_formatter( 
 ticker.FuncFormatter(lambda x, pos: f'${x*1e-3:,.0f}K') 
) 
# Subplot 2: Ganancia por región 
sns.barplot(
    data=region_metrics, 
    x="region", 
    y="ganancia_total",
    palette="Greens_r", 
    ax=axes[0, 1]
) 
axes[0, 1].set_title("Ganancia neta por región") 
axes[0, 1].yaxis.set_major_formatter( 
 ticker.FuncFormatter(lambda y, pos: f'${y*1e-3:,.0f}K') 
) 
# Subplot 3: Scatter ventas vs. ganancia 
sns.scatterplot(
    data=ventas, 
    x="sales", 
    y="profit", 
    hue="category", 
    alpha=0.5, 
    ax=axes[1,  0]
) 
axes[1, 0].axhline(0, color='red', linestyle='--') 
axes[1, 0].set_title("Relación ventas vs. ganancia") 

# Subplot 4: Descuento vs. ganancia 
sns.lineplot(
    data=descuento_df, 
    x="discount", 
    y="profit", 
    marker="o", 
    color="crimson", 
    ax=axes[1, 1]
) 
axes[1, 1].axhline(0, color='black', linestyle=':') 
axes[1, 1].set_title("Impacto de descuentos en utilidad") 
axes[1, 1].xaxis.set_major_formatter(ticker.PercentFormatter(1.0)) 
plt.tight_layout() 
plt.show()

