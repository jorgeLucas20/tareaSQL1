create database practica;
use practica;
CREATE TABLE empleado 
( 	id_emp INTEGER, 
	SALARIO int,
	nombre VARCHAR(100), 
	dep INTEGER, 
	PRIMARY KEY (id_emp)); 

CREATE TABLE departamento 
(nro_dep INTEGER, 
nombre VARCHAR(20), 
PRIMARY KEY (nro_dep)); 
 

INSERT INTO empleado VALUES(1, 'Arturo', 30); 
INSERT INTO empleado VALUES(2, 'Eva', 20); 
INSERT INTO empleado VALUES(3, 'Miguel', 10); 
INSERT INTO empleado VALUES(4, 'Alejandro', 10); 
INSERT INTO empleado VALUES(5, 'Elena', 50); 
INSERT INTO empleado VALUES(6, 'Carmen', 40); 
INSERT INTO empleado VALUES(7, 'Mario', 30); 
INSERT INTO empleado VALUES(8, 'Esteban', 10); 
INSERT INTO empleado VALUES(9, 'Paco', 20); 
INSERT INTO empleado VALUES(10, 'Pili', 30); 

INSERT INTO departamento VALUES(10, 'Informática'); 
INSERT INTO departamento VALUES(20, 'Ventas'); 
INSERT INTO departamento VALUES(30, 'Compras'); 
INSERT INTO departamento VALUES(40, 'Publicidad'); 
INSERT INTO departamento VALUES(50, 'Recursos Humanos');  

-- Crear un disparador “insertar_empleado” para controlar la no inserción de una fila en la
-- tabla empleado cuando no sea horario laboral. Para este ejercicio vamos a considerar que 
-- el horario laboral del negocio es de viernes a miércoles de 2 pm a 10 pm

DROP TRIGGER IF EXISTS BEFORE_INSERT_EMPLEADO;
DELIMITER $$
CREATE TRIGGER BEFORE_INSERT_EMPLEADO BEFORE INSERT ON EMPLEADO FOR EACH ROW
BEGIN

IF NOT ((DAYOFWEEK(NOW()) BETWEEN 4 AND 6) AND (current_time() between '14:00:00' AND '22:00:00')) THEN

SET NEW.id_emp = NULL; -- Impider la operación.

END IF;
END $$ DELIMITER ;

-- Intentar ejecutar la siguiente orden y comprobar si ha habido algún cambio en la tabla: 
INSERT INTO empleado VALUES (11,'Pepe',30); 

DROP TRIGGER IF EXISTS BEFORE_INSERT_EMPLEADO;
DELIMITER $$
CREATE TRIGGER BEFORE_INSERT_EMPLEADO BEFORE INSERT ON EMPLEADO FOR EACH ROW
BEGIN

IF NOT ((DAYOFWEEK(NOW()) BETWEEN 4 AND 6) AND (current_time() between '14:00:00' AND '22:00:00')) THEN

SIGNAL SQLSTATE '45000'; -- Impide la operación.

END IF;
END $$ DELIMITER ;

-- 2. Crear el mismo disparador pero utilizando un procedimiento en el cuerpo del disparador que controle si la hora y el día son correctos.
-- 2.1 Copie el código que utilizó para crear el procedimiento
DROP PROCEDURE IF EXISTS VERIFICAR_HORARIO;

DELIMITER //
CREATE PROCEDURE VERIFICAR_HORARIO (OUT VERF BOOLEAN)
BEGIN
IF NOT ((DAYOFWEEK(NOW()) between 4 AND 6) AND (current_time() between '14:00:00' AND '22:00:00')) THEN
SET VERF = 0;
ELSE
SET VERF = 1;
END IF;
END // DELIMITER ;

DROP TRIGGER IF EXISTS BEFORE_INSERT_EMPLEADO;

DELIMITER $$ 
CREATE TRIGGER BEFORE_INSERT_EMPLEADO BEFORE INSERT ON EMPLEADO FOR EACH ROW
BEGIN

CALL VERIFICAR_HORARIO(@flag);

IF @flag = 0 THEN
SET NEW.ID_EMP = NULL;
END IF;

END $$ DELIMITER ;
-- 3. Crear un disparador que impida cualquier operación (insert, select, update, delete) en la tabla empleado fuera del horario laboral dando una indicación específica de la operación que no es realizable y porqué no es realizable (por ejemplo, que se encuentra fuera del horario laboral).

-- Para insert
DROP TRIGGER IF EXISTS BEFORE_INSERT_EMPLEADO;
DELIMITER $$
CREATE TRIGGER BEFORE_INSERT_EMPLEADO BEFORE INSERT ON EMPLEADO FOR EACH ROW

BEGIN
IF NOT ((DAYOFWEEK(NOW()) BETWEEN 4 AND 6) AND (current_time() between '14:00:00' AND '22:00:00')) THEN

