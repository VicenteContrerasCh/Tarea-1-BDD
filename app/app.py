from flask import Flask, render_template, request, redirect, url_for, flash
from psycopg2.extras import RealDictCursor
from baseDatos import get_connection

app = Flask(__name__)
app.secret_key = "tarea1-secreto"


def fetch_all(query, params=None):
    conn = get_connection()
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute(query, params or ())
            return cur.fetchall()
    finally:
        conn.close()


def fetch_one(query, params=None):
    conn = get_connection()
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute(query, params or ())
            return cur.fetchone()
    finally:
        conn.close()


@app.route("/")
def inicio():
    torneos = fetch_all(
        """
        SELECT t.id,
               t.nombre,
               t.titulo_videojuego,
               t.fecha_inicio,
               t.fecha_fin,
               t.prize_pool_usd,
               t.max_equipos,
               COUNT(i.equipo_id) AS equipos_inscritos
        FROM Torneos t
        LEFT JOIN Inscripciones i ON i.torneo_id = t.id
        GROUP BY t.id, t.nombre, t.titulo_videojuego, t.fecha_inicio, t.fecha_fin, t.prize_pool_usd, t.max_equipos
        ORDER BY t.id;
        """
    )
    return render_template("inicio.html", torneos=torneos)


@app.route("/torneos")
def torneos():
    torneos = fetch_all(
        """
        SELECT t.id,
               t.nombre,
               t.titulo_videojuego,
               t.fecha_inicio,
               t.fecha_fin,
               t.prize_pool_usd,
               t.max_equipos,
               COUNT(i.equipo_id) AS equipos_inscritos
        FROM Torneos t
        LEFT JOIN Inscripciones i ON i.torneo_id = t.id
        GROUP BY t.id, t.nombre, t.titulo_videojuego, t.fecha_inicio, t.fecha_fin, t.prize_pool_usd, t.max_equipos
        ORDER BY t.id;
        """
    )
    return render_template("torneos.html", torneos=torneos)


@app.route("/torneos/<int:torneo_id>")
def detalle_torneo(torneo_id):
    torneo = fetch_one(
        """
        SELECT t.id,
               t.nombre,
               t.titulo_videojuego,
               t.fecha_inicio,
               t.fecha_fin,
               t.prize_pool_usd,
               t.max_equipos,
               COUNT(i.equipo_id) AS equipos_inscritos
        FROM Torneos t
        LEFT JOIN Inscripciones i ON i.torneo_id = t.id
        WHERE t.id = %s
        GROUP BY t.id, t.nombre, t.titulo_videojuego, t.fecha_inicio, t.fecha_fin, t.prize_pool_usd, t.max_equipos;
        """,
        (torneo_id,),
    )

    if torneo is None:
        flash("El torneo solicitado no existe.", "error")
        return redirect(url_for("torneos"))

    tabla_posiciones = fetch_all(
        """
        WITH partidos AS (
            SELECT p.torneo_id, p.equipo_a_id AS equipo_id,
                   CASE WHEN p.puntaje_a > p.puntaje_b THEN 1 ELSE 0 END AS ganadas,
                   CASE WHEN p.puntaje_a = p.puntaje_b THEN 1 ELSE 0 END AS empatadas,
                   CASE WHEN p.puntaje_a < p.puntaje_b THEN 1 ELSE 0 END AS perdidas
            FROM Partidas p
            WHERE p.torneo_id = %s AND p.fase = 'fase de grupos'
            UNION ALL
            SELECT p.torneo_id, p.equipo_b_id AS equipo_id,
                   CASE WHEN p.puntaje_b > p.puntaje_a THEN 1 ELSE 0 END AS ganadas,
                   CASE WHEN p.puntaje_a = p.puntaje_b THEN 1 ELSE 0 END AS empatadas,
                   CASE WHEN p.puntaje_b < p.puntaje_a THEN 1 ELSE 0 END AS perdidas
            FROM Partidas p
            WHERE p.torneo_id = %s AND p.fase = 'fase de grupos'
        )
        SELECT e.id,
               e.nombre,
               COUNT(*) AS jugadas,
               SUM(ganadas) AS ganadas,
               SUM(empatadas) AS empatadas,
               SUM(perdidas) AS perdidas,
               SUM(ganadas) * 3 + SUM(empatadas) AS puntaje_total
        FROM partidos pa
        JOIN Equipos e ON e.id = pa.equipo_id
        GROUP BY e.id, e.nombre
        ORDER BY puntaje_total DESC, ganadas DESC, e.nombre ASC;
        """,
        (torneo_id, torneo_id),
    )

    partidas = fetch_all(
        """
        SELECT p.id,
               p.fecha_hora,
               p.fase,
               ea.nombre AS equipo_a,
               eb.nombre AS equipo_b,
               p.puntaje_a,
               p.puntaje_b
        FROM Partidas p
        JOIN Equipos ea ON ea.id = p.equipo_a_id
        JOIN Equipos eb ON eb.id = p.equipo_b_id
        WHERE p.torneo_id = %s
        ORDER BY p.fecha_hora, p.id;
        """,
        (torneo_id,),
    )

    equipos = fetch_all(
        """
        SELECT e.id,
               e.nombre,
               e.fecha_creacion,
               e.capitan_gamertag
        FROM Inscripciones i
        JOIN Equipos e ON e.id = i.equipo_id
        WHERE i.torneo_id = %s
        ORDER BY e.nombre;
        """,
        (torneo_id,),
    )

    sponsors = fetch_all(
        """
        SELECT s.nombre,
               s.industria,
               a.monto_usd
        FROM Auspicios a
        JOIN Sponsors s ON s.id = a.sponsor_id
        WHERE a.torneo_id = %s
        ORDER BY a.monto_usd DESC, s.nombre;
        """,
        (torneo_id,),
    )

    return render_template(
        "detalle_torneo.html",
        torneo=torneo,
        tabla_posiciones=tabla_posiciones,
        partidas=partidas,
        equipos=equipos,
        sponsors=sponsors,
    )


