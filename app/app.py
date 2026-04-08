from flask import Flask
from baseDatos import get_connection

app = Flask(__name__)

@app.route("/")
def inicio():
    conn = get_connection()

    if conn is None:
        return "Error al conectar a la base de datos"

    try:
        cur = conn.cursor()
        cur.execute("SELECT id, nombre, titulo_videojuego FROM Torneos ORDER BY id;")
        torneos = cur.fetchall()
        cur.close()
        conn.close()

        html = "<h1>Torneos</h1><ul>"
        for torneo in torneos:
            html += f"<li>{torneo[1]} - {torneo[2]}</li>"
        html += "</ul>"
        return html

    except Exception as e:
        return f"Error al cargar torneos: {e}"

if __name__ == "__main__":
    app.run(debug=True)