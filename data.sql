-- 1. Poblar Equipos (Se insertan 10 equipos sin capitán inicialmente para evitar conflictos de llave foránea) [cite: 61]
INSERT INTO Equipos (id, nombre, fecha_creacion) VALUES
(1, 'Cyber Ninjas', '2025-01-10'),
(2, 'Quantum Strikers', '2025-02-15'),
(3, 'Neon Dragons', '2025-03-20'),
(4, 'Void Walkers', '2025-04-05'),
(5, 'Apex Predators', '2025-05-12'),
(6, 'Titanium E-sports', '2025-06-18'),
(7, 'Lunar Wolves', '2025-07-22'),
(8, 'Solar Flares', '2025-08-30'),
(9, 'Pixel Vanguard', '2025-09-14'),
(10, 'Glitch Syndicate', '2025-10-01');

-- 2. Poblar Jugadores (Al menos 5 por equipo) [cite: 61]
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
('Gluon', 'Kevin Rivas', 'kevin@mail.com', '1999-05-05', 'Chile', 2);
-- (Continuar agregando 5 jugadores por cada equipo del 3 al 10)
INSERT INTO Jugadores (gamertag, nombre_real, email, fecha_nacimiento, pais_origen, equipo_id) VALUES
-- Equipo 3: Neon Dragons
('NeonKing', 'Luis Rojas', 'luis.r@mail.com', '2000-03-12', 'Chile', 3),
('FireBreath', 'Matias Silva', 'matias.s@mail.com', '2001-07-24', 'Argentina', 3),
('ScaleMail', 'Nicolas Gomez', 'nico.g@mail.com', '1999-11-05', 'Peru', 3),
('ClawStriker', 'Oscar Peña', 'oscar.p@mail.com', '2002-02-18', 'Colombia', 3),
('TailWhip', 'Pablo Herrera', 'pablo.h@mail.com', '2003-09-30', 'Mexico', 3),

-- Equipo 4: Void Walkers
('VoidLord', 'Rodrigo Castro', 'rodrigo.c@mail.com', '2001-04-15', 'Chile', 4),
('DarkMatter', 'Simon Vargas', 'simon.v@mail.com', '2002-08-22', 'España', 4),
('AbyssDiver', 'Tomas Muñoz', 'tomas.m@mail.com', '2000-12-10', 'Uruguay', 4),
('NullSpace', 'Victor Rios', 'victor.r@mail.com', '1998-05-08', 'Chile', 4),
('ZeroGravity', 'Waldo Tapia', 'waldo.t@mail.com', '1999-10-14', 'Argentina', 4),

-- Equipo 5: Apex Predators
('ApexAlpha', 'Alonso Flores', 'alonso.f@mail.com', '2000-01-20', 'Peru', 5),
('TigerFang', 'Bastian Cardenas', 'bastian.c@mail.com', '2001-06-11', 'Chile', 5),
('EagleEye', 'Cristian Pavez', 'cristian.p@mail.com', '2002-09-05', 'Mexico', 5),
('WolfPack', 'Daniel Ortiz', 'daniel.o@mail.com', '2003-03-17', 'Colombia', 5),
('BearClaw', 'Elias Nunez', 'elias.n@mail.com', '1999-11-28', 'España', 5),

-- Equipo 6: Titanium E-sports
('IronShield', 'Fernando Lagos', 'fernando.l@mail.com', '2001-02-14', 'Chile', 6),
('SteelBlade', 'Gonzalo Vera', 'gonzalo.v@mail.com', '2000-08-09', 'Argentina', 6),
('AlloyForge', 'Hector Salas', 'hector.s@mail.com', '2002-12-01', 'Uruguay', 6),
('MetalGear', 'Ivan Miranda', 'ivan.m@mail.com', '1998-04-25', 'Peru', 6),
('ChromePlate', 'Jorge Fuentes', 'jorge.f@mail.com', '1999-07-13', 'Mexico', 6),

-- Equipo 7: Lunar Wolves
('MoonHowl', 'Lucas Carrasco', 'lucas.c@mail.com', '2000-05-30', 'Chile', 7),
('StarGazer', 'Martin Navarro', 'martin.n@mail.com', '2001-10-21', 'Colombia', 7),
('OrbitPath', 'Nestor Pino', 'nestor.p@mail.com', '2002-01-08', 'España', 7),
('CraterDust', 'Orlando Leiva', 'orlando.l@mail.com', '2003-06-15', 'Argentina', 7),
('EclipseShadow', 'Patricio Reyes', 'patricio.r@mail.com', '1999-09-02', 'Chile', 7),