@app.route("/estadisticas")
def estadisticas():
    torneos = fetch_all("SELECT id, nombre FROM Torneos ORDER BY id;")
    torneo_id = request.args.get("torneo_id", type=int)
    equipo_id = request.args.get("equipo_id", type=int)

    ranking = []
    evolucion = []
    equipos_torneo = []

    if torneo_id:
        equipos_torneo = fetch_all(
            """
            SELECT e.id, e.nombre
            FROM Inscripciones i
            JOIN Equipos e ON e.id = i.equipo_id
            WHERE i.torneo_id = %s
            ORDER BY e.nombre;
            """,
            (torneo_id,),
        )

        ranking = fetch_all(
            """
            SELECT j.gamertag,
                   e.nombre AS equipo,
                   COUNT(DISTINCT ei.partida_id) AS partidas_jugadas,
                   SUM(ei.kos) AS total_kos,
                   SUM(ei.restarts) AS total_restarts,
                   SUM(ei.assists) AS total_assists,
                   ROUND(SUM(ei.kos)::numeric / NULLIF(SUM(ei.restarts), 0), 2) AS ratio
            FROM Estadisticas_Individuales ei
            JOIN Partidas p ON p.id = ei.partida_id
            JOIN Jugadores j ON j.gamertag = ei.jugador_gamertag
            JOIN Equipos e ON e.id = j.equipo_id
            WHERE p.torneo_id = %s
            GROUP BY j.gamertag, e.nombre
            HAVING COUNT(DISTINCT ei.partida_id) >= 2
            ORDER BY ratio DESC NULLS LAST, total_kos DESC, j.gamertag ASC;
            """,
            (torneo_id,),
        )

        if equipo_id:
            evolucion = fetch_all(
                """
                SELECT CASE
                           WHEN p.fase = 'fase de grupos' THEN 'Fase de grupos'
                           WHEN p.fase IN ('semifinal', 'final', 'cuartos de final') THEN 'Eliminatorias'
                       END AS etapa,
                       ROUND(AVG(ei.kos)::numeric, 2) AS promedio_kos,
                       ROUND(AVG(ei.restarts)::numeric, 2) AS promedio_restarts,
                       ROUND(AVG(ei.assists)::numeric, 2) AS promedio_assists,
                       COUNT(*) AS registros
                FROM Estadisticas_Individuales ei
                JOIN Partidas p ON p.id = ei.partida_id
                JOIN Jugadores j ON j.gamertag = ei.jugador_gamertag
                WHERE p.torneo_id = %s
                  AND j.equipo_id = %s
                  AND p.fase IN ('fase de grupos', 'semifinal', 'final', 'cuartos de final')
                GROUP BY etapa
                ORDER BY CASE
                           WHEN etapa = 'Fase de grupos' THEN 1
                           ELSE 2
                         END;
                """,
                (torneo_id, equipo_id),
            )

    return render_template(
        "estadisticas.html",
        torneos=torneos,
        torneo_id=torneo_id,
        equipo_id=equipo_id,
        ranking=ranking,
        evolucion=evolucion,
        equipos_torneo=equipos_torneo,
    )


@app.route("/busqueda")
def busqueda():
    q = request.args.get("q", "").strip()
    jugadores = []
    equipos = []

    if q:
        patron = f"%{q}%"
        jugadores = fetch_all(
            """
            SELECT j.gamertag,
                   j.nombre_real,
                   j.email,
                   j.pais_origen,
                   e.nombre AS equipo
            FROM Jugadores j
            JOIN Equipos e ON e.id = j.equipo_id
            WHERE j.gamertag ILIKE %s
               OR j.pais_origen ILIKE %s
            ORDER BY j.gamertag;
            """,
            (patron, patron),
        )

        equipos = fetch_all(
            """
            SELECT e.id,
                   e.nombre,
                   e.fecha_creacion,
                   e.capitan_gamertag,
                   COUNT(j.gamertag) AS cantidad_jugadores
            FROM Equipos e
            LEFT JOIN Jugadores j ON j.equipo_id = e.id
            WHERE e.nombre ILIKE %s
            GROUP BY e.id, e.nombre, e.fecha_creacion, e.capitan_gamertag
            ORDER BY e.nombre;
            """,
            (patron,),
        )

    return render_template("busqueda.html", q=q, jugadores=jugadores, equipos=equipos)


