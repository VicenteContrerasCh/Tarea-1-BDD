-- 1. Tabla de Equipos (Creación parcial para resolver dependencia circular)
CREATE TABLE Equipos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(255) UNIQUE NOT NULL,
    fecha_creacion DATE NOT NULL,
    capitan_gamertag VARCHAR(255) -- Se añade la FK después
);

-- 2. Tabla de Jugadores
CREATE TABLE Jugadores (
    gamertag VARCHAR(255) PRIMARY KEY,
    nombre_real VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    pais_origen VARCHAR(100) NOT NULL,
    equipo_id INT REFERENCES Equipos(id) NOT NULL
);

-- Agregar la clave foránea del capitán a la tabla Equipos
-- ALTER TABLE Equipos
-- ADD CONSTRAINT fk_capitan
-- FOREIGN KEY (capitan_gamertag) REFERENCES Jugadores(gamertag);

-- Crea la restricción de que no se repite una combinación de gamertag y equipo_id en Jugadores
-- para poder referenciarlo como Foreign Key sin problemas.
ALTER TABLE Jugadores
ADD CONSTRAINT uq_jugador_equipo UNIQUE (gamertag, equipo_id);

-- Ahora creamos la foreign key desde Equipos sin generar problemas, ya que ahora
-- apunta a un conjunto de atributos de Jugadores que es único. Asegurando que el capitán pertenece
-- al mismo equipo.
ALTER TABLE Equipos
ADD CONSTRAINT fk_capitan_del_mismo_equipo
FOREIGN KEY (capitan_gamertag, id)
REFERENCES Jugadores(gamertag, equipo_id);

-- 3. Tabla de Torneos
CREATE TABLE Torneos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    titulo_videojuego VARCHAR(255) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    prize_pool_usd DECIMAL(10, 2) NOT NULL,
    max_equipos INT NOT NULL
);

-- 4. Tabla de Inscripciones a Torneos
CREATE TABLE Inscripciones (
    torneo_id INT REFERENCES Torneos(id),
    equipo_id INT REFERENCES Equipos(id),
    PRIMARY KEY (torneo_id, equipo_id)
);
-- El problema que tenemos aquí con Inscripciones es que no considera el máximo de equipos en 
-- cada torneo. Notamos que no se podría usar por ejemplo un check porque este comando sirve para
-- verificar atributos de una tupla y no sirve para un conjunto. A continuación agregamos el trigger:
-- (Esto está bien explicado en el informe)
CREATE OR REPLACE FUNCTION verificar_cupo_torneo()
RETURNS TRIGGER AS $$
DECLARE
    inscritos_actuales INT;
    maximo_permitido INT;
BEGIN
    SELECT COUNT(*)
    INTO inscritos_actuales
    FROM Inscripciones
    WHERE torneo_id = NEW.torneo_id;

    SELECT max_equipos
    INTO maximo_permitido
    FROM Torneos
    WHERE id = NEW.torneo_id;

    IF inscritos_actuales >= maximo_permitido THEN
        RAISE EXCEPTION 'No se puede inscribir el equipo: el torneo % ya alcanzó su máximo de equipos',
            NEW.torneo_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Ahora simplemente lo ligamos a la tabla de Inscripciones.
CREATE TRIGGER trg_verificar_cupo_torneo
BEFORE INSERT ON Inscripciones
FOR EACH ROW
EXECUTE FUNCTION verificar_cupo_torneo();

-- 5. Tabla de Partidas
CREATE TABLE Partidas (
    id SERIAL PRIMARY KEY,
    torneo_id INT REFERENCES Torneos(id) NOT NULL,
    equipo_a_id INT REFERENCES Equipos(id) NOT NULL,
    equipo_b_id INT REFERENCES Equipos(id) NOT NULL,
    fecha_hora TIMESTAMP NOT NULL,
    puntaje_a INT,
    puntaje_b INT,
    fase VARCHAR(50) CHECK (fase IN ('fase de grupos', 'cuartos de final', 'semifinal', 'final')) NOT NULL,
    CHECK (equipo_a_id != equipo_b_id)
);
-- El problema que se nos presenta en Partidas es que no tenemos como asegurar que los equipos
-- que se enfrentan en la partida estén inscritos en el mismo torneo. Lo solucionamos con las 
-- siguientes restricciones:

ALTER TABLE Partidas -- Aseguramos que el equipo "a" esté inscrito.
ADD CONSTRAINT fk_partida_equipo_a_inscrito
FOREIGN KEY (torneo_id, equipo_a_id)
REFERENCES Inscripciones(torneo_id, equipo_id);

ALTER TABLE Partidas -- Aseguramos que el equipo "b" esté inscrito.
ADD CONSTRAINT fk_partida_equipo_b_inscrito
FOREIGN KEY (torneo_id, equipo_b_id)
REFERENCES Inscripciones(torneo_id, equipo_id);

-- A continuación hacemos restricciones para asegurar puntajes >= a cero.
ALTER TABLE Partidas
ADD CONSTRAINT chk_puntaje_a_no_negativo CHECK (puntaje_a IS NULL OR puntaje_a >= 0);

ALTER TABLE Partidas
ADD CONSTRAINT chk_puntaje_b_no_negativo CHECK (puntaje_b IS NULL OR puntaje_b >= 0);

-- 6. Tabla de Estadísticas Individuales
CREATE TABLE Estadisticas_Individuales (
    partida_id INT REFERENCES Partidas(id),
    jugador_gamertag VARCHAR(255) REFERENCES Jugadores(gamertag),
    kos INT DEFAULT 0,
    restarts INT DEFAULT 0,
    assists INT DEFAULT 0,
    PRIMARY KEY (partida_id, jugador_gamertag)
);
-- El problema que hay aquí es que no se nos asegura que el jugador mencionado haya efectivamente
-- participado en la partida. Por lo tanto hay que usar tablas Estadisticas_Individuales, Jugadores
-- y Partidas. Para esto hay que usar un trigger.
-- Trigger: regla automática que PostgreSQL ejecuta cuando le hacemos algo a una tabla.
-- (Esto está bien explicado en el informe)

CREATE OR REPLACE FUNCTION verificar_jugador_en_partida()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM Partidas p
        JOIN Jugadores j ON j.gamertag = NEW.jugador_gamertag
        WHERE p.id = NEW.partida_id
          AND j.equipo_id IN (p.equipo_a_id, p.equipo_b_id)
    ) THEN
        RAISE EXCEPTION 'El jugador % no pertenece a ninguno de los equipos de la partida %',
            NEW.jugador_gamertag, NEW.partida_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Teniendo el trigger listo, debemos unirlo a la tabala.
CREATE TRIGGER trg_verificar_jugador_en_partida
BEFORE INSERT OR UPDATE ON Estadisticas_Individuales
FOR EACH ROW
EXECUTE FUNCTION verificar_jugador_en_partida();

-- A continuación hacemos restricciones para asegurar estadísticas >= a cero.
ALTER TABLE Estadisticas_Individuales
ADD CONSTRAINT chk_kos_no_negativos CHECK (kos >= 0);

ALTER TABLE Estadisticas_Individuales
ADD CONSTRAINT chk_restarts_no_negativos CHECK (restarts >= 0);

ALTER TABLE Estadisticas_Individuales
ADD CONSTRAINT chk_assists_no_negativos CHECK (assists >= 0);

-- 7. Tabla de Sponsors y Auspicios
CREATE TABLE Sponsors (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    industria VARCHAR(255) NOT NULL
);

CREATE TABLE Auspicios (
    sponsor_id INT REFERENCES Sponsors(id),
    torneo_id INT REFERENCES Torneos(id),
    monto_usd DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (sponsor_id, torneo_id)
);