-- Equipo 8: Solar Flares
('SunBurst', 'Quinten Osorio', 'quinten.o@mail.com', '2001-03-22', 'Uruguay', 8),
('FlareGun', 'Renato Bravo', 'renato.b@mail.com', '2000-11-18', 'Peru', 8),
('HeatWave', 'Sergio Medina', 'sergio.m@mail.com', '2002-04-05', 'Mexico', 8),
('PlasmaStorm', 'Tomas Vidal', 'tomas.v@mail.com', '1998-08-27', 'Chile', 8),
('CoronaRing', 'Ulises Guzman', 'ulises.g@mail.com', '1999-12-19', 'Colombia', 8),

-- Equipo 9: Pixel Vanguard
('PixelHero', 'Vicente Araya', 'vicente.a@mail.com', '2000-06-14', 'Chile', 9),
('VoxelKnight', 'William Riquelme', 'william.r@mail.com', '2001-09-08', 'Argentina', 9),
('BitStream', 'Xavier Bustos', 'xavier.b@mail.com', '2002-02-25', 'España', 9),
('ByteForce', 'Yerko Valdes', 'yerko.v@mail.com', '2003-05-11', 'Uruguay', 9),
('GlitchArt', 'Zahir Godoy', 'zahir.g@mail.com', '1999-10-04', 'Peru', 9),

-- Equipo 10: Glitch Syndicate
('GlitchMaster', 'Alan Martinez', 'alan.m@mail.com', '2001-01-29', 'Mexico', 10),
('BugHunter', 'Boris Aguilar', 'boris.a@mail.com', '2000-07-06', 'Chile', 10),
('ErrorCode', 'Carlos donoso', 'carlos.d@mail.com', '2002-11-15', 'Colombia', 10),
('CrashOverride', 'David Fernandez', 'david.f@mail.com', '1998-03-20', 'Argentina', 10),
('NullPointer', 'Eduardo Lopez', 'eduardo.l@mail.com', '1999-08-03', 'España', 10);

-- Asignacion de capitanes para los equipos 3 al 10
UPDATE Equipos SET capitan_gamertag = 'NinjaLeader' WHERE id = 1;
UPDATE Equipos SET capitan_gamertag = 'QuantumBoss' WHERE id = 2;
-- (Continuar actualizando los capitanes de los demás equipos)
UPDATE Equipos SET capitan_gamertag = 'NeonKing' WHERE id = 3;
UPDATE Equipos SET capitan_gamertag = 'VoidLord' WHERE id = 4;
UPDATE Equipos SET capitan_gamertag = 'ApexAlpha' WHERE id = 5;
UPDATE Equipos SET capitan_gamertag = 'IronShield' WHERE id = 6;
UPDATE Equipos SET capitan_gamertag = 'MoonHowl' WHERE id = 7;
UPDATE Equipos SET capitan_gamertag = 'SunBurst' WHERE id = 8;
UPDATE Equipos SET capitan_gamertag = 'PixelHero' WHERE id = 9;
UPDATE Equipos SET capitan_gamertag = 'GlitchMaster' WHERE id = 10;


-- 4. Poblar Torneos (3 torneos, al menos uno con cupo de 8) [cite: 60]
INSERT INTO Torneos (id, nombre, titulo_videojuego, fecha_inicio, fecha_fin, prize_pool_usd, max_equipos) VALUES
(1, 'Copa Galáctica 2026', 'Valorant', '2026-06-01', '2026-06-15', 50000.00, 8),
(2, 'Liga de Leyendas Sur', 'League of Legends', '2026-07-01', '2026-07-20', 75000.00, 8),
(3, 'Torneo Relámpago', 'Rocket League', '2026-08-01', '2026-08-05', 10000.00, 8);

-- 5. Poblar Inscripciones (Inscribiendo 8 equipos en el Torneo 1 para llenarlo) [cite: 60]
INSERT INTO Inscripciones (torneo_id, equipo_id) VALUES
-- Torneo 1: equipos 1 al 8
(1,1),(1,2),(1,3),(1,4),(1,5),(1,6),(1,7),(1,8),

-- Torneo 2: equipos 3 al 10
(2,3),(2,4),(2,5),(2,6),(2,7),(2,8),(2,9),(2,10),

-- Torneo 3: mezcla de 8 equipos
(3,1),(3,2),(3,5),(3,6),(3,7),(3,8),(3,9),(3,10);

-- CASO DE PRUEBA: El Torneo 1 ya tiene 8 equipos. 
-- La inscripcion del equipo 9 a continuacion debe servir para probar la validacion en la Parte C de la tarea web[cite: 66, 85].
-- Si se ejecuta directamente en PostgreSQL sin triggers, esta línea funcionará, pero la validacion web debe rechazarla.
-- INSERT INTO Inscripciones (torneo_id, equipo_id) VALUES (1, 9); 

