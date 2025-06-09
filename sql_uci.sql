-- 1. Crear nueva base de datos
CREATE DATABASE IF NOT EXISTS SensorTest;
USE SensorTest;

-- 2. Crear tabla nueva
CREATE TABLE IF NOT EXISTS LecturasAmbiente (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    SensorID INT NOT NULL DEFAULT 1,
    Timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    Temperatura DECIMAL(5,2),
    Humedad DECIMAL(5,2)
);

-- 3. Crear procedimiento almacenado con generación robusta
DELIMITER $$
DROP PROCEDURE IF EXISTS InsertarLectura;
CREATE PROCEDURE InsertarLectura()
BEGIN
    -- declarar como DOUBLE para que RAND() funcione correctamente
    DECLARE temp DOUBLE;
    DECLARE hum DOUBLE;

    -- generar valores directamente como DOUBLE
    SET temp = ROUND(21 + (RAND() * (24 - 21)), 2);
	SET hum  = ROUND(30 + (RAND() * (60 - 30)), 2);


    INSERT INTO LecturasAmbiente (SensorID, Temperatura, Humedad)
    VALUES (1, temp, hum);
END;
$$
DELIMITER ;


-- 4. Activar el event scheduler (si aún no está activo)
SET GLOBAL event_scheduler = ON;

-- 5. Crear evento programado que ejecuta el procedimiento cada 5 segundos
DROP EVENT IF EXISTS InsertarLecturaCada5s;

CREATE EVENT InsertarLecturaCada5s
ON SCHEDULE EVERY 5 SECOND
STARTS CURRENT_TIMESTAMP
DO CALL InsertarLectura();
	
-- 6. Verifica si la tabla recibe datos
-- Espera unos segundos y ejecuta:


SELECT * FROM LecturasAmbiente ORDER BY ID DESC;
SHOW EVENTS FROM SensorTest;

-- descomentar la siguiente línea para parar
-- ALTER EVENT InsertarLecturaCada5s DISABLE;
