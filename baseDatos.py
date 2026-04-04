#Importa la librería psycopg2 para conectarse a la base de datos PostgreSQL
import psycopg2
#Intenta establecer una conexión con la base de datos utilizando las credenciales proporcionadas
try:
    conn = psycopg2.connect(
        dbname="tareaBDD1",
        user="postgres",
        password="1234",
        host="localhost",
        port="5432"
    )
except:
    print("Error al conectar a la base de datos")
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
