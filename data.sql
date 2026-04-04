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

-- 3. Asignar Capitanes a los Equipos
UPDATE Equipos SET capitan_gamertag = 'NinjaLeader' WHERE id = 1;
UPDATE Equipos SET capitan_gamertag = 'QuantumBoss' WHERE id = 2;
-- (Continuar actualizando los capitanes de los demás equipos)

-- 4. Poblar Torneos (3 torneos, al menos uno con cupo de 8) [cite: 60]
INSERT INTO Torneos (id, nombre, titulo_videojuego, fecha_inicio, fecha_fin, prize_pool_usd, max_equipos) VALUES
(1, 'Copa Galáctica 2026', 'Valorant', '2026-06-01', '2026-06-15', 50000.00, 8),
(2, 'Liga de Leyendas Sur', 'League of Legends', '2026-07-01', '2026-07-20', 75000.00, 16),
(3, 'Torneo Relámpago', 'Rocket League', '2026-08-01', '2026-08-05', 10000.00, 4);

-- 5. Poblar Inscripciones (Inscribiendo 8 equipos en el Torneo 1 para llenarlo) [cite: 60]
INSERT INTO Inscripciones (torneo_id, equipo_id) VALUES
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 6), (1, 7), (1, 8);

-- CASO DE PRUEBA: El Torneo 1 ya tiene 8 equipos. 
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

INSERT INTO Auspicios (sponsor_id, torneo_id, monto_usd) VALUES
(1, 1, 15000.00), (2, 1, 5000.00), (3, 1, 2000.00),
(4, 2, 20000.00), (5, 2, 8000.00), (1, 3, 5000.00);

-- 7. Poblar Partidas (Simulación de Fase de Grupos Round-Robin) [cite: 38, 62]
-- Asumiendo Grupo A: Equipos 1, 2, 3, 4
INSERT INTO Partidas (id, torneo_id, equipo_a_id, equipo_b_id, fecha_hora, puntaje_a, puntaje_b, fase) VALUES
(1, 1, 1, 2, '2026-06-01 18:00:00', 13, 10, 'fase de grupos'),
(2, 1, 3, 4, '2026-06-01 20:00:00', 5, 13, 'fase de grupos'),
(3, 1, 1, 3, '2026-06-02 18:00:00', 13, 11, 'fase de grupos'),
(4, 1, 2, 4, '2026-06-02 20:00:00', 8, 13, 'fase de grupos');
-- (Se deben agregar las partidas faltantes para completar el round-robin y las fases eliminatorias hasta la final) [cite: 62]

-- 8. Poblar Estadísticas Individuales para las partidas [cite: 64]
-- Estadísticas de la Partida 1 (Equipo 1 vs Equipo 2)
INSERT INTO Estadisticas_Individuales (partida_id, jugador_gamertag, kos, restarts, assists) VALUES
(1, 'NinjaLeader', 15, 5, 8),
(1, 'ShadowStrike', 10, 8, 12),
(1, 'QuantumBoss', 12, 10, 4),
(1, 'Quark', 8, 12, 5);
-- (Se deben agregar las estadísticas para todos los jugadores participantes en cada partida creada) [cite: 64]