-- 6. Poblar Sponsors y Auspicios (Al menos 5 sponsors) [cite: 63]
INSERT INTO Sponsors (id, nombre, industria) VALUES
(1, 'TechCorp', 'Tecnología'),
(2, 'EnergyDrink Max', 'Bebidas'),
(3, 'GamerWear', 'Ropa'),
(4, 'CloudHosting Pro', 'Tecnología'),
(5, 'FastSnacks', 'Alimentos');

INSERT INTO Auspicios (sponsor_id, torneo_id, monto_usd) VALUES
(1, 1, 15000.00), (2, 1, 5000.00), (3, 1, 2000.00),
(4, 2, 20000.00), (5, 2, 8000.00), (1, 3, 5000.00);

-- 7. Poblar Partidas (Simulacion de Fase de Grupos Round-Robin) [cite: 38, 62]
-- Asumiendo Grupo A: Equipos 1, 2, 3, 4
INSERT INTO Partidas
(id, torneo_id, equipo_a_id, equipo_b_id, fecha_hora, puntaje_a, puntaje_b, fase)
VALUES
-- FASE DE GRUPOS - Grupo A
(1,  1, 1, 2, '2026-06-01 18:00:00', 13, 10, 'fase de grupos'),
(2,  1, 3, 4, '2026-06-01 20:00:00',  5, 13, 'fase de grupos'),
(3,  1, 1, 3, '2026-06-02 18:00:00', 13, 11, 'fase de grupos'),
(4,  1, 2, 4, '2026-06-02 20:00:00',  8, 13, 'fase de grupos'),
(5,  1, 1, 4, '2026-06-03 18:00:00', 11, 13, 'fase de grupos'),
(6,  1, 2, 3, '2026-06-03 20:00:00', 13,  9, 'fase de grupos'),

-- FASE DE GRUPOS - Grupo B
(7,  1, 5, 6, '2026-06-04 18:00:00', 10, 13, 'fase de grupos'),
(8,  1, 7, 8, '2026-06-04 20:00:00', 13,  6, 'fase de grupos'),
(9,  1, 5, 7, '2026-06-05 18:00:00', 11, 13, 'fase de grupos'),
(10, 1, 6, 8, '2026-06-05 20:00:00', 13,  4, 'fase de grupos'),
(11, 1, 5, 8, '2026-06-06 18:00:00', 13,  7, 'fase de grupos'),
(12, 1, 6, 7, '2026-06-06 20:00:00',  9, 13, 'fase de grupos'),

-- SEMIFINALES
-- Clasificados supuestos:
-- Grupo A: 4°, 1°
-- Grupo B: 7°, 6°
(13, 1, 4, 7, '2026-06-10 19:00:00', 11, 13, 'semifinal'),
(14, 1, 1, 6, '2026-06-10 21:00:00', 13,  8, 'semifinal'),

-- FINAL
(15, 1, 1, 7, '2026-06-15 20:00:00', 13, 11, 'final');

-- 8. Poblar Estadísticas Individuales para las partidas [cite: 64]
WITH jugadores_partida AS (
    SELECT
        p.id AS partida_id,
        p.equipo_a_id,
        p.equipo_b_id,
        p.puntaje_a,
        p.puntaje_b,
        j.gamertag,
        j.equipo_id,
        ROW_NUMBER() OVER (
            PARTITION BY p.id, j.equipo_id
            ORDER BY j.gamertag
        ) AS rn
    FROM Partidas p
    JOIN Jugadores j
      ON j.equipo_id IN (p.equipo_a_id, p.equipo_b_id)
    WHERE p.torneo_id = 1
)
INSERT INTO Estadisticas_Individuales
(partida_id, jugador_gamertag, kos, restarts, assists)
SELECT
    partida_id,
    gamertag,
    CASE
        WHEN (equipo_id = equipo_a_id AND puntaje_a > puntaje_b)
          OR (equipo_id = equipo_b_id AND puntaje_b > puntaje_a)
            THEN 18 - rn
        ELSE 12 - rn
    END AS kos,
    CASE
        WHEN (equipo_id = equipo_a_id AND puntaje_a > puntaje_b)
          OR (equipo_id = equipo_b_id AND puntaje_b > puntaje_a)
            THEN 5 + rn
        ELSE 9 + rn
    END AS restarts,
    CASE
        WHEN (equipo_id = equipo_a_id AND puntaje_a > puntaje_b)
          OR (equipo_id = equipo_b_id AND puntaje_b > puntaje_a)
            THEN 4 + rn
        ELSE 3 + rn
    END AS assists
FROM jugadores_partida
ORDER BY partida_id, equipo_id, rn;

-- (Se deben agregar las estadísticas para todos los jugadores participantes en cada partida creada) [cite: 64]