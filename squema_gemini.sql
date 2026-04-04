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
ALTER TABLE Equipos
ADD CONSTRAINT fk_capitan
FOREIGN KEY (capitan_gamertag) REFERENCES Jugadores(gamertag);

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

-- 6. Tabla de Estadísticas Individuales
CREATE TABLE Estadisticas_Individuales (
    partida_id INT REFERENCES Partidas(id),
    jugador_gamertag VARCHAR(255) REFERENCES Jugadores(gamertag),
    kos INT DEFAULT 0,
    restarts INT DEFAULT 0,
    assists INT DEFAULT 0,
    PRIMARY KEY (partida_id, jugador_gamertag)
);

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