# Instalación del Entorno

## Data Science Masterclass

Este documento describe los pasos necesarios para preparar el entorno de trabajo para ejecutar los ejercicios del repositorio **data-science-masterclass**.

---

# Requisitos

Antes de comenzar, asegúrese de tener instalados los siguientes programas:

- Git
- Python 3
- R
- Visual Studio Code

---

# 1. Instalar Git

Verificar si Git está instalado:

```bash
git --version
```

Ejemplo de salida:

```text
git version 2.34.1
```

Si Git no está instalado, descargarlo desde:

https://git-scm.com/downloads

---

# 2. Instalar Python

Verificar la instalación:

```bash
python3 --version
```

Ejemplo:

```text
Python 3.10.12
```

Si Python no está instalado, descargarlo desde:

https://www.python.org/downloads/

---

# 3. Instalar librerías de Python

Los ejercicios utilizan las siguientes librerías:

- pandas
- matplotlib
- seaborn

Instalarlas ejecutando:

```bash
pip3 install pandas matplotlib seaborn
```

Verificar la instalación:

```bash
python3 -c "import pandas, matplotlib, seaborn; print('Python listo para trabajar')"
```

Si aparece el mensaje:

```text
Python listo para trabajar
```

la instalación fue exitosa.

---

# 4. Instalar R

Verificar la instalación:

```bash
R --version
```

Ejemplo:

```text
R version 4.1.2
```

Si R no está instalado, descargarlo desde:

https://cran.r-project.org/

---

# 5. Instalar paquetes de R

Abrir la consola de R:

```bash
R
```

Instalar los paquetes necesarios:

```r
install.packages("readr")
install.packages("dplyr")
install.packages("ggplot2")
```

Verificar la instalación:

```r
library(readr)
library(dplyr)
library(ggplot2)
```

Si no aparece ningún error, los paquetes fueron instalados correctamente.

Salir de R:

```r
q()
```

---

# 6. Instalar Visual Studio Code

Descargar Visual Studio Code desde:

https://code.visualstudio.com/

Instalar las siguientes extensiones:

- Python
- R
- GitLens (opcional)
- GitHub Pull Requests and Issues (opcional)

Estas extensiones facilitan la edición y ejecución de los ejercicios.

---

# 7. Clonar el repositorio

Abrir una terminal y ejecutar:

```bash
git clone https://github.com/drodriguez01/data-science-masterclass.git
```

Ingresar al proyecto:

```bash
cd data-science-masterclass
```

---

# 8. Verificar la estructura del proyecto

Ejecutar:

```bash
tree
```

La estructura esperada es:

```text
.
├── datasets
│   └── superstore.csv
├── exercises
│   ├── python
│   └── r
├── docs
├── README.md
└── .gitignore
```

---

# 9. Ejecutar los ejercicios de Python

Ejemplo:

```bash
python3 exercises/python/01_exploracion_superstore.py
```

Si todo está correctamente instalado, se mostrará información del dataset Superstore.

---

# 10. Ejecutar los ejercicios de R

Ejemplo:

```bash
Rscript exercises/r/01_exploracion_superstore.R
```

Si la instalación fue correcta, se mostrará la exploración inicial del dataset.

---

# Verificación final

El entorno estará listo cuando:

- Git funcione correctamente.
- Python ejecute los ejercicios sin errores.
- R ejecute los ejercicios sin errores.
- Visual Studio Code permita abrir y ejecutar los archivos `.py` y `.R`.

En este punto, el repositorio estará preparado para desarrollar todos los ejercicios de la asignatura.
