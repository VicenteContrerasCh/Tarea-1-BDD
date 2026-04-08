#Importa la librería psycopg2 para conectarse a la base de datos PostgreSQL
import psycopg2
#Intenta establecer una conexión con la base de datos utilizando las credenciales proporcionadas
try:
    conn = psycopg2.connect(
        dbname="Tarea_1_BDD",
        user="postgres",
        password="glade90.",
        host="localhost",
        port="5432"
    )
    print("¡Conexión exitosa a la base de datos!")
except Exception as e:
    print(f"Error detallado al conectar a la base de datos:\n{e}")
#Intenta ejecutar el esquema SQL para crear las tablas necesarias en la base de datos
cursor = conn.cursor()
try:
    with open('squema_gemini.sql', 'r') as f:
        schema = f.read()
    cursor.execute(schema)
    cursor.commit()
    print("¡Esquema ejecutado exitosamente!")
except Exception as e:
    print(f"Error al ejecutar el esquema:\n{e}")
#Intenta llenar los datos en la base de datos utilizando el archivo data.sql
try:
    with open('data.sql', 'r') as f:
        data = f.read()
    cursor.execute(data)
    cursor.commit()
    print("¡Esquema ejecutado exitosamente!")
except Exception as e:
    print(f"Error al iyectar los datos:\n{e}")


#Intenta ejecutar una consulta SQL para seleccionar todos los registros de la tabla "Jugadores"
query = "SELECT * FROM Jugadores;"
curr = conn.cursor()
try:
    curr.execute(query)
    rows = curr.fetchall()
    for row in rows:
        print(row)
except psycopg2.Error as e:
    print("Error al ejecutar la consulta:", e.pgcode)
#Intenta que un equipo se inscriba a un torneo y maneja el error si el torneo ya tiene el cupo lleno (por terminar)
