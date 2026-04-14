# Tarea 1 BDD - Sistema de Gestión de Esports

## 👥 Integrantes
* **Nombre:** Benjamín Gaspar Ulloa Castro | **Número de Alumno:** 23642459
* **Nombre:** Benjamín Andrés González Recart | **Número de Alumno:** 22638059
* **Nombre:** Vicente Ignacio Contreras Chávez | **Número de Alumno:** 22640991

## 🚀 Levantamiento de la Aplicación
Tras descomprimir el archivo, abrir una terminal en la carpeta raíz del proyecto y ejecutar los siguientes 5 comandos para levantar el sistema:

1. Crear el entorno virtual:
python -m venv .venv
# Sistema de Gestión de Esports - Tarea 1 BDD

## Descripción del Proyecto
Este proyecto implementa un sistema backend completo para la gestión de un ecosistema competitivo de Esports. Utiliza **PostgreSQL** como motor de base de datos relacional para asegurar la integridad de los datos (equipos, jugadores, torneos, auspicios) y una aplicación en **Python (Flask)** que interactúa con la base de datos para realizar consultas y procesar la información.

## Tecnologías Utilizadas
* **Base de Datos:** PostgreSQL
* **Backend:** Python 3.x, Flask
* **Librerías Clave:** * `psycopg2` (Adaptador de base de datos para Python)
  * `python-dotenv` (Gestión de variables de entorno)

## Estructura de la Base de Datos
El esquema relacional consta de las siguientes entidades principales:
* `equipos`: Organizaciones de Esports.
* `jugadores`: Competidores vinculados a un equipo.
* `torneos`: Catálogo de eventos competitivos.
* `inscripciones`: Relación N:M entre equipos y torneos.
* `auspicios`: Patrocinios y financiamiento por equipo.
* `estadisticas_individuales`: Rendimiento histórico por jugador.

## 🚀 Instrucciones de Instalación y Ejecución

Sigue estos pasos para desplegar el proyecto en tu entorno local.

### 1. Configuración de la Base de Datos
1. Abre tu gestor de PostgreSQL (ej. pgAdmin o VS Code) y crea una base de datos llamada `TareaBDD1`.
2. Ejecuta los scripts SQL para montar la estructura y poblar los datos:
   ```bash
   # (Asegúrate de estar en el directorio correcto o usa la interfaz de tu editor)
   psql -U postgres -d TareaBDD1 -f esquema.sql
   psql -U postgres -d TareaBDD1 -f data.sql
## 📁 Estructura de Archivos y Directorios

El proyecto está organizado de la siguiente manera para separar la lógica del servidor, la interfaz de usuario y los scripts de base de datos:

```text
Tarea-1-BDD/
│
├── app/                        # Módulo principal de la aplicación web
│   ├── static/
│   │   └── styles.css          # Hoja de estilos para la interfaz gráfica
│   ├── templates/              # Plantillas HTML renderizadas por Flask
│   │   ├── base.html           # Plantilla maestra (heredada por las demás)
│   │   ├── busqueda.html       # Vista para consultas y filtros
│   │   ├── detalle_torneo.html # Vista de información específica de un torneo
│   │   ├── estadisticas.html   # Vista de métricas de los jugadores
│   │   ├── inicio.html         # Página principal (Home)
│   │   ├── inscripciones.html  # Vista de gestión de inscripciones
│   │   ├── sponsors.html       # Vista de auspicios y patrocinios
│   │   └── torneos.html        # Vista general de competiciones
│   ├── .env                    # Variables de entorno locales (NO rastreado por Git)
│   ├── app.py                  # Servidor Flask y definición de rutas (endpoints)
│   └── conexion.py             # Lógica de conexión a PostgreSQL (psycopg2)
│
├── .gitignore                  # Reglas de exclusión para el control de versiones
├── baseDatos.py                # Funciones auxiliares para manipulación de la BD
├── data.sql                    # Script DML con sentencias INSERT para poblar datos
├── reiniciador.sql             # Script para limpiar tablas (TRUNCATE/DROP)
├── squema_gemini.sql           # Script DDL con sentencias CREATE TABLE (Esquema)
├── README.md                   # Documentación actual
└── Tarea1.pdf                  # Enunciado y rúbrica de la evaluación original