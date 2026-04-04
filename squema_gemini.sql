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
);-- 2. Poblar Jugadores (Al menos 5 por equipo) [cite: 61]
-- Se muestran los jugadores de los equipos 1 y 2 a modo de ejemplo. Se deben completar hasta el equipo 10.
INSERT INTO Jugadores (gamertag, nombre_real, email, fecha_nacimiento, pais_origen, equipo_id) VALUES
-- Equipo 1
('NinjaLeader', 'Andres Soto', 'andres@mail.com', '2001-05-10', 'Chile', 1),
('ShadowStrike', 'Camilo Perez', 'camilo@mail.com', '2002-08-15', 'Argentina', 1),
('Stealthy', 'Diego Ruiz', 'diego@mail.com', '2000-11-20', 'Peru', 1),
('GhostBlade', 'Esteban Lima', 'esteban@mail.com', '2003-01-25', 'Chile', 1),
('NightHawk', 'Felipe Toro', 'felipe@mail.com', '1999-04-30', 'Colombia', 1),
-- Equipo 2
('QuantumBoss', 'Gabriel Diaz', 'gabriel@mail.com', '2001-06-12', 'Mexico', 2),
('Quark', 'Hugo Sanchez', 'hugo@mail.com', '2002-09-18', 'Chile', 2),
('Photon', 'Ignacio Vega', 'ignacio@mail.com', '2000-12-22', 'España', 2),
('Neutrino', 'Javier Mora', 'javier@mail.com', '2003-02-28', 'Uruguay', 2),
('Gluon', 'Kevin Rivas', 'kevin@mail.com', '1999-05-05', 'Chile', 2);-- (Se deben agregar las partidas faltantes para completar el round-robin y las fases eliminatorias hasta la final) [cite: 62]

-- 8. Poblar Estadísticas Individuales para las partidas [cite: 64]
-- Estadísticas de la Partida 1 (Equipo 1 vs Equipo 2)
INSERT INTO Estadisticas_Individuales (partida_id, jugador_gamertag, kos, restarts, assists) VALUES
(1, 'NinjaLeader', 15, 5, 8),
(1, 'ShadowStrike', 10, 8, 12),
(1, 'QuantumBoss', 12, 10, 4),
(1, 'Quark', 8, 12, 5);-- 7. Poblar Partidas (Simulación de Fase de Grupos Round-Robin) [cite: 38, 62]
-- Asumiendo Grupo A: Equipos 1, 2, 3, 4
INSERT INTO Partidas (id, torneo_id, equipo_a_id, equipo_b_id, fecha_hora, puntaje_a, puntaje_b, fase) VALUES
(1, 1, 1, 2, '2026-06-01 18:00:00', 13, 10, 'fase de grupos'),
(2, 1, 3, 4, '2026-06-01 20:00:00', 5, 13, 'fase de grupos'),
(3, 1, 1, 3, '2026-06-02 18:00:00', 13, 11, 'fase de grupos'),
(4, 1, 2, 4, '2026-06-02 20:00:00', 8, 13, 'fase de grupos');INSERT INTO Auspicios (sponsor_id, torneo_id, monto_usd) VALUES
(1, 1, 15000.00), (2, 1, 5000.00), (3, 1, 2000.00),
(4, 2, 20000.00), (5, 2, 8000.00), (1, 3, 5000.00);-- CASO DE PRUEBA: El Torneo 1 ya tiene 8 equipos. 
-- La inscripción del equipo 9 a continuación debe servir para probar la validación en la Parte C de la tarea web[cite: 66, 85].
-- Si se ejecuta directamente en PostgreSQL sin triggers, esta línea funcionará, pero la validación web debe rechazarla.
-- INSERT INTO Inscripciones (torneo_id, equipo_id) VALUES (1, 9); 

-- 6. Poblar Sponsors y Auspicios (Al menos 5 sponsors) [cite: 63]
INSERT INTO Sponsors (id, nombre, industria) VALUES
(1, 'TechCorp', 'Tecnología'),
(2, 'EnergyDrink Max', 'Bebidas'),
(3, 'GamerWear', 'Ropa'),
(4, 'CloudHosting Pro', 'Tecnología'),
(5, 'FastSnacks', 'Alimentos');

DROP TABLE equipos CASCADE;