SIGNAL SQLSTATE '45000' -- Impide la operación.
SET MESSAGE_TEXT = 'Fuera del horario laboral'; -- Pones el mensaje que quieras.

END IF;
END $$ DELIMITER ;

-- 3.2 Para probar si su disparador funciona cambie la fecha del sistema de tal forma que no permita realizar ninguna operación en la tabla. Copie el resultado (de la consola) al tratar de realizar: un insert, un update, un select, y un delete a la tabla.

-- Para update
DROP TRIGGER IF EXISTS BEFORE_UPDATE_EMPLEADO;
DELIMITER $$
CREATE TRIGGER BEFORE_UPDATE_EMPLEADO BEFORE UPDATE ON EMPLEADO FOR EACH ROW

BEGIN
IF NOT ((DAYOFWEEK(NOW()) BETWEEN 4 AND 6) AND (current_time() between '14:00:00' AND '22:00:00')) THEN

SIGNAL SQLSTATE '45000' -- Impide la operación.
SET MESSAGE_TEXT = 'Fuera del horario laboral'; -- Pones el mensaje que quieras.

END IF;
END $$ DELIMITER ;

USE PRACTICA;
-- Para delete
DROP TRIGGER IF EXISTS BEFORE_DELETE_EMPLEADO;
DELIMITER $$
CREATE TRIGGER BEFORE_DELETE_EMPLEADO BEFORE DELETE ON EMPLEADO FOR EACH ROW

BEGIN
IF NOT ((DAYOFWEEK(NOW()) BETWEEN 4 AND 6) AND (current_time() between '14:00:00' AND '22:00:00')) THEN

SIGNAL SQLSTATE '45000'; -- Impide la operación
SET MESSAGE_TEXT = 'Fuera del horario laboral'; -- Pones el mensaje que quieras.

END IF;
END $$ DELIMITER ;

/*4.Añadir a la tabla empleado una nueva columna salario. El valor por defecto debe ser el salario básico. */


select * from empleado;

ALTER TABLE EMPLEADO ADD SALARIO FLOAT DEFAULT 400;

/*5.Cree un disparador que cada vez que se ingrese un empleado, su salario se modifique de la siguiente manera: 

•	Si el empleado pertenece al departamento de ‘Informática’, su salario será el triple del salario básico.

•	Si el empleado pertenece al departamento de ‘Ventas’, su salario será el doble del salario básico.

•	Si el empleado pertenece al departamento de ‘Recursos Humanos’, su salario será el 1.5 del salario básico.
*/
INSERT INTO empleado VALUES (13, 'Antonella', 10); 
INSERT INTO empleado VALUES (14, 'Jose', 20); 
INSERT INTO empleado VALUES (15, 'Anthony', 30); 
INSERT INTO empleado VALUES (16, 'Maria', 50); 

DROP TRIGGER IF EXISTS BEFORE_INSERT_EMPLEADO;
DELIMITER $$
CREATE TRIGGER BEFORE_INSERT_EMPLEADO BEFORE INSERT ON EMPLEADO FOR EACH ROW
BEGIN
-- Seteo el nombre del departamento que tiene ese id.
SET @nom_depar = (SELECT NOMBRE FROM DEPARTAMENTO WHERE NRO_DEP = NEW.DEP);

IF (@nom_depar LIKE 'INFORMÁTICA') THEN
SET NEW.SALARIO = (NEW.SALARIO * 3);
END IF;

IF (@nom_depar LIKE 'VENTAS') THEN
SET NEW.SALARIO = NEW.SALARIO * 2;
END IF;

IF (@nom_depar LIKE 'RECURSOS HUMANOS') THEN
SET NEW.SALARIO = NEW.SALARIO * 1.5;
END IF;

END $$ DELIMITER ;
/*
6. Crear una tabla llamada Cambios dónde se almacenarán, mediante la utilización de un disparador, 
los cambios que se han llevado a cabo en la tabla empleado de forma que ante cada cambio de departamento 
o de salario de un empleado, la nueva tabla almacenará el identificador del empleado, el antiguo y el nuevo 
salario (a_salario, n_salario), o el antiguo y el nuevo departamento (a_dep, n_dep) junto con la fecha y hora en 
que el cambio tuvo lugar.
Tabla: Cambios
- id_empleado (NOT null)
- v_salario (null)
- n_salario (null)
- v_dep (null)
- n_dep (null)
- Fecha (datetime) NOT NULL

*/

-- IMPORTANTE: Para poder realizar el ejercicio 7 se requiere que id_empleado se pueda repetir.
-- Y ya que este se repetirá, yo utilizaría una nueva columna como id_cambios.
UPDATE empleado SET salario= salario*2 WHERE dep=10;
UPDATE empleado SET dep = salario/200 where salario>2000;


DROP TABLE IF EXISTS CAMBIOS;