@app.route("/sponsors")
def sponsors():
    videojuego = request.args.get("videojuego", "").strip()
    videojuegos = fetch_all(
        "SELECT DISTINCT titulo_videojuego FROM Torneos ORDER BY titulo_videojuego;"
    )
    sponsors_resultado = []

    if videojuego:
        sponsors_resultado = fetch_all(
            """
            WITH torneos_juego AS (
                SELECT id
                FROM Torneos
                WHERE titulo_videojuego = %s
            ),
            cantidad_torneos AS (
                SELECT COUNT(*) AS total
                FROM torneos_juego
            )
            SELECT s.nombre,
                   s.industria,
                   SUM(a.monto_usd) AS monto_total_aportado
            FROM Sponsors s
            JOIN Auspicios a ON a.sponsor_id = s.id
            JOIN torneos_juego tj ON tj.id = a.torneo_id
            GROUP BY s.id, s.nombre, s.industria
            HAVING COUNT(DISTINCT a.torneo_id) = (SELECT total FROM cantidad_torneos)
            ORDER BY monto_total_aportado DESC, s.nombre;
            """,
            (videojuego,),
        )

    return render_template(
        "sponsors.html",
        videojuegos=videojuegos,
        videojuego=videojuego,
        sponsors_resultado=sponsors_resultado,
    )


@app.route("/inscripciones", methods=["GET", "POST"])
def inscripciones():
    if request.method == "POST":
        torneo_id = request.form.get("torneo_id", type=int)
        equipo_id = request.form.get("equipo_id", type=int)

        if not torneo_id or not equipo_id:
            flash("Debes seleccionar un torneo y un equipo.", "error")
            return redirect(url_for("inscripciones"))

        conn = get_connection()
        try:
            with conn.cursor(cursor_factory=RealDictCursor) as cur:
                cur.execute(
                    """
                    SELECT t.id, t.nombre, t.max_equipos, COUNT(i.equipo_id) AS inscritos
                    FROM Torneos t
                    LEFT JOIN Inscripciones i ON i.torneo_id = t.id
                    WHERE t.id = %s
                    GROUP BY t.id, t.nombre, t.max_equipos;
                    """,
                    (torneo_id,),
                )
                torneo = cur.fetchone()

                cur.execute(
                    "SELECT id, nombre FROM Equipos WHERE id = %s;",
                    (equipo_id,),
                )
                equipo = cur.fetchone()

                cur.execute(
                    "SELECT 1 FROM Inscripciones WHERE torneo_id = %s AND equipo_id = %s;",
                    (torneo_id, equipo_id),
                )
                ya_inscrito = cur.fetchone()

                if torneo is None or equipo is None:
                    flash("El torneo o el equipo seleccionado no existe.", "error")
                    return redirect(url_for("inscripciones"))

                if ya_inscrito:
                    flash("Ese equipo ya está inscrito en el torneo.", "error")
                    return redirect(url_for("inscripciones"))

                if torneo["inscritos"] >= torneo["max_equipos"]:
                    flash(
                        f"No se pudo inscribir a {equipo['nombre']}: el torneo {torneo['nombre']} ya alcanzó su cupo máximo.",
                        "error",
                    )
                    return redirect(url_for("inscripciones"))

                cur.execute(
                    "INSERT INTO Inscripciones (torneo_id, equipo_id) VALUES (%s, %s);",
                    (torneo_id, equipo_id),
                )
                conn.commit()
                flash("Inscripción realizada correctamente.", "success")
        except Exception as e:
            conn.rollback()
            flash(f"Ocurrió un error al guardar la inscripción: {e}", "error")
        finally:
            conn.close()

        return redirect(url_for("inscripciones"))

    torneos = fetch_all(
        """
        SELECT t.id,
               t.nombre,
               t.max_equipos,
               COUNT(i.equipo_id) AS inscritos
        FROM Torneos t
        LEFT JOIN Inscripciones i ON i.torneo_id = t.id
        GROUP BY t.id, t.nombre, t.max_equipos
        ORDER BY t.id;
        """
    )
    equipos = fetch_all("SELECT id, nombre FROM Equipos ORDER BY nombre;")
    inscripciones_actuales = fetch_all(
        """
        SELECT t.nombre AS torneo,
               e.nombre AS equipo
        FROM Inscripciones i
        JOIN Torneos t ON t.id = i.torneo_id
        JOIN Equipos e ON e.id = i.equipo_id
        ORDER BY t.id, e.nombre;
        """
    )
    return render_template(
        "inscripciones.html",
        torneos=torneos,
        equipos=equipos,
        inscripciones_actuales=inscripciones_actuales,
    )


if __name__ == "__main__":
    app.run(debug=True)