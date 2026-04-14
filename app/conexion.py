#Importa la librería psycopg2 para conectarse a la base de datos PostgreSQL
from dotenv import load_dotenv
import os
import psycopg2
from pathlib import Path
import traceback

#Intenta establecer una conexión con la base de datos utilizando las credenciales proporcionadas

env_path = Path(__file__).resolve().parent.parent / ".env"
load_dotenv(dotenv_path=env_path, encoding="utf-8")

def get_connection():
    try:
        conn = psycopg2.connect(
            dbname=os.getenv("DB_NAME"),
            user=os.getenv("DB_USER"),
            password=os.getenv("DB_PASSWORD"),
            host=os.getenv("DB_HOST"),
            port=os.getenv("DB_PORT")
        )
        print("Conexión exitosa a la base de datos")
        return conn

    except Exception as e:
        print("TIPO DE ERROR:", type(e))
        print("REPR DEL ERROR:", repr(e))
        traceback.print_exc()
        return None