CREATE TABLE CAMBIOS (
	ID_CAMBIOS INT PRIMARY KEY NOT NULL UNIQUE AUTO_INCREMENT,
	ID_EMPLEADO INT NOT NULL,
    V_SALARIO FLOAT NULL,
    N_SALARIO FLOAT NULL,
    V_DEP INT NULL,
    N_DEP INT NULL,
    FECHA DATETIME NOT NULL
);


DROP TRIGGER IF EXISTS AFTER_UPDATE_EMPLEADO;

DELIMITER $$
CREATE TRIGGER AFTER_UPDATE_EMPLEADO AFTER UPDATE ON EMPLEADO FOR EACH ROW
BEGIN
INSERT INTO CAMBIOS (ID_EMPLEADO,V_SALARIO,N_SALARIO,V_DEP,N_DEP,FECHA) VALUES (OLD.ID_EMP,OLD.SALARIO,NEW.SALARIO,OLD.DEP,NEW.DEP,NOW()); 
END $$ DELIMITER ;
select * from cambios;

UPDATE empleado SET salario= salario*2 WHERE dep=10;
UPDATE empleado SET dep = salario/200 where salario>2000;

/*
7. Añadir a la tabla empleado una nueva columna denominada media (tipo de dato decimal, valor por defecto 0)
que contendrá́ la media del salario que el trabajador ha tenido en la empresa. Esta columna tendrá́ por defecto
el salario actual del trabajador hasta que este salario se modifique. 
*/

-- En el enunciado dice que el valor por defecto de la columna es 0, el salario actual

ALTER TABLE EMPLEADO ADD MEDIA DECIMAL DEFAULT 0; -- Nueva columna, por defecto 0
UPDATE EMPLEADO SET MEDIA = SALARIO; -- Otro por defecto xd. El salario que tiene actualmente.

-- Creé un nuevo Trigger.
-- No algo como "ALTER TRIGGER" o similar. Si se quisiera editar la implementación del Trigger
-- se debe eliminar y volver a crear.
-- Puede ser un problema acordarse cómo estaba el trigger implementado con anterioridad. Para eso
-- podría usar "SHOW CREATE TRIGGER nombreTrigger" y puede ver el código. Lo copia-pega y agrega lo que necesite(:

DROP TRIGGER IF EXISTS MEDIA_SALARIO;

DELIMITER $$
CREATE TRIGGER MEDIA_SALARIO BEFORE UPDATE ON EMPLEADO FOR EACH ROW
BEGIN
SET NEW.MEDIA = (OLD.SALARIO + NEW.SALARIO)/2;
END $$ DELIMITER ;
 
UPDATE EMPLEADO SET SALARIO = 7000 WHERE ID_EMP = 8; -- Modifica el salario a 7000 del empleado con id 8.

/*8. Crear una vista llamada PromedioSalarioporDepartamento en dónde se muestre el identificador del 
departamento y el promedio del salario de los empleados por departamento. Nota: La tabla empleado
tiene el id del departamento.
*/

-- Las vistas se crean a partir de tablas ya existentes. 
-- Es decir, se crean a partir de una consulta hecha a alguna tabla.

-- Esto nos da ventajas como SEGURIDAD. Por ejemplo: Si debemos darle acceso a la información
-- al programador para que pruebe el aplicativo que está creando, no necesariamente le daremos toda la data
-- de la empresa, ya que en muchos casos esto es delicado como contraseñas.

-- Podríamos hacer un SELECT de la info que nos conviene, almacenarlo en una Vista y nada más darle acceso
-- a esa vista y no a la tabla o base de datos completa.

DROP VIEW IF EXISTS PromedioSalarioporDepartamento;

CREATE VIEW PromedioSalarioporDepartamento AS SELECT DEP, AVG(SALARIO) AS PROMEDIO_SALARIOS FROM EMPLEADO GROUP BY DEP;

/*
9. Ejecute la siguiente instrucción:
DELETE FROM PromedioSalarioporDepartamento WHERE idep=20;
*/

DELETE FROM PromedioSalarioporDepartamento WHERE idep=20; 

-- Se quiere realizar dicha operación sobre una VISTA, 
-- para que esto sea posible es necesario que la vista sea ACTUALIZABLE.

-- Revisamos si es o no actualizable con el siguiente query: (OPCIONAL)
SELECT table_name, is_updatable FROM information_schema.views WHERE table_schema = 'practica';
-- Resulta que NO es actualizable. Por esta razón no se puede hacer ninguna operación 
-- de insert, update y delete.

-- ¿Por qué no es actualizable? Porque el SELECT con el cuál fue creada la VISTA 
-- contenía una función de agregación AVG() y GROUP BY.

-- Para más casos cuando las vistas no son actualizables echarle un ojito a VISTAS ACTUALIZABLES.sql (: