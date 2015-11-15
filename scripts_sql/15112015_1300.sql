CREATE DATABASE IF NOT EXISTS `sistemarestaurantes` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `sistemarestaurantes`;
-- MySQL dump 10.13  Distrib 5.7.9, for Win64 (x86_64)
--
-- Host: localhost    Database: sistemarestaurantes
-- ------------------------------------------------------
-- Server version	5.7.9

/*!40101 SET @OLD_CHARACTER_SET_CLIENT = @@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS = @@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION = @@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE = @@TIME_ZONE */;
/*!40103 SET TIME_ZONE = '-06:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS = @@UNIQUE_CHECKS, UNIQUE_CHECKS = 0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS = @@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS = 0 */;
/*!40101 SET @OLD_SQL_MODE = @@SQL_MODE, SQL_MODE = 'NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES = @@SQL_NOTES, SQL_NOTES = 0 */;

--
-- Table structure for table `bitacora_cambios`
--

DROP TABLE IF EXISTS `bitacora_cambios`;
/*!40101 SET @saved_cs_client = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bitacora_cambios` (
  `id`        INT(11)  NOT NULL AUTO_INCREMENT,
  `fechaHora` DATETIME NOT NULL,
  `idUsuario` INT(11)           DEFAULT NULL,
  `detalles`  VARCHAR(2500)     DEFAULT 'Ningún cambio',
  PRIMARY KEY (`id`),
  KEY `FK_Bitacoras_u_idx` (`idUsuario`),
  CONSTRAINT `FK_Bitacoras_u` FOREIGN KEY (`idUsuario`) REFERENCES `usuarios` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE
)
  ENGINE = InnoDB
  DEFAULT CHARSET = utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bitacora_cambios`
--

LOCK TABLES `bitacora_cambios` WRITE;
/*!40000 ALTER TABLE `bitacora_cambios` DISABLE KEYS */;
/*!40000 ALTER TABLE `bitacora_cambios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `carritos_compras`
--

DROP TABLE IF EXISTS `carritos_compras`;
/*!40101 SET @saved_cs_client = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `carritos_compras` (
  `idCliente` INT(11)        NOT NULL,
  `idMenu`    INT(11)        NOT NULL,
  `cantidad`  DECIMAL(13, 3) NOT NULL DEFAULT '1.000',
  PRIMARY KEY (`idCliente`, `idMenu`),
  KEY `FK_CarritosCompras_m_idx` (`idMenu`),
  CONSTRAINT `FK_CarritosCompras_c` FOREIGN KEY (`idCliente`) REFERENCES `usuarios_clientes` (`idUsuario`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK_CarritosCompras_m` FOREIGN KEY (`idMenu`) REFERENCES `menu_restaurantes` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
)
  ENGINE = InnoDB
  DEFAULT CHARSET = utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `carritos_compras`
--

LOCK TABLES `carritos_compras` WRITE;
/*!40000 ALTER TABLE `carritos_compras` DISABLE KEYS */;
/*!40000 ALTER TABLE `carritos_compras` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
  /*!50003 CREATE */ /*!50017 DEFINER = CURRENT_USER */ /*!50003 TRIGGER `sistemarestaurantes`.`carritos_compras_BEFORE_INSERT` BEFORE INSERT ON `carritos_compras` FOR EACH ROW
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM usuarios_clientes
                   WHERE (idUsuario = new.idCliente)
    ))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El cliente ingresado no se encuentra registrado.',
      MYSQL_ERRNO = 1644;
    ELSEIF (NOT exists(SELECT 1
                       FROM menu_restaurantes
                       WHERE (id = new.idMenu)
    ))
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La entrada de menú ingresada no se encuentra registrada.',
        MYSQL_ERRNO = 1644;
    ELSEIF (exists(SELECT 1
                   FROM menu_restaurantes
                   WHERE (idCliente = new.idCliente) AND (idMenu = new.idMenu)
    ))
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El producto ingresado ya se encuentra asociado al carrito del cliente.',
        MYSQL_ERRNO = 1644;
    ELSEIF (new.cantidad <= 0)
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La cantidad ingresada no debe ser menor a uno.',
        MYSQL_ERRNO = 1644;
    END IF;
  END */;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
  /*!50003 CREATE */ /*!50017 DEFINER = CURRENT_USER */ /*!50003 TRIGGER `sistemarestaurantes`.`carritos_compras_BEFORE_DELETE` BEFORE DELETE ON `carritos_compras` FOR EACH ROW
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM usuarios_clientes
                   WHERE (idUsuario = old.idCliente)
    ))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El cliente ingresado no se encuentra registrado.',
      MYSQL_ERRNO = 1644;
    ELSEIF (NOT exists(SELECT 1
                       FROM menu_restaurantes
                       WHERE (id = old.idMenu)
    ))
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La entrada de menú ingresada no se encuentra registrada.',
        MYSQL_ERRNO = 1644;
    END IF;
  END */;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;

--
-- Table structure for table `categorias`
--

DROP TABLE IF EXISTS `categorias`;
/*!40101 SET @saved_cs_client = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `categorias` (
  `id`     INT(11)     NOT NULL AUTO_INCREMENT
  COMMENT 'Identificador autogenerado de la categoría de alimentos.',
  `nombre` VARCHAR(50) NOT NULL
  COMMENT 'Nombre de la categoría de alimentos.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre_UNIQUE` (`nombre`)
)
  ENGINE = InnoDB
  AUTO_INCREMENT = 14
  DEFAULT CHARSET = utf8
  COMMENT = 'Tabla con registro de categorías de alimentos/ingredientes.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categorias`
--

LOCK TABLES `categorias` WRITE;
/*!40000 ALTER TABLE `categorias` DISABLE KEYS */;
INSERT INTO `categorias`
VALUES (11, 'Barbacoa'), (4, 'Cerdo'), (6, 'Frutas'), (7, 'Granos'), (3, 'Pescado'), (2, 'Pollo'),
  (9, 'Repostería Dulce'), (10, 'Repostería Salada'), (1, 'Res'), (13, 'Salsas'), (12, 'Sopas'), (8, 'Tubérculos'),
  (5, 'Vegetales Verdes');
/*!40000 ALTER TABLE `categorias` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
  /*!50003 CREATE */ /*!50017 DEFINER = CURRENT_USER */ /*!50003 TRIGGER `sistemarestaurantes`.`categorias_BEFORE_INSERT` BEFORE INSERT ON `categorias` FOR EACH ROW
  BEGIN
    IF (exists(SELECT 1
               FROM categorias
               WHERE nombre = new.nombre))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'La categoría ingresada ya se encuentra registrada.',
      MYSQL_ERRNO = 1644;
    END IF;
  END */;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;

--
-- Table structure for table `categorias_ingredientes`
--

DROP TABLE IF EXISTS `categorias_ingredientes`;
/*!40101 SET @saved_cs_client = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `categorias_ingredientes` (
  `idIngrediente` INT(11) NOT NULL
  COMMENT 'Identificador del ingrediente.',
  `idCategoria`   INT(11) NOT NULL
  COMMENT 'Identificador de la categoría de alimentos.',
  PRIMARY KEY (`idIngrediente`),
  KEY `FK_CategoriasIngredientes_c_idx` (`idCategoria`),
  CONSTRAINT `FK_CategoriasIngredientes_c` FOREIGN KEY (`idCategoria`) REFERENCES `categorias` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK_CategoriasIngredientes_i` FOREIGN KEY (`idIngrediente`) REFERENCES `restaurantes` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
)
  ENGINE = InnoDB
  DEFAULT CHARSET = utf8
  COMMENT = 'Tabla para clasificar los ingredientes registrados con categorias de ingredientes.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categorias_ingredientes`
--

LOCK TABLES `categorias_ingredientes` WRITE;
/*!40000 ALTER TABLE `categorias_ingredientes` DISABLE KEYS */;
/*!40000 ALTER TABLE `categorias_ingredientes` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
  /*!50003 CREATE */ /*!50017 DEFINER = CURRENT_USER */ /*!50003 TRIGGER `sistemarestaurantes`.`categorias_ingredientes_BEFORE_INSERT` BEFORE INSERT ON `categorias_ingredientes` FOR EACH ROW
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM categorias
                   WHERE id = new.idCategoria
    ))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'La categoría seleccionada no se encuentra registrada.',
      MYSQL_ERRNO = 1644;
    ELSEIF (NOT exists(SELECT 1
                       FROM ingredientes
                       WHERE id = new.idIngrediente
    ))
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El ingrediente ingresado no se encuentra registrado.',
        MYSQL_ERRNO = 1644;
    ELSEIF (exists(SELECT 1
                   FROM categorias_ingredientes
                   WHERE (idIngrediente = new.idIngrediente)
    ))
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El ingrediente ingresado ya se encuentra clasificado.',
        MYSQL_ERRNO = 1644;
    END IF;
  END */;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
  /*!50003 CREATE */ /*!50017 DEFINER = CURRENT_USER */ /*!50003 TRIGGER `sistemarestaurantes`.`categorias_ingredientes_BEFORE_UPDATE` BEFORE UPDATE ON `categorias_ingredientes` FOR EACH ROW
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM categorias
                   WHERE id = new.idCategoria
    ))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'La categoría seleccionada no se encuentra registrada.',
      MYSQL_ERRNO = 1644;
    ELSEIF (NOT exists(SELECT 1
                       FROM ingredientes
                       WHERE id = new.idIngrediente
    ))
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El ingrediente ingresado no se encuentra registrado.',
        MYSQL_ERRNO = 1644;
    ELSEIF (exists(SELECT 1
                   FROM categorias_ingredientes
                   WHERE (idIngrediente = new.idIngrediente)
    ))
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El ingrediente ingresado ya se encuentra clasificado.',
        MYSQL_ERRNO = 1644;
    END IF;
  END */;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
  /*!50003 CREATE */ /*!50017 DEFINER = CURRENT_USER */ /*!50003 TRIGGER `sistemarestaurantes`.`categorias_ingredientes_AFTER_UPDATE` AFTER UPDATE ON `categorias_ingredientes` FOR EACH ROW
  BEGIN
    IF (old.idCategoria != new.idCategoria)
    THEN
      /* Borra los platillos de los menús de los restaurantes donde
        la categoría no está soportada */
      DELETE mr
      FROM menu_restaurantes mr
        INNER JOIN ingredientes_platillos ip
          ON ip.idPlatillo = mr.idPlatillo
        INNER JOIN categorias_ingredientes ci
          ON ip.idIngrediente = ci.idIngrediente
        LEFT JOIN categorias_ingredientes_restaurantes cr
          ON cr.idCategoria = ci.idCategoria
      WHERE (ci.idCategoria = new.idCategoria) AND (cr.idCategoria IS NULL);
    END IF;
  END;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;

--
-- Table structure for table `categorias_ingredientes_restaurantes`
--

DROP TABLE IF EXISTS `categorias_ingredientes_restaurantes`;
/*!40101 SET @saved_cs_client = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `categorias_ingredientes_restaurantes` (
  `idRestaurante` INT(11) NOT NULL
  COMMENT 'Identificador del restaurante.',
  `idCategoria`   INT(11) NOT NULL
  COMMENT 'Identificador de la categoría de comida que puede usar el restaurante.',
  PRIMARY KEY (`idRestaurante`, `idCategoria`),
  KEY `FK_CatIngRest_CatIng_idx` (`idCategoria`),
  CONSTRAINT `FK_CatIngRest_CatIng` FOREIGN KEY (`idCategoria`) REFERENCES `categorias` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK_CatIngRest_Rest` FOREIGN KEY (`idRestaurante`) REFERENCES `restaurantes` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
)
  ENGINE = InnoDB
  DEFAULT CHARSET = utf8
  COMMENT = 'Tabla que define los tipos de ingredientes que pueden servirse en los restaurantes.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categorias_ingredientes_restaurantes`
--

LOCK TABLES `categorias_ingredientes_restaurantes` WRITE;
/*!40000 ALTER TABLE `categorias_ingredientes_restaurantes` DISABLE KEYS */;
/*!40000 ALTER TABLE `categorias_ingredientes_restaurantes` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
  /*!50003 CREATE */ /*!50017 DEFINER = CURRENT_USER */ /*!50003 TRIGGER `sistemarestaurantes`.`categorias_ingredientes_restaurantes_BEFORE_INSERT` BEFORE INSERT ON `categorias_ingredientes_restaurantes` FOR EACH ROW
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM categorias
                   WHERE id = new.idCategoria
    ))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'La categoría seleccionada no se encuentra registrada.',
      MYSQL_ERRNO = 1644;
    ELSEIF (NOT exists(SELECT 1
                       FROM restaurantes
                       WHERE id = new.idRestaurante
    ))
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El restaurante ingresado no se encuentra registrado.',
        MYSQL_ERRNO = 1644;
    ELSEIF (exists(SELECT 1
                   FROM categorias_ingredientes_restaurantes
                   WHERE (idRestaurante = new.idRestaurante) AND (idCategoria = new.idCategoria)
    ))
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La categoría ingresada ya se encuentra asociada al restaurante.',
        MYSQL_ERRNO = 1644;
    END IF;
  END */;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
  /*!50003 CREATE */ /*!50017 DEFINER = CURRENT_USER */ /*!50003 TRIGGER `sistemarestaurantes`.`categorias_ingredientes_restaurantes_BEFORE_UPDATE` BEFORE UPDATE ON `categorias_ingredientes_restaurantes` FOR EACH ROW
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM categorias
                   WHERE id = new.idCategoria
    ))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'La categoría seleccionada no se encuentra registrada.',
      MYSQL_ERRNO = 1644;
    ELSEIF (NOT exists(SELECT 1
                       FROM restaurantes
                       WHERE id = new.idRestaurante
    ))
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El restaurante ingresado no se encuentra registrado.',
        MYSQL_ERRNO = 1644;
    ELSEIF (exists(SELECT 1
                   FROM categorias_ingredientes_restaurantes
                   WHERE (idRestaurante = new.idRestaurante) AND (idCategoria = new.idCategoria)
    ))
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La categoría ingresada ya se encuentra asociada al restaurante.',
        MYSQL_ERRNO = 1644;
    END IF;
  END */;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
  /*!50003 CREATE */ /*!50017 DEFINER = CURRENT_USER */ /*!50003 TRIGGER `sistemarestaurantes`.`categorias_ingredientes_restaurantes_AFTER_UPDATE` AFTER UPDATE ON `categorias_ingredientes_restaurantes` FOR EACH ROW
  BEGIN
    IF (old.idCategoria != new.idCategoria)
    THEN
      DELETE mr
      FROM menu_restaurantes mr
        INNER JOIN ingredientes_platillos ip
          ON (ip.idPlatillo = mr.idPlatillo)
        INNER JOIN categorias_ingredientes ci
          ON (ip.idIngrediente = ci.idIngrediente)
        LEFT JOIN categorias_ingredientes_restaurantes cr
          ON (ci.idCategoria = cr.idCategoria)
      WHERE (cr.idRestaurante = old.idRestaurante)
            AND (cr.idCategoria IS NULL);
    END IF;
  END */;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
  /*!50003 CREATE */ /*!50017 DEFINER = CURRENT_USER */ /*!50003 TRIGGER `sistemarestaurantes`.`categorias_ingredientes_restaurantes_AFTER_DELETE` AFTER DELETE ON `categorias_ingredientes_restaurantes` FOR EACH ROW
  BEGIN
    /* Borra los platillos de los menús de los restaurantes donde
        la categoría no está soportada */
    DELETE mr
    FROM menu_restaurantes mr
      INNER JOIN ingredientes_platillos ip
        ON (ip.idPlatillo = mr.idPlatillo)
      INNER JOIN categorias_ingredientes ci
        ON (ip.idIngrediente = ci.idIngrediente)
      INNER JOIN categorias_ingredientes_restaurantes cr
        ON (ci.idCategoria = cr.idCategoria)
    WHERE (cr.idRestaurante = old.idRestaurante)
          AND (cr.idCategoria = old.idCategoria);
  END;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;

--
-- Table structure for table `compras_efectivo_clientes`
--

DROP TABLE IF EXISTS `compras_efectivo_clientes`;
/*!40101 SET @saved_cs_client = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `compras_efectivo_clientes` (
  `idOrden`       INT(11)        NOT NULL,
  `montoRecibido` DECIMAL(20, 2) NOT NULL DEFAULT '0.00',
  `cambio`        DECIMAL(20, 2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`idOrden`),
  CONSTRAINT `FK_ComprasEfectivoClientes` FOREIGN KEY (`idOrden`) REFERENCES `ordenes_compra` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
)
  ENGINE = InnoDB
  DEFAULT CHARSET = utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `compras_efectivo_clientes`
--

LOCK TABLES `compras_efectivo_clientes` WRITE;
/*!40000 ALTER TABLE `compras_efectivo_clientes` DISABLE KEYS */;
/*!40000 ALTER TABLE `compras_efectivo_clientes` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
  /*!50003 CREATE */ /*!50017 DEFINER = CURRENT_USER */ /*!50003 TRIGGER `sistemarestaurantes`.`compras_efectivo_clientes_BEFORE_INSERT` BEFORE INSERT ON `compras_efectivo_clientes` FOR EACH ROW
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM ordenes_compra
                   WHERE id = new.idOrden
    ))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El número de orden ingresado no se encuentra registrado.',
      MYSQL_ERRNO = 1644;
    ELSEIF (exists(SELECT 1
                   FROM compras_efectivo_clientes
                   WHERE idOrden = new.idOrden
    ))
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La orden ingresada ya se encuentra cancelada.',
        MYSQL_ERRNO = 1644;
    ELSEIF (exists(SELECT 1
                   FROM compras_tarjeta_clientes
                   WHERE idOrden = new.idOrden
    ))
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La orden ingresada ya se encuentra cancelada con tarjeta.',
        MYSQL_ERRNO = 1644;
    ELSEIF (new.montoRecibido < (SELECT total
                                 FROM vt_costos_ordenes_compra
                                 WHERE idOrden = new.idOrden
    ))
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El monto recibido es menor al costo total de la orden.',
        MYSQL_ERRNO = 1644;
    END IF;
  END */;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;

--
-- Table structure for table `compras_tarjeta_clientes`
--

DROP TABLE IF EXISTS `compras_tarjeta_clientes`;
/*!40101 SET @saved_cs_client = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `compras_tarjeta_clientes` (
  `idOrden`            INT(11)        NOT NULL,
  `idEmisorTarjeta`    DECIMAL(2, 0) DEFAULT NULL,
  `numeroAutorizacion` DECIMAL(16, 0) NOT NULL,
  PRIMARY KEY (`idOrden`),
  KEY `FK_ComprasTarjetaClientes_t_idx` (`idEmisorTarjeta`),
  CONSTRAINT `FK_ComprasTarjetaClientes_t` FOREIGN KEY (`idEmisorTarjeta`) REFERENCES `emisores_tarjetas` (`id`)
    ON DELETE SET NULL
    ON UPDATE SET NULL
)
  ENGINE = InnoDB
  DEFAULT CHARSET = utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `compras_tarjeta_clientes`
--

LOCK TABLES `compras_tarjeta_clientes` WRITE;
/*!40000 ALTER TABLE `compras_tarjeta_clientes` DISABLE KEYS */;
/*!40000 ALTER TABLE `compras_tarjeta_clientes` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
  /*!50003 CREATE */ /*!50017 DEFINER = CURRENT_USER */ /*!50003 TRIGGER `sistemarestaurantes`.`compras_tarjeta_clientes_BEFORE_INSERT` BEFORE INSERT ON `compras_tarjeta_clientes` FOR EACH ROW
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM ordenes_compra
                   WHERE id = new.idOrden
    ))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El número de orden ingresado no se encuentra registrado.',
      MYSQL_ERRNO = 1644;
    ELSEIF (exists(SELECT 1
                   FROM emisores_tarjetas
                   WHERE id = new.idEmisorTarjeta
    ))
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El emisor de tarjetas ingresado no se encuentra registrado.',
        MYSQL_ERRNO = 1644;
    ELSEIF (exists(SELECT 1
                   FROM compras_tarjeta_clientes
                   WHERE idOrden = new.idOrden
    ))
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La orden ingresada ya se encuentra cancelada.',
        MYSQL_ERRNO = 1644;
    ELSEIF (exists(SELECT 1
                   FROM compras_efectivo_clientes
                   WHERE (idEmisorTarjeta = new.idEmisorTarjeta) AND (numeroAutorizacion = new.numeroAutorizacion)
    ))
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El número de autorización ingresado ya está en uso.',
        MYSQL_ERRNO = 1644;
    END IF;
  END */;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;

--
-- Table structure for table `descuentos_clientes_aplicados`
--

DROP TABLE IF EXISTS `descuentos_clientes_aplicados`;
/*!40101 SET @saved_cs_client = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `descuentos_clientes_aplicados` (
  `idOrden` INT(11) NOT NULL,
  PRIMARY KEY (`idOrden`),
  CONSTRAINT `FK_DescuentosClientesAplicados` FOREIGN KEY (`idOrden`) REFERENCES `ordenes_compra` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
)
  ENGINE = InnoDB
  DEFAULT CHARSET = utf8
  COMMENT = 'Registro de las órdenes de compra a las cuales se le aplica el descuento.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `descuentos_clientes_aplicados`
--

LOCK TABLES `descuentos_clientes_aplicados` WRITE;
/*!40000 ALTER TABLE `descuentos_clientes_aplicados` DISABLE KEYS */;
/*!40000 ALTER TABLE `descuentos_clientes_aplicados` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `emisores_tarjetas`
--

DROP TABLE IF EXISTS `emisores_tarjetas`;
/*!40101 SET @saved_cs_client = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emisores_tarjetas` (
  `id`     DECIMAL(2, 0) NOT NULL,
  `nombre` VARCHAR(30)   NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre_UNIQUE` (`nombre`)
)
  ENGINE = InnoDB
  DEFAULT CHARSET = utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emisores_tarjetas`
--

LOCK TABLES `emisores_tarjetas` WRITE;
/*!40000 ALTER TABLE `emisores_tarjetas` DISABLE KEYS */;
INSERT INTO `emisores_tarjetas`
VALUES (4, 'American Express'), (5, 'Dinner´s Club'), (2, 'MasterCard'), (1, 'N/A'), (3, 'VISA');
/*!40000 ALTER TABLE `emisores_tarjetas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ingredientes`
--

DROP TABLE IF EXISTS `ingredientes`;
/*!40101 SET @saved_cs_client = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ingredientes` (
  `id`           INT(11)       NOT NULL AUTO_INCREMENT
  COMMENT 'Identificador del restaurante',
  `nombre`       VARCHAR(50)   NOT NULL
  COMMENT 'Nombre del restaurante',
  `precioUnidad` DECIMAL(8, 2) NOT NULL DEFAULT '100.00'
  COMMENT 'Precio por unidad (cantidad: 1.00) del ingrediente seleccionado.',
  `urlFoto`      VARCHAR(200)           DEFAULT NULL
  COMMENT 'URL de la foto del ingrediente. La URL debe ser de un sitio web, ya sea del sitio web donde corre el programa o un sitio web externo.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre_UNIQUE` (`nombre`)
)
  ENGINE = InnoDB
  DEFAULT CHARSET = utf8
  COMMENT = 'Tabla con el registro de ingredientes.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ingredientes`
--

LOCK TABLES `ingredientes` WRITE;
/*!40000 ALTER TABLE `ingredientes` DISABLE KEYS */;
/*!40000 ALTER TABLE `ingredientes` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
  /*!50003 CREATE */ /*!50017 DEFINER = CURRENT_USER */ /*!50003 TRIGGER `sistemarestaurantes`.`ingredientes_BEFORE_INSERT` BEFORE INSERT ON `ingredientes` FOR EACH ROW
  BEGIN
    IF (exists(SELECT 1
               FROM ingredientes
               WHERE nombre = new.nombre))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El ingrediente ingresado ya se encuentra registrado.',
      MYSQL_ERRNO = 1644;

    ELSEIF (new.precioUnidad <= 0)
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El precio por unidad del ingrediente no puede ser menor o igual a cero.',
        MYSQL_ERRNO = 1644;
    END IF;
  END */;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
  /*!50003 CREATE */ /*!50017 DEFINER = CURRENT_USER */ /*!50003 TRIGGER `sistemarestaurantes`.`ingredientes_BEFORE_UPDATE` BEFORE UPDATE ON `ingredientes` FOR EACH ROW
  BEGIN
    IF (exists(SELECT 1
               FROM ingredientes
               WHERE nombre = new.nombre))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El ingrediente ingresado ya se encuentra registrado.',
      MYSQL_ERRNO = 1644;

    ELSEIF (new.precioUnidad <= 0)
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El precio por unidad del ingrediente no puede ser menor o igual a cero.',
        MYSQL_ERRNO = 1644;
    END IF;
  END */;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;

--
-- Table structure for table `ingredientes_platillos`
--

DROP TABLE IF EXISTS `ingredientes_platillos`;
/*!40101 SET @saved_cs_client = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ingredientes_platillos` (
  `idPlatillo`          INT(11)        NOT NULL
  COMMENT 'Identificador del platillo.',
  `idIngrediente`       INT(11)        NOT NULL
  COMMENT 'Identificador del ingrediente del platillo.',
  `cantidadIngrediente` DECIMAL(10, 3) NOT NULL DEFAULT '1.000'
  COMMENT 'Cantidad del ingrediente necesaria para el platillo.',
  PRIMARY KEY (`idPlatillo`, `idIngrediente`),
  KEY `FK_IngredientesPlatillos_i_idx` (`idIngrediente`),
  CONSTRAINT `FK_IngredientesPlatillos_i` FOREIGN KEY (`idIngrediente`) REFERENCES `ingredientes` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK_IngredientesPlatillos_p` FOREIGN KEY (`idPlatillo`) REFERENCES `platillos` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
)
  ENGINE = InnoDB
  DEFAULT CHARSET = utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ingredientes_platillos`
--

LOCK TABLES `ingredientes_platillos` WRITE;
/*!40000 ALTER TABLE `ingredientes_platillos` DISABLE KEYS */;
/*!40000 ALTER TABLE `ingredientes_platillos` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
  /*!50003 CREATE */ /*!50017 DEFINER = CURRENT_USER */ /*!50003 TRIGGER `sistemarestaurantes`.`ingredientes_platillos_BEFORE_INSERT` BEFORE INSERT ON `ingredientes_platillos` FOR EACH ROW
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM ingredientes
                   WHERE id = new.idIngrediente))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El ingrediente ingresado no se encuentra registrado.',
      MYSQL_ERRNO = 1644;

    ELSEIF (NOT exists(SELECT 1
                       FROM platillos
                       WHERE id = new.idPlatillo))
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El platillo ingresado no se encuentra registrado.',
        MYSQL_ERRNO = 1644;
    ELSEIF (NOT exists(SELECT 1
                       FROM categorias_ingredientes
                       WHERE (idIngrediente = new.idIngrediente)
    ))
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El ingrediente ingresado no tiene clasificación.',
        MYSQL_ERRNO = 1644;

    ELSEIF (exists(SELECT 1
                   FROM ingredientes_platillos
                   WHERE (idPlatillo = new.idPlatillo) AND (idIngrediente = new.idIngrediente)
    ))
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El ingrediente ingresado ya forma parte de este platillo.',
        MYSQL_ERRNO = 1644;
    END IF;
  END */;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
  /*!50003 CREATE */ /*!50017 DEFINER = CURRENT_USER */ /*!50003 TRIGGER `sistemarestaurantes`.`ingredientes_platillos_AFTER_INSERT` AFTER INSERT ON `ingredientes_platillos` FOR EACH ROW
  BEGIN
    DELETE mr
    FROM menu_restaurantes mr
      INNER JOIN ingredientes_platillos ip
        ON ip.idPlatillo = mr.idPlatillo
      INNER JOIN categorias_ingredientes ci
        ON ip.idIngrediente = ci.idIngrediente
      LEFT JOIN inventario_restaurantes ir
        ON ip.idIngrediente = ir.idIngrediente
      LEFT JOIN categorias_ingredientes_restaurantes cr
        ON cr.idCategoria = ci.idCategoria
    WHERE (ip.idPlatillo = new.idPlatillo)
          AND (ip.idIngrediente = new.idIngrediente)
          AND ((cr.idCategoria IS NULL) OR (ir.idIngrediente IS NULL));
  END */;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;

--
-- Table structure for table `inventario_restaurantes`
--

DROP TABLE IF EXISTS `inventario_restaurantes`;
/*!40101 SET @saved_cs_client = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `inventario_restaurantes` (
  `idRestaurante`      INT(11)        NOT NULL
  COMMENT 'Identificador del restaurante asociado.',
  `idIngrediente`      INT(11)        NOT NULL
  COMMENT 'Identificador del ingrediente asociado al restaurante.',
  `cantidadDisponible` DECIMAL(13, 3) NOT NULL DEFAULT '0.000'
  COMMENT 'Cantidad disponible del ingrediente asociado.',
  PRIMARY KEY (`idRestaurante`, `idIngrediente`),
  KEY `FK_InventarioRestuarantes_i_idx` (`idIngrediente`),
  CONSTRAINT `FK_InventarioRestaurantes_r` FOREIGN KEY (`idRestaurante`) REFERENCES `restaurantes` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK_InventarioRestuarantes_i` FOREIGN KEY (`idIngrediente`) REFERENCES `ingredientes` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
)
  ENGINE = InnoDB
  DEFAULT CHARSET = utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventario_restaurantes`
--

LOCK TABLES `inventario_restaurantes` WRITE;
/*!40000 ALTER TABLE `inventario_restaurantes` DISABLE KEYS */;
/*!40000 ALTER TABLE `inventario_restaurantes` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
  /*!50003 CREATE */ /*!50017 DEFINER = CURRENT_USER */ /*!50003 TRIGGER `sistemarestaurantes`.`inventario_restaurantes_BEFORE_INSERT` BEFORE INSERT ON `inventario_restaurantes` FOR EACH ROW
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM restaurantes
                   WHERE id = new.idRestaurante))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El restaurante ingresado no se encuentra registrado.',
      MYSQL_ERRNO = 1644;

    ELSEIF (NOT exists(SELECT 1
                       FROM ingredientes
                       WHERE id = new.idIngrediente))
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El ingrediente ingresado no se encuentra registrado.',
        MYSQL_ERRNO = 1644;
    ELSEIF (NOT exists(SELECT 1
                       FROM categorias_ingredientes_restaurantes cir
                         INNER JOIN categorias_ingredientes ci
                           ON ci.idCategoria = cir.idCategoria
                         INNER JOIN restaurantes r
                           ON r.id = cir.idRestaurante
                       WHERE (cir.idRestaurante = new.idRestaurante) AND (ci.idIngrediente = new.idIngrediente)
    ))
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El ingrediente ingresado no forma parte de las categorías registradas para el restaurante.',
        MYSQL_ERRNO = 1644;
    ELSEIF (exists(SELECT 1
                   FROM inventario_restaurantes
                   WHERE (idRestaurante = new.idRestaurante) AND (idIngrediente = new.idIngrediente)
    ))
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El ingrediente ingresado ya forma parte del inventario del restaurante seleccionado.',
        MYSQL_ERRNO = 1644;
    END IF;
  END */;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;

--
-- Table structure for table `menu_restaurantes`
--

DROP TABLE IF EXISTS `menu_restaurantes`;
/*!40101 SET @saved_cs_client = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `menu_restaurantes` (
  `id`            INT(11) NOT NULL AUTO_INCREMENT,
  `idRestaurante` INT(11) NOT NULL,
  `idPlatillo`    INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_MenuRestaurantes` (`idRestaurante`, `idPlatillo`),
  KEY `FK_MenuRestaurantes_p_idx` (`idPlatillo`),
  CONSTRAINT `FK_MenuRestaurantes_p` FOREIGN KEY (`idPlatillo`) REFERENCES `platillos` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK_MenuRestaurantes_r` FOREIGN KEY (`idRestaurante`) REFERENCES `restaurantes` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
)
  ENGINE = InnoDB
  DEFAULT CHARSET = utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `menu_restaurantes`
--

LOCK TABLES `menu_restaurantes` WRITE;
/*!40000 ALTER TABLE `menu_restaurantes` DISABLE KEYS */;
/*!40000 ALTER TABLE `menu_restaurantes` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
  /*!50003 CREATE */ /*!50017 DEFINER = CURRENT_USER */ /*!50003 TRIGGER `sistemarestaurantes`.`menu_restaurantes_BEFORE_INSERT` BEFORE INSERT ON `menu_restaurantes` FOR EACH ROW
  BEGIN
    -- El restaurante debe estar registrado.
    IF (NOT exists(SELECT 1
                   FROM restaurantes
                   WHERE id = new.idRestaurante))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El restaurante ingresado no se encuentra registrado.',
      MYSQL_ERRNO = 1644;
    -- El platillo debe estar registrado.
    ELSEIF (NOT exists(SELECT 1
                       FROM platillos
                       WHERE id = new.idPlatillo))
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El platillo ingresado no se encuentra registrado.',
        MYSQL_ERRNO = 1644;
    -- El platillo debe contener ingredientes de una categoría aceptada para el restaurante.
    ELSEIF (NOT exists(SELECT 1
                       FROM ingredientes_platillos ip
                         INNER JOIN categorias_ingredientes ci
                           ON ci.idIngrediente = ip.idIngrediente
                         INNER JOIN categorias_ingredientes_restaurantes cr
                           ON (ci.idCategoria = cr.idCategoria)
                       WHERE (ip.idPlatillo = new.idPlatillo)
                             AND (cr.idRestaurante = new.idRestaurante)
    ))
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El platillo ingresado tiene ingredientes que no son utilizados por el restaurante seleccionado.',
        MYSQL_ERRNO = 1644;

    -- El platillo contiene ingredientes que no están en el inventario del restaurante
    ELSEIF (NOT exists(SELECT 1
                       FROM ingredientes_platillos ip
                         INNER JOIN inventario_restaurantes ir
                           ON ip.idIngrediente = ir.idIngrediente
                       WHERE (ip.idPlatillo = new.idPlatillo) AND (ir.idRestaurante = new.idRestaurante)
    ))
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El platillo ingresado tiene ingredientes que no forma parte del inventario del restaurante.',
        MYSQL_ERRNO = 1644;

    -- El platillo no debe haber sido registrado antes.
    ELSEIF (exists(SELECT 1
                   FROM menu_restaurantes
                   WHERE (idRestaurante = new.idRestaurante) AND (idPlatillo = new.idPlatillo)
    ))
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El platillo ingresado ya forma parte del menú del restaurante seleccionado.',
        MYSQL_ERRNO = 1644;
    END IF;
  END */;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;

--
-- Table structure for table `ordenes_compra`
--

DROP TABLE IF EXISTS `ordenes_compra`;
/*!40101 SET @saved_cs_client = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ordenes_compra` (
  `id`            INT(11) NOT NULL,
  `idCliente`     INT(11) DEFAULT NULL,
  `idRestaurante` INT(11) DEFAULT NULL,
  `fechaFactura`  INT(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_OrdenesCompra_r_idx` (`idRestaurante`),
  KEY `FK_OrdenesCompra_c` (`idCliente`),
  CONSTRAINT `FK_OrdenesCompra_c` FOREIGN KEY (`idCliente`) REFERENCES `usuarios_clientes` (`idUsuario`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `FK_OrdenesCompra_r` FOREIGN KEY (`idRestaurante`) REFERENCES `restaurantes` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE
)
  ENGINE = InnoDB
  DEFAULT CHARSET = utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ordenes_compra`
--

LOCK TABLES `ordenes_compra` WRITE;
/*!40000 ALTER TABLE `ordenes_compra` DISABLE KEYS */;
/*!40000 ALTER TABLE `ordenes_compra` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
  /*!50003 CREATE */ /*!50017 DEFINER = CURRENT_USER */ /*!50003 TRIGGER `sistemarestaurantes`.`ordenes_compra_BEFORE_INSERT` BEFORE INSERT ON `ordenes_compra` FOR EACH ROW
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM usuarios_clientes
                   WHERE idUsuario = new.idCliente
    ))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El cliente ingresado no se encuentra registrado.',
      MYSQL_ERRNO = 1644;
    ELSEIF (NOT exists(SELECT 1
                       FROM restaurantes
                       WHERE id = new.idRestaurante
    ))
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El restaurante ingresado no se encuentra registrado.',
        MYSQL_ERRNO = 1644;
    ELSEIF (isnull(fechaFactura))
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Debe ingresar la fecha de registro.',
        MYSQL_ERRNO = 1644;
    END IF;
  END */;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;

--
-- Table structure for table `platillos`
--

DROP TABLE IF EXISTS `platillos`;
/*!40101 SET @saved_cs_client = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `platillos` (
  `id`     INT(11)     NOT NULL AUTO_INCREMENT
  COMMENT 'Identificador autogenerado del platillo.',
  `nombre` VARCHAR(45) NOT NULL
  COMMENT 'Nombre del platillo.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `Platilloscol_UNIQUE` (`nombre`)
)
  ENGINE = InnoDB
  DEFAULT CHARSET = utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `platillos`
--

LOCK TABLES `platillos` WRITE;
/*!40000 ALTER TABLE `platillos` DISABLE KEYS */;
/*!40000 ALTER TABLE `platillos` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
  /*!50003 CREATE */ /*!50017 DEFINER = CURRENT_USER */ /*!50003 TRIGGER `sistemarestaurantes`.`platillos_BEFORE_INSERT` BEFORE INSERT ON `platillos` FOR EACH ROW
  BEGIN
    IF (exists(SELECT 1
               FROM platillos
               WHERE nombre = new.nombre
    ))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El platillo ingresado ya se encuentra registrado.',
      MYSQL_ERRNO = 1644;
    END IF;
  END */;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;

--
-- Table structure for table `platillos_ordenes_compra`
--

DROP TABLE IF EXISTS `platillos_ordenes_compra`;
/*!40101 SET @saved_cs_client = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `platillos_ordenes_compra` (
  `idOrden`      INT(11)        NOT NULL,
  `idPlatillo`   INT(11)        NOT NULL,
  `cantidad`     DECIMAL(13, 3) NOT NULL DEFAULT '1.000',
  `precioUnidad` DECIMAL(8, 2)  NOT NULL DEFAULT '0.00',
  `descuento`    DECIMAL(3, 0)  NOT NULL DEFAULT '0',
  `totalDetalle` DECIMAL(20, 2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`idOrden`),
  UNIQUE KEY `UK_PlatillosOrdenesCompra` (`idOrden`, `idPlatillo`),
  KEY `FK_PlatillosOrdenesCompra_p_idx` (`idPlatillo`),
  CONSTRAINT `FK_PlatillosOrdenesCompra_o` FOREIGN KEY (`idOrden`) REFERENCES `ordenes_compra` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK_PlatillosOrdenesCompra_p` FOREIGN KEY (`idPlatillo`) REFERENCES `platillos` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
)
  ENGINE = InnoDB
  DEFAULT CHARSET = utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `platillos_ordenes_compra`
--

LOCK TABLES `platillos_ordenes_compra` WRITE;
/*!40000 ALTER TABLE `platillos_ordenes_compra` DISABLE KEYS */;
/*!40000 ALTER TABLE `platillos_ordenes_compra` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
  /*!50003 CREATE */ /*!50017 DEFINER = CURRENT_USER */ /*!50003 TRIGGER `sistemarestaurantes`.`platillos_ordenes_compra_BEFORE_INSERT` BEFORE INSERT ON `platillos_ordenes_compra` FOR EACH ROW
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM ordenes_compra
                   WHERE id = new.idOrden
    ))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El número de orden de compra ingresado no se encuentra registrado.',
      MYSQL_ERRNO = 1644;
    ELSEIF (NOT exists(SELECT 1
                       FROM platillos
                       WHERE id = new.idPlatillo
    ))
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El platillo ingresado no se encuentra registrado.',
        MYSQL_ERRNO = 1644;
    ELSEIF (exists(SELECT 1
                   FROM platillos_ordenes_compra
                   WHERE (idOrden = new.idOrden) AND (idPlatillo = new.idPlatillo)
    ))
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El platillo ingresado ya forma parte del pedido.',
        MYSQL_ERRNO = 1644;
    ELSEIF (new.cantidad <= 0)
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La cantidad ingresada debe ser mayor que cero.',
        MYSQL_ERRNO = 1644;
    END IF;
  END */;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;

--
-- Table structure for table `restaurantes`
--

DROP TABLE IF EXISTS `restaurantes`;
/*!40101 SET @saved_cs_client = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `restaurantes` (
  `id`          INT(11)      NOT NULL AUTO_INCREMENT
  COMMENT 'Identificador autogenerado del restaurante.',
  `nombre`      VARCHAR(50)  NOT NULL
  COMMENT 'Nombre del restaurante.',
  `direccion`   VARCHAR(200) NOT NULL
  COMMENT 'Dirección del restaurante.',
  `idCategoria` INT(11)               DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre_UNIQUE` (`nombre`),
  KEY `FK_Restaurantes_idx` (`idCategoria`),
  CONSTRAINT `FK_Restaurantes` FOREIGN KEY (`idCategoria`) REFERENCES `categorias` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE
)
  ENGINE = InnoDB
  AUTO_INCREMENT = 2
  DEFAULT CHARSET = utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `restaurantes`
--

LOCK TABLES `restaurantes` WRITE;
/*!40000 ALTER TABLE `restaurantes` DISABLE KEYS */;
INSERT INTO `restaurantes` VALUES (1, 'Restaurante1', 'abc1234', 1);
/*!40000 ALTER TABLE `restaurantes` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
  /*!50003 CREATE */ /*!50017 DEFINER = CURRENT_USER */ /*!50003 TRIGGER `sistemarestaurantes`.`restaurantes_BEFORE_INSERT` BEFORE INSERT ON `restaurantes` FOR EACH ROW
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM categorias
                   WHERE id = new.idCategoria))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'La categoría ingresada no se encuentra registrada.',
      MYSQL_ERRNO = 1644;
    ELSEIF (exists(SELECT 1
                   FROM restaurantes
                   WHERE nombre = new.nombre))
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El restaurante ingresado ya se encuentra registrado.',
        MYSQL_ERRNO = 1644;
    END IF;
  END */;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usuarios` (
  `id`        INT(11)      NOT NULL AUTO_INCREMENT,
  `eMail`     VARCHAR(50)  NOT NULL,
  `nombre`    VARCHAR(30)  NOT NULL,
  `apellidos` VARCHAR(100) NOT NULL,
  `pwd`       VARCHAR(20)  NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_Usuarios` (`eMail`)
)
  ENGINE = InnoDB
  AUTO_INCREMENT = 3
  DEFAULT CHARSET = utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT INTO `usuarios`
VALUES (1, 'hola1@abc.com', 'Hola', 'Mundo', 'abc123'), (2, 'cyka@blyat.ru', 'ayy', 'lmao', 'pwd123');
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
  /*!50003 CREATE */ /*!50017 DEFINER = CURRENT_USER */ /*!50003 TRIGGER `sistemarestaurantes`.`usuarios_BEFORE_INSERT` BEFORE INSERT ON `usuarios` FOR EACH ROW
  BEGIN
    IF (exists(SELECT 1
               FROM usuarios
               WHERE eMail = new.eMail))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El e-mail ingresado ya se encuentra registrado.',
      MYSQL_ERRNO = 1644;
    END IF;
  END */;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
  /*!50003 CREATE */ /*!50017 DEFINER = CURRENT_USER */ /*!50003 TRIGGER `sistemarestaurantes`.`usuarios_BEFORE_UPDATE` BEFORE UPDATE ON `usuarios` FOR EACH ROW
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM usuarios
                   WHERE eMail = new.eMail))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El e-mail ingresado no se encuentra registrado.',
      MYSQL_ERRNO = 1644;
    END IF;
  END */;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;

--
-- Table structure for table `usuarios_administradores`
--

DROP TABLE IF EXISTS `usuarios_administradores`;
/*!40101 SET @saved_cs_client = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usuarios_administradores` (
  `idUsuario` INT(11) NOT NULL,
  PRIMARY KEY (`idUsuario`),
  CONSTRAINT `FK_UsuariosAdministradores_u` FOREIGN KEY (`idUsuario`) REFERENCES `usuarios` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
)
  ENGINE = InnoDB
  DEFAULT CHARSET = utf8
  COMMENT = 'Tabla para registrar los usuarios administradores asignados a cada restaurante.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios_administradores`
--

LOCK TABLES `usuarios_administradores` WRITE;
/*!40000 ALTER TABLE `usuarios_administradores` DISABLE KEYS */;
INSERT INTO `usuarios_administradores` VALUES (2);
/*!40000 ALTER TABLE `usuarios_administradores` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
  /*!50003 CREATE */ /*!50017 DEFINER = CURRENT_USER */ /*!50003 TRIGGER `sistemarestaurantes`.`usuarios_administradores_BEFORE_INSERT` BEFORE INSERT ON `usuarios_administradores` FOR EACH ROW
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM usuarios
                   WHERE id = new.idUsuario
    ))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El usuario ingresado no se encuentra registrado.',
      MYSQL_ERRNO = 1644;
    ELSEIF (exists(SELECT 1
                   FROM usuarios_clientes
                   WHERE idUsuario = new.idUsuario
    ))
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El usuario registrado ya es un cliente.',
        MYSQL_ERRNO = 1644;
    ELSEIF (exists(SELECT 1
                   FROM usuarios_administradores
                   WHERE idUsuario = new.idUsuario
    ))
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El usuario registrado ya es un administrador.',
        MYSQL_ERRNO = 1644;
    END IF;
  END */;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
  /*!50003 CREATE */ /*!50017 DEFINER = CURRENT_USER */ /*!50003 TRIGGER `sistemarestaurantes`.`usuarios_administradores_BEFORE_UPDATE` BEFORE UPDATE ON `usuarios_administradores` FOR EACH ROW
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM usuarios
                   WHERE id = new.idUsuario
    ))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El usuario ingresado no se encuentra registrado.',
      MYSQL_ERRNO = 1644;
    ELSEIF (exists(SELECT 1
                   FROM usuarios_clientes
                   WHERE idUsuario = new.idUsuario
    ))
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El usuario ingresado no es un administrador.',
        MYSQL_ERRNO = 1644;
    END IF;
  END */;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;

--
-- Table structure for table `usuarios_clientes`
--

DROP TABLE IF EXISTS `usuarios_clientes`;
/*!40101 SET @saved_cs_client = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usuarios_clientes` (
  `idUsuario`      INT(11)       NOT NULL,
  `numeroTelefono` DECIMAL(8, 0) NOT NULL,
  PRIMARY KEY (`idUsuario`),
  CONSTRAINT `FK_UsuariosClientes` FOREIGN KEY (`idUsuario`) REFERENCES `usuarios` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
)
  ENGINE = InnoDB
  DEFAULT CHARSET = utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios_clientes`
--

LOCK TABLES `usuarios_clientes` WRITE;
/*!40000 ALTER TABLE `usuarios_clientes` DISABLE KEYS */;
INSERT INTO `usuarios_clientes` VALUES (1, 12345678);
/*!40000 ALTER TABLE `usuarios_clientes` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
  /*!50003 CREATE */ /*!50017 DEFINER = CURRENT_USER */ /*!50003 TRIGGER `sistemarestaurantes`.`usuarios_clientes_BEFORE_INSERT` BEFORE INSERT ON `usuarios_clientes` FOR EACH ROW
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM usuarios
                   WHERE id = new.idUsuario
    ))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El usuario ingresado no se encuentra registrado.',
      MYSQL_ERRNO = 1644;
    ELSEIF (exists(SELECT 1
                   FROM usuarios_administradores
                   WHERE idUsuario = new.idUsuario
    ))
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El usuario registrado ya es un administrador.',
        MYSQL_ERRNO = 1644;
    ELSEIF (exists(SELECT 1
                   FROM usuarios_clientes
                   WHERE idUsuario = new.idUsuario
    ))
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El usuario registrado ya es un cliente.',
        MYSQL_ERRNO = 1644;
    END IF;
  END */;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
  /*!50003 CREATE */ /*!50017 DEFINER = CURRENT_USER */ /*!50003 TRIGGER `sistemarestaurantes`.`usuarios_clientes_BEFORE_UPDATE` BEFORE UPDATE ON `usuarios_clientes` FOR EACH ROW
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM usuarios
                   WHERE id = new.idUsuario
    ))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El usuario ingresado no se encuentra registrado.',
      MYSQL_ERRNO = 1644;
    ELSEIF (exists(SELECT 1
                   FROM usuarios_administradores
                   WHERE idUsuario = new.idUsuario
    ))
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El usuario ingresado no es un cliente.',
        MYSQL_ERRNO = 1644;
    END IF;
  END */;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;

--
-- Temporary view structure for view `vt_carritos_compras_clientes`
--

DROP TABLE IF EXISTS `vt_carritos_compras_clientes`;
/*!50001 DROP VIEW IF EXISTS `vt_carritos_compras_clientes`*/;
SET @saved_cs_client = @@character_set_client;
SET character_set_client = utf8;
  /*!50001 CREATE VIEW `vt_carritos_compras_clientes` AS
  SELECT
    1 AS `idCliente`,
    1 AS `idRestaurante`,
    1 AS `idPlatillo`,
    1 AS `idMenu`,
    1 AS `cantidad`,
    1 AS `nombrePlatillo`,
    1 AS `precioUnidadTarjeta`,
    1 AS `precioUnidadEfectivo`,
    1 AS `precioTarjetaDetalle`,
    1 AS `precioEfectivoDetalle`,
    1 AS `descuentoEfectivoDetalle`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vt_clientes_con_descuentos`
--

DROP TABLE IF EXISTS `vt_clientes_con_descuentos`;
/*!50001 DROP VIEW IF EXISTS `vt_clientes_con_descuentos`*/;
SET @saved_cs_client = @@character_set_client;
SET character_set_client = utf8;
  /*!50001 CREATE VIEW `vt_clientes_con_descuentos` AS
  SELECT
    1 AS `IdCliente`,
    1 AS `IdRestaurante`,
    1 AS `AcumuladoCompras`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vt_costos_ingredientes_platillos`
--

DROP TABLE IF EXISTS `vt_costos_ingredientes_platillos`;
/*!50001 DROP VIEW IF EXISTS `vt_costos_ingredientes_platillos`*/;
SET @saved_cs_client = @@character_set_client;
SET character_set_client = utf8;
  /*!50001 CREATE VIEW `vt_costos_ingredientes_platillos` AS
  SELECT
    1 AS `idPlatillo`,
    1 AS `idIngrediente`,
    1 AS `NombrePlatillo`,
    1 AS `NombreIngrediente`,
    1 AS `Cantidad`,
    1 AS `precioIngrediente`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vt_costos_ordenes_compra`
--

DROP TABLE IF EXISTS `vt_costos_ordenes_compra`;
/*!50001 DROP VIEW IF EXISTS `vt_costos_ordenes_compra`*/;
SET @saved_cs_client = @@character_set_client;
SET character_set_client = utf8;
  /*!50001 CREATE VIEW `vt_costos_ordenes_compra` AS
  SELECT
    1 AS `idOrden`,
    1 AS `idCliente`,
    1 AS `idRestaurante`,
    1 AS `nombreCliente`,
    1 AS `nombreRestaurante`,
    1 AS `fechaFactura`,
    1 AS `subTotal`,
    1 AS `descuento`,
    1 AS `total`,
    1 AS `ganancias`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vt_costos_platillos`
--

DROP TABLE IF EXISTS `vt_costos_platillos`;
/*!50001 DROP VIEW IF EXISTS `vt_costos_platillos`*/;
SET @saved_cs_client = @@character_set_client;
SET character_set_client = utf8;
  /*!50001 CREATE VIEW `vt_costos_platillos` AS
  SELECT
    1 AS `idPlatillo`,
    1 AS `nombrePlatillo`,
    1 AS `precioBase`,
    1 AS `gananciaTarjeta`,
    1 AS `gananciaEfectivo`,
    1 AS `precioTarjeta`,
    1 AS `precioEfectivo`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vt_info_restaurantes`
--

DROP TABLE IF EXISTS `vt_info_restaurantes`;
/*!50001 DROP VIEW IF EXISTS `vt_info_restaurantes`*/;
SET @saved_cs_client = @@character_set_client;
SET character_set_client = utf8;
  /*!50001 CREATE VIEW `vt_info_restaurantes` AS
  SELECT
    1 AS `idRestaurante`,
    1 AS `idCategoria`,
    1 AS `nombreRestaurante`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vt_reportes_diarios_ganancias`
--

DROP TABLE IF EXISTS `vt_reportes_diarios_ganancias`;
/*!50001 DROP VIEW IF EXISTS `vt_reportes_diarios_ganancias`*/;
SET @saved_cs_client = @@character_set_client;
SET character_set_client = utf8;
  /*!50001 CREATE VIEW `vt_reportes_diarios_ganancias` AS
  SELECT
    1 AS `idRestaurante`,
    1 AS `nombreRestaurante`,
    1 AS `fechaConsultada`,
    1 AS `cantidadOrdenes`,
    1 AS `totalOrdenes`,
    1 AS `gananciasOrdenes`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping routines for database 'sistemarestaurantes'
--
/*!50003 DROP PROCEDURE IF EXISTS `sp_agregarCategoria` */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
CREATE DEFINER = CURRENT_USER PROCEDURE `sp_agregarCategoria`(IN p_idAdmin INT, IN p_nombre NVARCHAR(50))
  COMMENT 'Crea una nueva categoría de alimentos.'
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM usuarios_administradores
                   WHERE idUsuario = p_idAdmin
    ))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El usuario registrado no existe o no tiene autorización para esta operación.',
      MYSQL_ERRNO = 1644;
    ELSE
      BEGIN
        DECLARE idObtenido INT;
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
          ROLLBACK;
          RESIGNAL;
        END;
        START TRANSACTION;
        INSERT INTO categorias (nombre)
        VALUES (p_nombre);
        SET idObtenido = (SELECT last_insert_id());

        INSERT INTO bitacora_cambios (fechaHora, idUsuario, detalles)
          SELECT
            now(),
            u.id,
            concat('El administrador ', u.nombre, ' ', u.apellidos, ' ha creado el restaurante ',
                   r.nombre, '.')
          FROM usuarios u, restaurantes r
          WHERE (u.id = p_idAdmin) AND r.id = idObtenido;
        COMMIT;

        SELECT
          id,
          nombre
        FROM categorias
        WHERE id = idObtenido;
      END;
    END IF;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 DROP PROCEDURE IF EXISTS `sp_agregarCategoriaAdmitidaEnRestaurante` */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
CREATE DEFINER = CURRENT_USER PROCEDURE `sp_agregarCategoriaAdmitidaEnRestaurante`(IN p_idAdmin       INT,
                                                                                   IN p_idRestaurante INT,
                                                                                   IN p_idCategoria   INT)
  COMMENT 'Agrega una categoría de alimentos a la lista de categorías que administra un restaurante.'
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM usuarios_administradores
                   WHERE idUsuario = p_idAdmin
    ))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El usuario registrado no existe o no tiene autorización para esta operación.',
      MYSQL_ERRNO = 1644;
    ELSE
      BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
          ROLLBACK;
          RESIGNAL;
        END;

        START TRANSACTION;
        INSERT INTO categorias_ingredientes_restaurantes (idRestaurante, idCategoria)
        VALUES (p_idRestaurante, p_idCategoria);

        INSERT INTO bitacora_cambios (fechaHora, idUsuario, detalles)
          SELECT
            now(),
            p_idAdmin,
            concat('El administrador ', u.nombre, ' ', u.apellidos,
                   'agregó la categoría \"', c.nombre,
                   '\" a la lista de categorías aceptadas por el restaurante ', r.nombre, '.')
          FROM usuarios u, categorias c, restaurantes r
          WHERE (u.id = p_idAdmin) AND (c.id = p_idCategoria) AND (r.id = p_idRestaurante);
        COMMIT;
      END;
    END IF;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 DROP PROCEDURE IF EXISTS `sp_agregarCategoriaAIngrediente` */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
CREATE DEFINER = CURRENT_USER PROCEDURE `sp_agregarCategoriaAIngrediente`(IN p_idIngrediente INT, IN p_idCategoria INT)
  COMMENT 'Clasifica el ingrediente ingresado a la categoría ingresada.'
  BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      ROLLBACK;
      RESIGNAL;
    END;
    START TRANSACTION;
    INSERT INTO categorias_ingredientes (idIngrediente, idCategoria)
    VALUES (p_idIngrediente, p_idCategoria);
    COMMIT;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 DROP PROCEDURE IF EXISTS `sp_agregarDetalleMenuACarrito` */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
CREATE DEFINER = CURRENT_USER PROCEDURE `sp_agregarDetalleMenuACarrito`(IN p_idAdmin INT, IN p_idCliente INT,
                                                                        IN p_idMenu  INT, IN p_cantidad INT)
  COMMENT 'Agrega la comida del menú al carrito de compras (orden temporal) del cliente para un restaurante.'
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM usuarios_administradores
                   WHERE idUsuario = p_idAdmin
    ))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El usuario registrado no existe o no tiene autorización para esta operación.',
      MYSQL_ERRNO = 1644;
    ELSEIF (exists(SELECT 1
                   FROM carritos_compras
                   WHERE (idCliente = p_idCliente) AND (idMenu = p_idMenu)
    ))
      THEN
        BEGIN
          START TRANSACTION;
          UPDATE carritos_compras
          SET cantidad = cantidad + p_cantidad
          WHERE (idCliente = p_idCliente) AND (idMenu = p_idMenu);

          SET @nombreCompletoAdmin = (SELECT concat(nombre, ' ', apellidos)
                                      FROM usuarios
                                      WHERE id = p_idAdmin);
          SET @nombreCompletoCliente = (SELECT concat(nombre, ' ', apellidos)
                                        FROM usuarios
                                        WHERE id = p_idCliente);

          INSERT INTO bitacora_cambios (fechaHora, idUsuario, detalles)
            SELECT
              now(),
              p_idAdmin,
              concat('El administrador ', @nombreCompletoAdmin, ' agregó ',
                     p_cantidad, ' unidades del platillo ', p.nombre, ' a la orden del cliente ',
                     @nombreCompletoCliente, ' del restaurante ', r.nombre, '.')
            FROM usuarios u
              INNER JOIN carritos_compras cc
                ON u.id = cc.idCliente
              INNER JOIN menu_restaurantes mr
                ON mr.id = cc.idMenu
              INNER JOIN platillos p
                ON p.id = mr.idPlatillo
              INNER JOIN restaurantes r
                ON r.id = mr.idRestaurante
            WHERE (mr.id = p_idMenu);
          COMMIT;

          SELECT
            cantidad,
            nombrePlatillo,
            precioTarjetaDetalle,
            precioEfectivoDetalle
          FROM vt_carritos_compras_clientes
          WHERE (idCliente = p_idCliente) AND (idMenu = p_idMenu);
        END;

    ELSE
      BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
          ROLLBACK;
          RESIGNAL;
        END;

        START TRANSACTION;
        INSERT INTO carritos_compras (idCliente, idMenu, cantidad)
        VALUES (p_idCliente, p_idMenu, p_cantidad);

        SET @nombreCompletoAdmin = (SELECT concat(nombre, ' ', apellidos)
                                    FROM usuarios
                                    WHERE id = p_idAdmin
        );
        SET @nombreCompletoCliente = (SELECT concat(nombre, ' ', apellidos)
                                      FROM usuarios
                                      WHERE id = p_idCliente
        );

        INSERT INTO bitacora_cambios (fechaHora, idUsuario, detalles)
          SELECT
            now(),
            p_idAdmin,
            concat('El administrador ', @nombreCompletoAdmin,
                   ' agregó ', p_cantidad, ' unidades del platillo ', p.nombre,
                   ' a la orden del cliente ', @nombreCompletoCliente, ' del restaurante ',
                   r.nombre, '.')
          FROM usuarios u
            INNER JOIN carritos_compras cc
              ON u.id = cc.idCliente
            INNER JOIN menu_restaurantes mr
              ON mr.id = cc.idMenu
            INNER JOIN platillos p
              ON p.id = mr.idPlatillo
            INNER JOIN restaurantes r
              ON r.id = mr.idRestaurante
          WHERE (mr.id = p_idMenu);
        COMMIT;

        SELECT
          cantidad,
          nombrePlatillo,
          precioTarjetaDetalle,
          precioEfectivoDetalle
        FROM vt_carritos_compras_clientes
        WHERE (idCliente = p_idCliente) AND (idMenu = p_idMenu);
      END;
    END IF;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 DROP PROCEDURE IF EXISTS `sp_agregarIngrediente` */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
CREATE DEFINER = CURRENT_USER PROCEDURE `sp_agregarIngrediente`(IN p_idAdmin      INT, IN p_nombre NVARCHAR(50),
                                                                IN p_precioUnidad DECIMAL(8, 2),
                                                                IN p_urlFoto      NVARCHAR(200), IN p_idCategoria INT)
  COMMENT 'Agrega un nuevo ingrediente al sistema.'
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM usuarios_administradores
                   WHERE idUsuario = p_idAdmin
    ))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El usuario registrado no existe o no tiene autorización para esta operación.',
      MYSQL_ERRNO = 1644;
    ELSE
      BEGIN
        DECLARE idObtenido INT;

        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
          ROLLBACK;
          RESIGNAL;
        END;
        START TRANSACTION;
        INSERT INTO ingredientes (nombre, precioUnidad, urlFoto)
        VALUES (p_nombre, p_precioUnidad, p_urlFoto);

        SET idObtenido = (SELECT last_insert_id());

        INSERT INTO categorias_ingredientes (idIngrediente, idCategoria)
        VALUES (idObtenido, p_idCategoria);

        INSERT INTO bitacora_cambios (fechaHora, idUsuario, detalles)
          SELECT
            now(),
            p_idAdmin,
            concat('El administrador ', u.nombre,
                   ' agregó el ingrediente ', i.nombre, ' al sistema.')
          FROM usuarios u, ingredientes i
          WHERE (u.id = p_idAdmin) AND (i.id = idObtenido);
        COMMIT;

        SELECT
          id,
          nombre,
          precioUnidad
        FROM ingredientes
        WHERE id = idObtenido;
      END;
    END IF;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 DROP PROCEDURE IF EXISTS `sp_agregarIngredienteAInventario` */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
CREATE DEFINER = CURRENT_USER PROCEDURE `sp_agregarIngredienteAInventario`(IN p_idAdmin            INT,
                                                                           IN p_idRestaurante      INT,
                                                                           IN p_idIngrediente      INT,
                                                                           IN p_cantidadDisponible DECIMAL(13, 3))
  COMMENT 'Agrega un nuevo ingrediente al inventario del restaurante.'
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM usuarios_administradores
                   WHERE idUsuario = p_idAdmin
    ))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El usuario registrado no existe o no tiene autorización para esta operación.',
      MYSQL_ERRNO = 1644;
    ELSE
      BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
          ROLLBACK;
          RESIGNAL;
        END;
        START TRANSACTION;
        INSERT INTO inventario_restaurantes (idRestaurante, idIngrediente, cantidadDisponible)
        VALUES (p_idRestaurante, p_idIngrediente, p_cantidadDisponible);

        INSERT INTO bitacora_cambios (fechaHora, idUsuario, detalles)
          SELECT
            now(),
            p_idAdmin,
            concat('El administrador ', u.nombre, ' ', u.apellidos,
                   ' ha insertado el ingrediente ', i.nombre, ' al inventario del restaurante ',
                   r.nombre, '.')
          FROM ingredientes i, restaurantes r, usuarios u
          WHERE (i.id = p_idIngrediente) AND (r.id = p_idRestaurante)
                AND (u.id = p_idAdmin);
        COMMIT;
        /* Se retorna un conjunto resultado con la nueva entrada de inventario */
        SELECT
          idRestaurante,
          idIngrediente,
          cantidadDisponible
        FROM inventario_restaurantes
        WHERE (idRestaurante = p_idRestaurante) AND (idIngrediente = p_idIngrediente);
      END;
    END IF;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 DROP PROCEDURE IF EXISTS `sp_agregarIngredienteAPlatillo` */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
CREATE DEFINER = CURRENT_USER PROCEDURE `sp_agregarIngredienteAPlatillo`(IN p_idAdmin       INT, IN p_idPlatillo INT,
                                                                         IN p_idIngrediente INT,
                                                                         IN p_cantidad      DECIMAL(10, 3))
  COMMENT 'Agrega un ingrediente a la receta de un platillo.'
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM usuarios_administradores
                   WHERE idUsuario = p_idAdmin
    ))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El usuario registrado no existe o no tiene autorización para esta operación.',
      MYSQL_ERRNO = 1644;
    ELSE
      BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
          ROLLBACK;
          RESIGNAL;
        END;

        START TRANSACTION;
        INSERT INTO ingredientes_platillos (idPlatillo, idIngrediente, cantidadIngrediente)
        VALUES (p_idPlatillo, p_idIngrediente, p_cantidad);

        INSERT INTO bitacora_cambios (fechaHora, idUsuario, detalles)
          SELECT
            now(),
            p_idAdmin,
            concat('El administrador ', u.nombre, ' ', u.apellidos,
                   ' agregó el ingrediente ', i.nombre, ' al platillo ', p.nombre,
                   ' y se actualizó el menú de los restaurantes que no permiten el ingrediente.')
          FROM usuarios u, ingredientes i, platillos p
          WHERE (u.id = p_idAdmin) AND (i.id = p_idIngrediente) AND (p.id = p_idPlatillo);
        COMMIT;
      END;
    END IF;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 DROP PROCEDURE IF EXISTS `sp_agregarPlatilloAMenuRestaurante` */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
CREATE DEFINER = CURRENT_USER PROCEDURE `sp_agregarPlatilloAMenuRestaurante`(IN p_idAdmin       INT,
                                                                             IN p_idRestaurante INT,
                                                                             IN p_idPlatillo    INT)
  COMMENT 'Agrega un nuevo platillo al menú del restaurante.'
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM usuarios_administradores
                   WHERE idUsuario = p_idAdmin
    ))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El usuario registrado no existe o no tiene autorización para esta operación.',
      MYSQL_ERRNO = 1644;
    ELSE
      BEGIN
        DECLARE idObtenido INT;
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
          ROLLBACK;
          RESIGNAL;
        END;
        START TRANSACTION;
        INSERT INTO menu_restaurantes (idRestaurante, idPlatillo)
        VALUES (p_idRestaurante, p_idPlatillo);
        SET idObtenido = (SELECT last_insert_id());

        INSERT INTO bitacora_cambios (fechaHora, idUsuario, detalles)
          SELECT
            now(),
            p_idAdmin,
            concat('El administrador ', u.nombre, ' ', u.apellidos,
                   ' agregó el platillo ', p.nombre, ' al menú del restaurante ',
                   r.nombre, '.')
          FROM platillos p, restaurantes r, usuarios u
          WHERE (p.id = p_idPlatillo) AND (r.id = p_idRestaurante)
                AND (u.id = p_idAdmin);
        COMMIT;

        SELECT
          idRestaurante,
          idPlatillo
        FROM menu_restaurantes
        WHERE id = idObtenido;
      END;
    END IF;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 DROP PROCEDURE IF EXISTS `sp_agregarRestaurante` */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
CREATE DEFINER = CURRENT_USER PROCEDURE `sp_agregarRestaurante`(IN p_idAdmin   INT, IN p_nombre NVARCHAR(50),
                                                                IN p_direccion NVARCHAR(200), IN p_idCategoria INT)
  COMMENT 'Agrega un nuevo restaurante en el sistema.'
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM usuarios_administradores
                   WHERE idUsuario = p_idAdmin
    ))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El usuario registrado no existe o no tiene autorización para esta operación.',
      MYSQL_ERRNO = 1644;
    ELSE
      BEGIN
        DECLARE idObtenido INT;
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
          ROLLBACK;
          RESIGNAL;
        END;

        START TRANSACTION;
        INSERT INTO restaurantes (nombre, direccion, idCategoria)
        VALUES (p_nombre, p_direccion, p_idCategoria);
        SET idObtenido = (SELECT last_insert_id());

        /* La categoría del restaurante pasa a ser el primer tipo de ingredientes aceptado */
        INSERT INTO categorias_ingredientes_restaurantes (idRestaurante, idCategoria)
        VALUES (idObtenido, p_idCategoria);

        INSERT INTO bitacora_cambios (fechaHora, idUsuario, detalles)
          SELECT
            now(),
            p_idAdmin,
            concat('El administrador ', u.nombre, ' ', u.apellidos,
                   ' agregó el restaurante ', r.nombre, ' en el sistema.',)
          FROM usuarios u, restaurantes r
          WHERE (u.id = p_idAdmin) AND (r.id = idObtenido);
        COMMIT;
      END;
    END IF;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 DROP PROCEDURE IF EXISTS `sp_agregarUsuario` */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
CREATE DEFINER = CURRENT_USER PROCEDURE `sp_agregarUsuario`(IN p_idAdmin   INT, IN p_nombre NVARCHAR(50),
                                                            IN p_apellidos NVARCHAR(100),
                                                            IN p_eMail     NVARCHAR(50), IN p_password NVARCHAR(20))
  COMMENT 'Registra a un nuevo usuario en el sistema.'
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM usuarios_administradores
                   WHERE idUsuario = p_idAdmin
    ))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El usuario registrado no existe o no tiene autorización para esta operación.',
      MYSQL_ERRNO = 1644;
    ELSE
      BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
          ROLLBACK;
          RESIGNAL;
        END;
        START TRANSACTION;
        INSERT INTO usuarios (eMail, nombre, apellidos, pwd)
        VALUES (p_eMail, p_nombre, p_apellidos, p_password);

        SET @nombreCompletoAdmin = (SELECT concat(nombre, ' ', apellidos)
                                    FROM usuarios
                                    WHERE id = p_idAdmin);
        SET @nombreCompletoUsuario = (SELECT concat(p_nombre, ' ', p_apellidos));

        INSERT INTO bitacora_cambios (fechaHora, idUsuario, detalles)
        VALUES (now(), p_idAdmin, concat('El administrador ', @nombreCompletoAdmin,
                                         ' ha creado el usuario ', @nombreCompletoUsuario, ' en el sistema.'));
        COMMIT;
      END;
    END IF;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 DROP PROCEDURE IF EXISTS `sp_agregarUsuarioAdministrador` */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
CREATE DEFINER = CURRENT_USER PROCEDURE `sp_agregarUsuarioAdministrador`(IN p_idAdmin   INT, IN p_nombre NVARCHAR(50),
                                                                         IN p_apellidos NVARCHAR(100),
                                                                         IN p_eMail     NVARCHAR(50),
                                                                         IN p_password  NVARCHAR(20))
  COMMENT 'Registra un nuevo usuario administrador al sistema.'
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM usuarios_administradores
                   WHERE idUsuario = p_idAdmin
    ))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El usuario registrado no existe o no tiene autorización para esta operación.',
      MYSQL_ERRNO = 1644;
    ELSE
      BEGIN
        DECLARE idGenerado INT;

        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
          ROLLBACK;
          RESIGNAL;
        END;

        START TRANSACTION;
        CALL sp_agregarUsuario(p_idAdmin, p_nombre, p_apellidos, p_eMail, p_password);
        SET idGenerado = last_insert_id();
        /* Obtiene el último valor de una columna auto-generada/identidad */
        CALL sp_asignarUsuarioAdministrador(p_idAdmin, idGenerado);
        COMMIT;

        /* Si el usuario fue creado, selecciona su correo y el identificador generado. */
        SELECT
          u.id,
          u.eMail
        FROM usuarios u
          INNER JOIN usuarios_administradores a
            ON u.id = a.idUsuario
        WHERE u.id = idGenerado;
      END;
    END IF;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 DROP PROCEDURE IF EXISTS `sp_agregarUsuarioCliente` */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
CREATE DEFINER = CURRENT_USER PROCEDURE `sp_agregarUsuarioCliente`(IN p_idAdmin        INT, IN p_nombre NVARCHAR(50),
                                                                   IN p_apellidos      NVARCHAR(100),
                                                                   IN p_eMail          NVARCHAR(50),
                                                                   IN p_password       NVARCHAR(20),
                                                                   IN p_numeroTelefono DECIMAL(8, 0))
  COMMENT 'Registra un nuevo usuario cliente al sistema.'
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM usuarios_administradores
                   WHERE idUsuario = p_idAdmin
    ))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El usuario registrado no existe o no tiene autorización para esta operación.',
      MYSQL_ERRNO = 1644;
    ELSE
      BEGIN
        DECLARE idGenerado INT;

        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
          ROLLBACK;
          RESIGNAL;
        END;

        START TRANSACTION;
        CALL sp_agregarUsuario(p_idAdmin, p_nombre, p_apellidos, p_eMail, p_password);
        SET idGenerado = (SELECT last_insert_id());
        CALL sp_asignarUsuarioCliente(p_idAdmin, idGenerado, p_numeroTelefono);
        COMMIT;

        /* Si el usuario fue creado, selecciona su correo y el identificador generado */
        SELECT
          u.id,
          u.eMail
        FROM usuarios u
          INNER JOIN usuarios_clientes c
            ON u.id = c.idUsuario
        WHERE u.id = idGenerado;
      END;
    END IF;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 DROP PROCEDURE IF EXISTS `sp_asignarCategoriaAIngrediente` */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
CREATE DEFINER = CURRENT_USER PROCEDURE `sp_asignarCategoriaAIngrediente`(IN p_idAdmin     INT, IN p_idIngrediente INT,
                                                                          IN p_idCategoria INT)
  COMMENT 'Clasifica el ingrediente ingresado a la categoría ingresada.'
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM usuarios_administradores
                   WHERE idUsuario = p_idAdmin
    ))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El usuario registrado no existe o no tiene autorización para esta operación.',
      MYSQL_ERRNO = 1644;
    ELSE
      BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
          ROLLBACK;
          RESIGNAL;
        END;
        START TRANSACTION;
        INSERT INTO categorias_ingredientes (idIngrediente, idCategoria)
        VALUES (p_idIngrediente, p_idCategoria);

        INSERT INTO bitacora_cambios (fechaHora, idUsuario, detalles)
          SELECT
            now(),
            p_idAdmin,
            concat('El administrador ', u.nombre, ' ', u.apellidos,
                   ' asignó la categoría ', c.nombre, ' al ingrediente ', i.nombre, '.')
          FROM usuarios u, categorias c, ingredientes i
          WHERE (u.id = p_idAdmin) AND (c.id = p_idCategoria)
                AND (i.id = p_idIngrediente);
        COMMIT;
      END;
    END IF;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 DROP PROCEDURE IF EXISTS `sp_asignarUsuarioAdministrador` */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
CREATE DEFINER = CURRENT_USER PROCEDURE `sp_asignarUsuarioAdministrador`(IN p_idAdmin INT, IN p_idUsuario INT)
  COMMENT 'Asigna a un nuevo usuario derechos de administrador.'
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM usuarios_administradores
                   WHERE idUsuario = p_idAdmin
    ))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El usuario registrado no existe o no tiene autorización para esta operación.',
      MYSQL_ERRNO = 1644;
    ELSE
      BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
          ROLLBACK;
          RESIGNAL;
        END;

        START TRANSACTION;
        INSERT INTO usuarios_administradores (idUsuario)
        VALUES (p_idUsuario);

        SET @nombreCompletoAdmin = (SELECT concat(nombre, ' ', apellidos)
                                    FROM usuarios
                                    WHERE id = p_idAdmin);
        SET @nombreCompletoUsuario = (SELECT concat(nombre, ' ', apellidos)
                                      FROM usuarios
                                      WHERE id = p_idUsuario);

        INSERT INTO bitacora_cambios (fechaHora, idUsuario, detalles)
        VALUES (now(), p_idAdmin, concat('El administrador ', @nombreCompletoAdmin,
                                         ' ha designado al usuario ', @nombreCompletoUsuario,
                                         ' como un administrador.'));
        COMMIT;
      END;
    END IF;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 DROP PROCEDURE IF EXISTS `sp_asignarUsuarioCliente` */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
CREATE DEFINER = CURRENT_USER PROCEDURE `sp_asignarUsuarioCliente`(IN p_idAdmin        INT, IN p_idUsuario INT,
                                                                   IN p_numeroTelefono DECIMAL(8, 0))
  COMMENT 'Agrega un nuevo usuario cliente al sistema.'
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM usuarios_administradores
                   WHERE idUsuario = p_idAdmin
    ))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El usuario registrado no existe o no tiene autorización para esta operación.',
      MYSQL_ERRNO = 1644;
    ELSE
      BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
          ROLLBACK;
          RESIGNAL;
        END;

        START TRANSACTION;
        INSERT INTO usuarios_clientes (idUsuario, numeroTelefono)
        VALUES (p_idUsuario, p_numeroTelefono);

        SET @nombreCompletoAdmin = (SELECT concat(nombre, ' ', apellidos)
                                    FROM usuarios
                                    WHERE id = p_idAdmin);
        SET @nombreCompletoUsuario = (SELECT concat(nombre, ' ', apellidos)
                                      FROM usuarios
                                      WHERE id = p_idUsuario);

        INSERT INTO bitacora_cambios (fechaHora, idUsuario, detalles)
        VALUES (now(), p_idAdmin, concat('El administrador ', @nombreCompletoAdmin,
                                         ' ha designado al usuario ', @nombreCompletoUsuario,
                                         ' como un cliente.')
        );
        COMMIT;
      END;
    END IF;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 DROP PROCEDURE IF EXISTS `sp_borrarCarritoComprasClienteEnRestaurante` */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
CREATE DEFINER = CURRENT_USER PROCEDURE `sp_borrarCarritoComprasClienteEnRestaurante`
  (IN p_idAdmin INT, IN p_idRestaurante INT, IN p_idCliente INT)
  COMMENT 'Borra el carrito de compras del cliente en un restaurante.'
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM usuarios_administradores
                   WHERE idUsuario = p_idAdmin
    ))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El usuario registrado no existe o no tiene autorización para esta operación.',
      MYSQL_ERRNO = 1644;

    ELSEIF (NOT exists(SELECT 1
                       FROM usuarios_clientes
                       WHERE (idUsuario = p_idCliente)
    ))
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El cliente ingresado no se encuentra registrado.',
        MYSQL_ERRNO = 1644;
    ELSEIF (NOT exists(SELECT 1
                       FROM restaurantes
                       WHERE (id = p_idRestaurante)
    ))
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El restaurante ingresado no se encuentra registrado.',
        MYSQL_ERRNO = 1644;
    ELSE
      BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
          ROLLBACK;
          RESIGNAL;
        END;

        START TRANSACTION;
        DELETE c
        FROM carritos_compras c
          INNER JOIN vt_carritos_compras_clientes vt
            ON c.idMenu = vt.idMenu
        WHERE (vt.idRestaurante = p_idRestaurante) AND (c.idCliente = p_idCliente);

        SET @nombreCompletoAdmin = (SELECT concat(nombre, ' ', apellidos)
                                    FROM usuarios
                                    WHERE id = p_idAdmin);
        SET @nombreCompletoCliente = (SELECT concat(nombre, ' ', apellidos)
                                      FROM usuarios
                                      WHERE id = p_idCliente);

        INSERT INTO bitacora_cambios (fechaHora, idUsuario, detalles)
          SELECT
            now(),
            p_idAdmin,
            concat('El administrador ', @nombreCompletoAdmin,
                   ' ha borrado la lista de productos de la orden del cliente ', @nombreCompletoCliente,
                   ' del restaurante ', r.nombre, '.')
          FROM restaurantes r
          WHERE r.id = p_idRestaurante;
        COMMIT;
      END;
    END IF;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 DROP PROCEDURE IF EXISTS `sp_borrarDetalleCarritoComprasClienteEnRestaurante` */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
CREATE DEFINER = CURRENT_USER PROCEDURE `sp_borrarDetalleCarritoComprasClienteEnRestaurante`
  (IN p_idAdmin INT, IN p_idCliente INT, IN p_idMenu INT)
  COMMENT 'Borra un detalle del carrito de compras de un cliente.'
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM usuarios_administradores
                   WHERE idUsuario = p_idAdmin
    ))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El usuario registrado no existe o no tiene autorización para esta operación.',
      MYSQL_ERRNO = 1644;
    ELSEIF (NOT exists(SELECT 1
                       FROM usuarios_clientes
                       WHERE (idUsuario = p_idCliente)
    ))
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El cliente ingresado no se encuentra registrado.',
        MYSQL_ERRNO = 1644;
    ELSEIF (NOT exists(SELECT 1
                       FROM menu_restaurantes
                       WHERE (id = p_idMenu)
    ))
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El platillo del menú seleccionado no se encuentra registrado.',
        MYSQL_ERRNO = 1644;
    ELSE
      BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
          ROLLBACK;
          RESIGNAL;
        END;

        START TRANSACTION;
        DELETE
        FROM carritos_compras
        WHERE (idCliente = p_idCliente) AND (idMenu = p_idMenu);

        SET @nombreCompletoAdmin = (SELECT concat(nombre, ' ', apellidos)
                                    FROM usuarios
                                    WHERE id = p_idAdmin);
        SET @nombreCompletoCliente = (SELECT concat(nombre, ' ', apellidos)
                                      FROM usuarios
                                      WHERE id = p_idCliente);

        INSERT INTO bitacora_cambios (fechaHora, idUsuario, detalles)
          SELECT
            now(),
            p_idAdmin,
            concat('El administrador ', @nombreCompletoAdmin,
                   ' ha eliminado el platillo ', p.nombre, ' de la orden del cliente ',
                   @nombreCompletoCliente, ' del restaurante ', r.nombre, '.')
          FROM carritos_compras cc
            INNER JOIN menu_restaurantes mr
              ON mr.id = cc.idMenu
            INNER JOIN restaurantes r
              ON r.id = mr.idRestaurante
            INNER JOIN platillos p
              ON p.id = mr.idPlatillo
            INNER JOIN usuarios u
              ON u.id = cc.idCliente
          WHERE (mr.id = p_idMenu) AND (u.id = p_idCliente);
        COMMIT;
      END;
    END IF;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 DROP PROCEDURE IF EXISTS `sp_borrarUsuario` */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
CREATE DEFINER = CURRENT_USER PROCEDURE `sp_borrarUsuario`(IN p_idAdmin INT, IN p_idUsuario INT)
  COMMENT 'Borra el usuario del sistema.'
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM usuarios_administradores
                   WHERE idUsuario = p_idAdmin
    ))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El usuario registrado no existe o no tiene autorización para esta operación.',
      MYSQL_ERRNO = 1644;
    ELSE
      BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
          ROLLBACK;
          RESIGNAL;
        END;

        SET @nombreCompletoAdmin = (SELECT concat(nombre, ' ', apellidos)
                                    FROM usuarios
                                    WHERE id = p_idAdmin);
        SET @nombreCompletoUsuario = (SELECT concat(nombre, ' ', apellidos)
                                      FROM usuarios
                                      WHERE id = p_idUsuario);

        START TRANSACTION;
        DELETE
        FROM usuarios
        WHERE id = p_idUsuario;
        INSERT INTO bitacora_cambios (fechaHora, idUsuario, detalles)
          SELECT
            now(),
            p_idAdmin,
            concat('El administrador ', @nombreCompletoAdmin,
                   'ha eliminado el usuario ', @nombreCompletoUsuario, ' del sistema.')
              commit;
      END;
    END IF;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 DROP PROCEDURE IF EXISTS `sp_borrarUsuarioAdministrador` */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
CREATE DEFINER = CURRENT_USER PROCEDURE `sp_borrarUsuarioAdministrador`(IN p_idAdmin INT, IN p_idAdminBorrado INT)
  COMMENT 'Borra un usuario administrador del sistema.'
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM usuarios_administradores
                   WHERE idUsuario = p_idAdmin
    ))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El usuario registrado no existe o no tiene autorización para esta operación.',
      MYSQL_ERRNO = 1644;
    ELSEIF (NOT exists(SELECT 1
                       FROM usuarios_administradores
                       WHERE idUsuario = p_idAdminBorrado
    ))
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El usuario ingresado no se encuentra registrado como administrador.',
        MYSQL_ERRNO = 1644;
    ELSEIF ((SELECT count(*)
             FROM usuarios_administradores) = 1)
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Debe existir al menos un usuario administrador.',
        MYSQL_ERRNO = 1644;
    ELSE
      BEGIN
        CALL sp_borrarUsuario(p_idAdmin, p_idAdminBorrado);
      END;
    END IF;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 DROP PROCEDURE IF EXISTS `sp_borrarUsuarioCliente` */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
CREATE DEFINER = CURRENT_USER PROCEDURE `sp_borrarUsuarioCliente`(IN p_idAdmin INT, IN p_idClienteBorrado INT)
  COMMENT 'Borra un usuario cliente del sistema.'
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM usuarios_administradores
                   WHERE idUsuario = p_idAdmin
    ))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El usuario registrado no existe o no tiene autorización para esta operación.',
      MYSQL_ERRNO = 1644;
    ELSEIF (NOT exists(SELECT 1
                       FROM usuarios_clientes
                       WHERE idUsuario = p_idClienteBorrado
    ))
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El usuario ingresado no se encuentra registrado como cliente.',
        MYSQL_ERRNO = 1644;
    ELSE
      BEGIN
        CALL sp_borrarUsuario(p_idAdmin, p_idClienteBorrado);
      END;
    END IF;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 DROP PROCEDURE IF EXISTS `sp_cambiarIngrediente` */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
CREATE DEFINER = CURRENT_USER PROCEDURE `sp_cambiarIngrediente`(IN p_idAdmin            INT, IN p_idIngrediente INT,
                                                                IN p_nuevo_nombre       NVARCHAR(50),
                                                                IN p_nuevo_precioUnidad DECIMAL(8, 2),
                                                                IN p_nuevo_urlFoto      NVARCHAR(200),
                                                                IN p_nuevo_idCategoria  INT)
  COMMENT 'Modifica la información de un ingrediente en el sistema. Los parámetros son\n    opcionales; aquellos dejados en NULL no se modifican.'
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM usuarios_administradores
                   WHERE idUsuario = p_idAdmin
    ))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El usuario registrado no existe o no tiene autorización para esta operación.',
      MYSQL_ERRNO = 1644;
    ELSE
      BEGIN
        DECLARE idObtenido INT;

        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
          ROLLBACK;
          RESIGNAL;
        END;
        START TRANSACTION;
        UPDATE ingredientes i
          INNER JOIN categorias_ingredientes c
            ON i.id = c.idIngrediente
        SET i.nombre     = ifnull(p_nuevo_nombre, i.nombre),
          i.precioUnidad = ifnull(p_nuevo_precioUnidad, i.precioUnidad),
          i.urlFoto      = ifnull(p_nuevo_urlFoto, i.urlFoto),
          c.idCategoria  = ifnull(p_nuevo_idCategoria, c.idCategoria)
        WHERE i.id = p_idIngrediente;

        INSERT INTO bitacora_cambios (fechaHora, idUsuario, detalles)
          SELECT
            now(),
            p_idAdmin,
            concat('El administrador ', u.nombre, ' ', u.apellidos,
                   ' modificó la información del ingrediente con identificador ', i.id,
                   ' en el sistema.')
          FROM usuarios u, ingredientes i
          WHERE (u.id = p_idAdmin) AND (i.id = p_idIngrediente);
        COMMIT;

        SELECT
          id,
          nombre,
          precioUnidad
        FROM ingredientes
        WHERE id = idObtenido;
      END;
    END IF;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 DROP PROCEDURE IF EXISTS `sp_cambiarInventarioRestaurante` */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
CREATE DEFINER = CURRENT_USER PROCEDURE `sp_cambiarInventarioRestaurante`(IN p_idAdmin       INT,
                                                                          IN p_idRestaurante INT,
                                                                          IN p_idIngrediente INT,
                                                                          IN p_nuevaCantidad DECIMAL(13, 3))
  COMMENT 'Modifica el inventario de un ingrediente para un restaurante.'
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM usuarios_administradores
                   WHERE idUsuario = p_idAdmin
    ))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El usuario registrado no existe o no tiene autorización para esta operación.',
      MYSQL_ERRNO = 1644;
    ELSE
      BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
          ROLLBACK;
          RESIGNAL;
        END;

        START TRANSACTION;
        UPDATE inventario_restaurantes
        SET cantidadDisponible = p_nuevaCantidad
        WHERE (idRestaurante = p_idRestaurante) AND (idIngrediente = p_idIngrediente);

        INSERT INTO bitacora_cambios (fechaHora, idUsuario, detalles)
          SELECT
            now(),
            p_idAdmin,
            concat('El administrador ', u.nombre, ' ', u.apellidos,
                   ' modificó el inventario del ingrediente ', i.nombre, ' del restaurante ',
                   r.nombre, ' a la cantidad ', p_nuevaCantidad)
          FROM usuarios u, restaurantes r, ingredientes i
          WHERE (u.id = p_idAdmin) AND (r.id = p_idRestaurante)
                AND (i.id = p_idIngrediente);
        COMMIT;

        SELECT
          idRestaurante,
          idIngrediente,
          cantidadDisponible
        FROM inventario_restaurantes
        WHERE (idRestaurante = p_idRestaurante) AND (idIngrediente = p_idIngrediente);
      END;
    END IF;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 DROP PROCEDURE IF EXISTS `sp_cambiarUsuarioCliente` */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
CREATE DEFINER = CURRENT_USER PROCEDURE `sp_cambiarUsuarioCliente`(IN p_idUsuarioModificador INT, IN p_idCliente INT,
                                                                   IN p_nuevo_nombre         NVARCHAR(50),
                                                                   IN p_nuevo_apellidos      NVARCHAR(100),
                                                                   IN p_nuevo_password       NVARCHAR(20),
                                                                   IN p_nuevo_numeroTelefono DECIMAL(8, 0)
)
  COMMENT 'Modifica la información de un usuario seleccionado. Los parámetros que no se desea modificar\n se pasan como NULL. El e-mail del usuario no se modifica, ya que lo identifica para iniciar sesión.'
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM usuarios
                   WHERE id = p_idUsuarioModificador
    ))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El usuario registrado no existe o no tiene autorización para esta operación.',
      MYSQL_ERRNO = 1644;

    /* Los clientes no pueden cambiar la información de otros clientes */
    ELSEIF ((exists(SELECT 1
                    FROM usuarios_clientes
                    WHERE idUsuario = p_idUsuarioModificador) AND
             (p_idUsuarioModificador != p_idCliente)
    ))
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El usuario ingresado no puede cambiar la información de otros usuarios.',
        MYSQL_ERRNO = 1644;

    ELSE
      BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
          ROLLBACK;
          RESIGNAL;
        END;

        START TRANSACTION;
        UPDATE usuarios u
          INNER JOIN usuarios_clientes c
            ON u.id = c.idUsuario
        SET u.nombre       = coalesce(p_nuevo_nombre, nombre),
          u.apellidos      = coalesce(p_nuevo_apellidos, apellidos),
          u.pwd            = coalesce(p_nuevo_password, pwd),
          c.numeroTelefono = coalesce(p_nuevo_numeroTelefono, numeroTelefono)
        WHERE u.id = p_idCliente;

        SET @nombreCompletoModificador = (SELECT concat(nombre, ' ', apellidos)
                                          FROM usuarios
                                          WHERE id = p_idUsuarioModificador);

        INSERT INTO bitacora_cambios (fechaHora, idUsuario, detalles)
          SELECT
            now(),
            p_idUsuarioModificador,
            concat('El usuario ',
                   @nombreCompletoModificador,
                   ' ha modificado la información del usuario asociado al e-mail ',
                   eMail, '.')
          FROM usuarios
          WHERE id = p_idCliente;
        COMMIT;
      END;
    END IF;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getBitacoraCambios` */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
CREATE DEFINER = CURRENT_USER PROCEDURE `sp_getBitacoraCambios`(
  IN p_fechaInicio DATETIME(0) /* Opcional: Pasar NULL para omitir*/,
  IN p_fechaFin    DATETIME(0) /* Opcional: Pasar NULL para omitir*/)
  COMMENT 'Muestra el contenido de la bitácora de cambios en un intervalo de tiempo opcional.'
  BEGIN
    IF ((p_fechaInicio IS NOT NULL) AND (p_fechaFin IS NOT NULL) AND
        (p_fechaInicio > p_fechaFin))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'La fecha de inicio ingresada no debe ser después de la fecha final.',
      MYSQL_ERRNO = 1644;
    ELSE
      SELECT
        b.id,
        date_format(b.fechaHora, '%d/%m/%Y %r') AS 'fechaRegistro',
        b.idUsuario,
        u.id                                    AS 'idUsuario',
        concat(u.nombre, ' ', u.apellidos)      AS 'nombreCompletoUsuario',
        b.detalles
      FROM bitacora_cambios b
        INNER JOIN usuarios u
          ON u.id = b.idUsuario
      WHERE ((p_fechaInicio IS NULL) OR (b.fechaHora >= p_fechaInicio))
            AND ((p_fechaFin IS NULL) OR (b.fechaHora <= p_fechaFin));
    END IF;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getCarritoComprasClienteRestaurante` */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
CREATE DEFINER = CURRENT_USER PROCEDURE `sp_getCarritoComprasClienteRestaurante`(IN p_idRestaurante INT,
                                                                                 IN p_idCliente     INT)
  COMMENT 'Muestra el contenido del carrito del cliente (orden temporal).'
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM restaurantes
                   WHERE id = p_idRestaurante
    ))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El restaurante ingresado no se encuentra registrado.',
      MYSQL_ERRNO = 1644;
    ELSEIF (NOT exists(SELECT 1
                       FROM usuarios_clientes
                       WHERE idUsuario = p_idCliente
    ))
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El cliente ingresado no se encuentra registrado.',
        MYSQL_ERRNO = 1644;
    ELSE
      SELECT
        idMenu,
        cantidad,
        nombrePlatillo,
        precioTarjetaDetalle,
        precioEfectivoDetalle
      FROM vt_carritos_compras_clientes
      WHERE (idCliente = p_idCliente) AND (idRestaurante = p_idRestaurante);
    END IF;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getCategoriasAdmitidasRestaurante` */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
CREATE DEFINER = CURRENT_USER PROCEDURE `sp_getCategoriasAdmitidasRestaurante`(IN p_idRestaurante INT)
  COMMENT 'Obtiene la lista de categorías de ingredientes asociadas al restaurante.'
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM restaurantes
                   WHERE id = p_idRestaurante
    ))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El restaurante ingresado no se encuentra registrado.',
      MYSQL_ERRNO = 1644;
    ELSE
      SELECT
        c.id     AS 'idCategoria',
        c.nombre AS 'nombreCategoria'
      FROM categorias_ingredientes_restaurantes cr
        INNER JOIN categorias c
          ON c.id = cr.idCategoria
      WHERE cr.idRestaurante = p_idRestaurante;
    END IF;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getCategoriasIngredientesDeRestaurante` */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
CREATE DEFINER = CURRENT_USER PROCEDURE `sp_getCategoriasIngredientesDeRestaurante`(IN p_idRestaurante INT)
  COMMENT 'Obtiene una lista con las categorías de alimentos registradas para un restaurante.'
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM restaurantes
                   WHERE id = p_idRestaurante))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El restaurante ingresado no se encuentra registrado.',
      MYSQL_ERRNO = 1644;
    ELSE
      SELECT
        c.id,
        c.nombre
      FROM categorias_ingredientes_restaurantes i
        JOIN restaurantes r
          ON r.id = i.idRestaurante
        JOIN categorias c
          ON c.id = i.idCategoria
      WHERE i.idRestaurante = p_idRestaurante;
    END IF;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getDetallesOrdenCompra` */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
CREATE DEFINER = CURRENT_USER PROCEDURE `sp_getDetallesOrdenCompra`(IN p_idOrdenCompra INT)
  COMMENT 'Obtiene los detalles de platillos de una orden de compra realizada.'
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM ordenes_compra
                   WHERE id = p_idOrdenCompra))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'La orden ingresada no se encuentra registrada.',
      MYSQL_ERRNO = 1644;
    ELSE
      SELECT
        poc.idPlatillo,
        p.nombre AS 'nombrePlatillo',
        poc.cantidad,
        poc.precioUnidad,
        poc.descuento,
        poc.totalDetalle
      FROM platillos_ordenes_compra poc
        INNER JOIN platillos p
          ON p.id = poc.idPlatillo
      WHERE poc.idOrden = p_idOrdenCompra;
    END IF;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getGananciasRestauranteEnDia` */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
CREATE DEFINER = CURRENT_USER PROCEDURE `sp_getGananciasRestauranteEnDia`(IN p_idFecha DATETIME(0))
  BEGIN
    IF (p_idFecha > (SELECT current_date))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'La fecha ingresada no debe ser mayor a la actual.',
      MYSQL_ERRNO = 1644;
    ELSE
      SELECT
        idRestaurante,
        nombreRestaurante,
        fechaConsultada,
        cantidadOrdenes,
        totalOrdenes,
        gananciasOrdenes
      FROM vt_reportes_diarios_ganancias
      WHERE fechaConsultada = date_format(p_idFecha, '%d/%m/%Y');
    END IF;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getInfoIngrediente` */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
CREATE DEFINER = CURRENT_USER PROCEDURE `sp_getInfoIngrediente`(IN p_idIngrediente INT)
  COMMENT 'Obtiene la información detallada de un ingrediente.'
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM ingredientes
                   WHERE id = p_idIngrediente))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El ingrediente ingresado no se encuentra registrado.',
      MYSQL_ERRNO = 1644;
    ELSE
      SELECT
        i.id           AS 'idIngrediente',
        c.id           AS 'idCategoria',
        i.nombre       AS 'nombreIngrediente',
        c.nombre       AS 'nombreCategoria',
        i.precioUnidad AS 'precioPorUnidad',
        i.urlFoto      AS 'URLfoto'
      FROM ingredientes i
        INNER JOIN categorias_ingredientes ci
          ON i.id = ci.idIngrediente
        INNER JOIN categorias c
          ON c.id = ci.idCategoria
      WHERE i.id = p_idIngrediente;
    END IF;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getInfoOrdenCompra` */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
CREATE DEFINER = CURRENT_USER PROCEDURE `sp_getInfoOrdenCompra`(IN p_idOrdenCompra INT)
  COMMENT 'Obtiene la información básica de una orden de compra realizada.'
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM ordenes_compra
                   WHERE id = p_idOrdenCompra))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'La orden ingresada no se encuentra registrada.',
      MYSQL_ERRNO = 1644;
    ELSE
      SELECT
        idCliente,
        idRestaurante,
        nombreCliente,
        nombreRestaurante,
        fechaFactura,
        subTotal,
        descuento,
        total
      FROM vt_costos_ordenes_compra
      WHERE idOrden = p_idOrdenCompra;
    END IF;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getInfoRestaurante` */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
CREATE DEFINER = CURRENT_USER PROCEDURE `sp_getInfoRestaurante`(IN p_idRestaurante INT)
  COMMENT 'Obtiene la información detallada de un restaurante.'
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM restaurantes
                   WHERE id = p_idRestaurante
    ))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El restaurante ingresado no se encuentra registrado.',
      MYSQL_ERRNO = 1644;
    ELSE
      SELECT
        id,
        idCategoria,
        nombre,
        direccion
      FROM restaurantes
      WHERE (id = p_idRestaurante);
    END IF;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getInfoUsuarioAdministrador` */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
CREATE DEFINER = CURRENT_USER PROCEDURE `sp_getInfoUsuarioAdministrador`(IN p_idAdministrador INT)
  COMMENT 'Obtiene la información de un administrador.'
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM usuarios
                   WHERE id = p_idAdministrador
    ))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El usuario ingresado no se encuentra registrado.',
      MYSQL_ERRNO = 1644;
    ELSEIF (NOT exists(SELECT 1
                       FROM usuarios_administradores
                       WHERE idUsuario = p_idAdministrador
    ))
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El usuario ingresado no es un cliente.',
        MYSQL_ERRNO = 1644;
    ELSE
      SELECT
        u.id,
        u.eMail AS 'e-Mail',
        u.nombre,
        u.apellidos
      FROM usuarios u
        INNER JOIN usuarios_administradores a
          ON u.id = a.idUsuario
      WHERE u.id = p_idAdministrador;
    END IF;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getInfoUsuarioCliente` */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
CREATE DEFINER = CURRENT_USER PROCEDURE `sp_getInfoUsuarioCliente`(IN p_idCliente INT)
  COMMENT 'Obtiene la información de un cliente.'
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM usuarios
                   WHERE id = p_idCliente
    ))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El usuario ingresado no se encuentra registrado.',
      MYSQL_ERRNO = 1644;
    ELSEIF (NOT exists(SELECT 1
                       FROM usuarios_clientes
                       WHERE idUsuario = p_idCliente
    ))
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El usuario ingresado no es un cliente.',
        MYSQL_ERRNO = 1644;
    ELSE
      SELECT
        u.id,
        u.eMail AS 'e-Mail',
        u.nombre,
        u.apellidos,
        c.numeroTelefono
      FROM usuarios u
        INNER JOIN usuarios_clientes c
          ON u.id = c.idUsuario
      WHERE u.id = p_idCliente;
    END IF;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getIngredientesPlatillo` */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
CREATE DEFINER = CURRENT_USER PROCEDURE `sp_getIngredientesPlatillo`(IN p_idPlatillo INT)
  COMMENT 'Obtiene una lista de todos los ingredientes utilizados en un platillo.'
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM platillos
                   WHERE id = p_idPlatillo)
    )
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El platillo ingresado no se encuentra registrado.',
      MYSQL_ERRNO = 1644;
    ELSE
      SELECT
        v.idIngrediente,
        v.NombreIngrediente,
        v.Cantidad,
        i.precioUnidad,
        v.precioIngrediente
      FROM vt_costos_ingredientes_platillos v
        INNER JOIN ingredientes i
          ON i.id = v.idIngrediente
      WHERE v.idPlatillo = p_idPlatillo;
    END IF;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getInventarioRestaurante` */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
CREATE DEFINER = CURRENT_USER PROCEDURE `sp_getInventarioRestaurante`(IN p_idRestaurante INT)
  COMMENT 'Obtiene una lista con el inventario de un restaurante.'
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM restaurantes
                   WHERE id = p_idRestaurante))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El restaurante ingresado no se encuentra registrado.',
      MYSQL_ERRNO = 1644;
    ELSE
      SELECT
        ir.idIngrediente,
        i.nombre AS 'NombreIngrediente',
        ir.cantidadDisponible
      FROM inventario_restaurantes ir
        JOIN restaurantes r
          ON r.id = ir.idRestaurante
        JOIN ingredientes i
          ON i.id = ir.idIngrediente
      WHERE ir.idRestaurante = p_idRestaurante
      ORDER BY ir.cantidadDisponible DESC, i.nombre ASC;
    END IF;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getListaCategoriasAlimentos` */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
CREATE DEFINER = CURRENT_USER PROCEDURE `sp_getListaCategoriasAlimentos`()
  COMMENT 'Obtiene una lista de las categorías de alimentos registradas.'
  BEGIN
    SELECT
      id,
      nombre
    FROM categorias;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getListaEmisoresTarjetas` */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
CREATE DEFINER = CURRENT_USER PROCEDURE `sp_getListaEmisoresTarjetas`()
  COMMENT 'Obtiene una lista con los emisores de tarjetas de crédito.'
  BEGIN
    SELECT
      id,
      nombre
    FROM emisores_tarjetas
    ORDER BY nombre ASC;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getListaIngredientesAdmitidosDeRestaurante` */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
CREATE DEFINER = CURRENT_USER PROCEDURE `sp_getListaIngredientesAdmitidosDeRestaurante`(IN p_idRestaurante INT)
  COMMENT 'Obtiene una lista de los ingredientes que son admitidos para un restaurante.\n	Los ingredientes son admitidos si sus categorías están asociadas con el restaurante.'
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM restaurantes
                   WHERE id = p_idRestaurante
    ))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El restaurante ingresado no se encuentra registrado.',
      MYSQL_ERRNO = 1644;
    ELSE
      /*	Considerar que puede retornar un conjunto vacío si el restaurante no tiene categorías
        asociadas, sin importar si existen ingredientes o categorías en el sistema.
        */
      SELECT
        i.id     AS 'idIngrediente',
        c.id     AS 'idCategoria',
        i.nombre AS 'NombreIngrediente',
        c.nombre AS 'NombreCategoria'
      FROM restaurantes r
        JOIN categorias_ingredientes_restaurantes cir
          ON r.id = cir.idRestaurante
        JOIN categorias_ingredientes ci
          ON ci.idCategoria = cir.idCategoria
        JOIN ingredientes i
          ON i.id = ci.idIngrediente
        JOIN categorias c
          ON c.id = ci.idCategoria
      WHERE r.id = p_idRestaurante
      ORDER BY c.nombre ASC, i.nombre ASC;
    END IF;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getListaIngredientesEnCategoria` */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
CREATE DEFINER = CURRENT_USER PROCEDURE `sp_getListaIngredientesEnCategoria`(IN p_idCategoria INT)
  COMMENT 'Obtiene una lista de los ingredientes clasificados en una categoría.'
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM categorias
                   WHERE id = p_idCategoria
    ))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'La categoría ingresada no se encuentra registrada',
      MYSQL_ERRNO = 1644;
    ELSEIF (NOT exists(SELECT 1
                       FROM categorias_ingredientes
                       WHERE idCategoria = p_idCategoria
    ))
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No hay ingredientes registrados en esta categoría.',
        MYSQL_ERRNO = 1644;
    ELSE
      /* Puede retornar un conjunto vacío si no hay ingredientes en la categoría */
      SELECT
        i.id,
        i.nombre
      FROM ingredientes i
        JOIN categorias_ingredientes ci
          ON i.id = ci.idIngrediente
      WHERE (ci.idCategoria = p_idCategoria)
      ORDER BY i.nombre;
    END IF;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getListaRestaurantes` */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
CREATE DEFINER = CURRENT_USER PROCEDURE `sp_getListaRestaurantes`()
  COMMENT 'Obtiene una lista de los restaurantes registrados.'
  BEGIN
    SELECT
      id,
      nombre
    FROM restaurantes
    ORDER BY nombre ASC;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getListaUsuariosAdministradores` */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
CREATE DEFINER = CURRENT_USER PROCEDURE `sp_getListaUsuariosAdministradores`()
  COMMENT 'Obtiene una lista sencilla de los clientes registrados.'
  BEGIN
    SELECT
      u.id,
      u.nombre
    FROM usuarios_administradores a
      INNER JOIN usuarios u
        ON u.id = a.idUsuario
    ORDER BY u.nombre ASC;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getListaUsuariosClientes` */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
CREATE DEFINER = CURRENT_USER PROCEDURE `sp_getListaUsuariosClientes`()
  COMMENT 'Obtiene una lista sencilla de los clientes registrados.'
  BEGIN
    SELECT
      u.id,
      u.nombre
    FROM usuarios_clientes c
      INNER JOIN usuarios u
        ON u.id = c.idUsuario
    ORDER BY u.nombre ASC;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getMenuRestaurante` */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
CREATE DEFINER = CURRENT_USER PROCEDURE `sp_getMenuRestaurante`(IN p_idRestaurante INT)
  COMMENT 'Obtiene el menú de un restaurante.'
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM restaurantes
                   WHERE id = p_idRestaurante
    ))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El restaurante ingresado no se encuentra registrado.',
      MYSQL_ERRNO = 1644;
    ELSE
      SELECT
        m.id AS 'idMenu',
        cp.idPlatillo,
        cp.nombrePlatillo,
        cp.precioBase
      FROM restaurantes r
        INNER JOIN menu_restaurantes m
          ON r.id = m.idRestaurante
        INNER JOIN vt_costos_platillos cp
          ON m.idPlatillo = cp.idPlatillo
      WHERE r.id = p_idRestaurante;
    END IF;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getOrdenesCompraCliente` */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
CREATE DEFINER = CURRENT_USER PROCEDURE `sp_getOrdenesCompraCliente`(IN p_idCliente INT)
  COMMENT 'Obtiene una lista con las órdenes de compra hechas por un cliente.'
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM usuarios_clientes
                   WHERE idUsuario = p_idCliente
    ))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El cliente ingresado no se encuentra registrado.',
      MYSQL_ERRNO = 1644;
    ELSE
      SELECT
        idOrden,
        idRestaurante,
        nombreRestaurante,
        fechaFactura,
        subTotal,
        descuento,
        total
      FROM vt_costos_ordenes_compra
      WHERE idCliente = p_idCliente;
    END IF;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getOrdenesCompraRestaurante` */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
CREATE DEFINER = CURRENT_USER PROCEDURE `sp_getOrdenesCompraRestaurante`(IN p_idRestaurante INT)
  COMMENT 'Obtiene una lista con todas las órdenes de compra realizadas por un restaurante.'
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM restaurantes
                   WHERE id = p_idRestaurante
    ))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El restaurante ingresado no se encuentra registrado.',
      MYSQL_ERRNO = 1644;
    ELSE
      SELECT
        idOrden,
        idCliente,
        nombreCliente,
        fechaFactura,
        subTotal,
        descuento,
        total
      FROM vt_costos_ordenes_compra
      WHERE idRestaurante = p_idRestaurante;
    END IF;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getRestaurantesDeCategoria` */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
CREATE DEFINER = CURRENT_USER PROCEDURE `sp_getRestaurantesDeCategoria`(IN p_idCategoria INT)
  COMMENT 'Obtiene una lista de los restaurantes clasificados con una categoría de alimentos.'
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM categorias
                   WHERE id = p_idCategoria
    ))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'La categoría ingresada no se encuentra registrada.',
      MYSQL_ERRNO = 1644;
    ELSE
      /* Tomar en cuenta que puede retornar un conjunto vacío */
      SELECT
        idRestaurante,
        nombreRestaurante
      FROM vt_info_restaurantes
      WHERE idCategoria = p_idCategoria;
    END IF;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getTotalesCarritoComprasClienteRestaurante` */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
CREATE DEFINER = CURRENT_USER PROCEDURE `sp_getTotalesCarritoComprasClienteRestaurante`(IN p_idRestaurante INT,
                                                                                        IN p_idCliente     INT)
  COMMENT 'Obtiene el total de la compra en el carrito de compras del cliente en el restaurante.'
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM restaurantes
                   WHERE id = p_idRestaurante
    ))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El restaurante ingresado no se encuentra registrado.',
      MYSQL_ERRNO = 1644;
    ELSEIF (NOT exists(SELECT 1
                       FROM usuarios_clientes
                       WHERE idUsuario = p_idCliente
    ))
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El cliente ingresado no se encuentra registrado.',
        MYSQL_ERRNO = 1644;
    ELSE
      BEGIN
        SELECT
          idCliente                  AS 'idCliente',
          idRestaurante              AS 'idRestaurante',
          sum(precioTarjetaDetalle)  AS 'totalFacturaTarjeta',
          sum(precioEfectivoDetalle) AS 'totalFacturaEfectivo'
        FROM vt_carritos_compras_clientes
        WHERE (idRestaurante = p_idRestaurante) AND (idCliente = p_idCliente)
        GROUP BY idRestaurante, idCliente;
      END;
    END IF;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getVentasConIngrediente` */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
CREATE DEFINER = CURRENT_USER PROCEDURE `sp_getVentasConIngrediente`(IN p_idIngrediente INT,
                                                                     IN p_idRestaurante INT /* Opcionar: Pasar NULL para ignorar*/,
                                                                     IN p_fechaInicio   DATETIME(0) /* Opcionar: Pasar NULL para ignorar*/,
                                                                     IN p_fechaFin      DATETIME(0) /* Opcionar: Pasar NULL para ignorar*/
)
  COMMENT 'Muestra las ventas realizadas usando un ingrediente en platillos.'
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM ingredientes
                   WHERE id = p_idIngrediente
    ))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El ingrediente ingresado no se encuentra registrado.',
      MYSQL_ERRNO = 1644;
    ELSEIF ((p_idRestaurante IS NOT NULL) AND (NOT exists(SELECT 1
                                                          FROM restaurantes
                                                          WHERE id = p_idRestaurante)
    ))
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El restaurante ingresado no se encuentra registrado.',
        MYSQL_ERRNO = 1644;
    ELSEIF ((p_fechaInicio IS NOT NULL)
            AND (p_fechaFin IS NOT NULL)
            AND (p_fechaInicio > p_fechaFin)
    )
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La fecha de inicio ingresada no puede ser después de la fecha de fin.',
        MYSQL_ERRNO = 1644;
    ELSE
      SELECT
        vt.idOrden,
        vt.idRestaurante,
        vt.nombreRestaurante,
        vt.fechaFactura,
        vt.total
      FROM vt_costos_ordenes_compra vt
        INNER JOIN platillos_ordenes_compra op
          ON vt.idOrden = op.idOrden
        INNER JOIN platillos p
          ON p.id = op.idOrden
        INNER JOIN ingredientes_platillos ip
          ON p.id = ip.idPlatillo
        INNER JOIN ingredientes i
          ON i.id = ip.idIngrediente
      WHERE (i.id = p_idIngrediente)
            AND ((p_idRestaurante IS NULL) OR (vt.idRestaurante = p_idRestaurante))
            AND ((p_fechaInicio IS NULL) OR (p_fechaInicio <= vt.fechaFactura))
            AND ((p_fechaFin IS NULL) OR (p_fechaFin >= vt.fechaFactura));
    END IF;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getVentasGananciasDia` */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
CREATE DEFINER = CURRENT_USER PROCEDURE `sp_getVentasGananciasDia`(IN p_fecha DATETIME(0))
  COMMENT 'Obtiene el reporte de ventas y ganancias de un día.'
  BEGIN
    SELECT
      fechaConsultada,
      idRestaurante,
      nombreRestaurante,
      cantidadOrdenes,
      totalOrdenes,
      gananciasOrdenes
    FROM vt_reportes_diarios_ganancias
    WHERE year(fechaConsultada) = year(p_fecha)
          AND month(fechaConsultada) = month(p_fecha)
          AND day(fechaConsultada) = day(p_fecha);
  END ;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getVentasRestauranteConIngrediente` */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
CREATE DEFINER = CURRENT_USER PROCEDURE `sp_getVentasRestauranteConIngrediente`(IN p_idIngrediente INT,
                                                                                IN p_idRestaurante INT /* Opcionar: Pasar NULL para ignorar*/,
                                                                                IN p_fechaInicio   DATETIME(0) /* Opcionar: Pasar NULL para ignorar*/,
                                                                                IN p_fechaFin      DATETIME(0) /* Opcionar: Pasar NULL para ignorar*/
)
  COMMENT 'Muestra las ventas realizadas usando un ingrediente en platillos vendidos por los restaurantes.\n     Los parámetros opcionales permiten limitar los resultados a un rango de fechas o restaurante.'
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM ingredientes
                   WHERE id = p_idIngrediente
    ))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El ingrediente ingresado no se encuentra registrado.',
      MYSQL_ERRNO = 1644;
    ELSEIF ((p_idRestaurante IS NOT NULL) AND (NOT exists(SELECT 1
                                                          FROM restaurantes
                                                          WHERE id = p_idRestaurante)
    ))
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El restaurante ingresado no se encuentra registrado.',
        MYSQL_ERRNO = 1644;
    ELSEIF ((p_fechaInicio IS NOT NULL)
            AND (p_fechaFin IS NOT NULL)
            AND (p_fechaInicio > p_fechaFin)
    )
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La fecha de inicio ingresada no puede ser después de la fecha de fin.',
        MYSQL_ERRNO = 1644;
    ELSE
      SELECT
        vt.idOrden,
        vt.idRestaurante,
        vt.nombreRestaurante,
        vt.fechaFactura,
        vt.total
      FROM vt_costos_ordenes_compra vt
        INNER JOIN platillos_ordenes_compra op
          ON vt.idOrden = op.idOrden
        INNER JOIN platillos p
          ON p.id = op.idOrden
        INNER JOIN ingredientes_platillos ip
          ON p.id = ip.idPlatillo
        INNER JOIN ingredientes i
          ON i.id = ip.idIngrediente
      WHERE (i.id = p_idIngrediente)
            AND ((p_idRestaurante IS NULL) OR (vt.idRestaurante = p_idRestaurante))
            AND ((p_fechaInicio IS NULL) OR (p_fechaInicio <= vt.fechaFactura))
            AND ((p_fechaFin IS NULL) OR (p_fechaFin >= vt.fechaFactura));
    END IF;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getVentasTotalesRestaurantes` */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
CREATE DEFINER = CURRENT_USER PROCEDURE `sp_getVentasTotalesRestaurantes`(
  IN p_fechaInicio DATETIME(0) /* Opcionar: Dejar NULL para omitir */,
  IN p_fechaFin    DATETIME(0) /* Opcional: Dejar NULL para omitir */
)
  COMMENT 'Consulta las ventas totales de los restaurantes en un intervalo específico.'
  BEGIN
    IF ((p_fechaInicio IS NOT NULL)
        AND (p_fechaFin IS NOT NULL)
        AND (p_fechaInicio > p_fechaFin)
    )
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'La fecha de inicio ingresada no puede ser después de la fecha de fin.',
      MYSQL_ERRNO = 1644;
    ELSE
      SELECT
        idRestaurante,
        nombreRestaurante,
        ifnull(count(idOrden), 0) AS 'cantidadOrdenes',
        ifnull(sum(total), 0)     AS 'totalVentas'
      FROM vt_costos_ordenes_compra vt
      WHERE ((p_fechaInicio IS NULL) OR (p_fechaInicio <= vt.fechaFactura))
            AND ((p_fechaFin IS NULL) OR (p_fechaFin >= vt.fechaFactura))
      GROUP BY vt.idRestaurante;
    END IF;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 DROP PROCEDURE IF EXISTS `sp_loginUsuario` */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
CREATE DEFINER = CURRENT_USER PROCEDURE `sp_loginUsuario`(IN p_eMail NVARCHAR(50), IN p_password NVARCHAR(20))
  COMMENT 'Procedimiento que permite al usuario iniciar sesión.'
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM usuarios
                   WHERE (eMail = p_eMail)))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'El correo electrónico ingresado no se encuentra registrado.',
      MYSQL_ERRNO = 1644;

    ELSEIF (NOT exists(SELECT 1
                       FROM usuarios
                       WHERE ((eMail = p_eMail) AND (pwd = p_password))
    ))
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La contraseña ingresada no es válida.',
        MYSQL_ERRNO = 1644;
    ELSE
      BEGIN
        DECLARE idObtenido INT;
        SET idObtenido = (SELECT id
                          FROM usuarios
                          WHERE (eMail = p_eMail));

        /* Si el idRestaurante retornado es 0, el admin debe ser asignado a un restaurante
				Use sp_asignarAdminARestaurante
            */
        IF (exists(SELECT 1
                   FROM usuarios_administradores
                   WHERE idUsuario = idObtenido))
        THEN
          SELECT
            'admin'                                 AS estado,
            idUsuario                               AS 'idAdministrador',
            'Ha iniciado sesión como administador.' AS msg
          FROM usuarios_administradores
          WHERE idUsuario = idObtenido;

        ELSEIF (exists(SELECT 1
                       FROM usuarios_clientes
                       WHERE idUsuario = idObtenido))
          THEN
            SELECT
              'cliente'                          AS estado,
              idUsuario                          AS 'idCliente',
              'Ha iniciado sesión como cliente.' AS msg
            FROM usuarios_clientes
            WHERE idUsuario = idObtenido;
        ELSE
          SIGNAL SQLSTATE '45000'
          SET MESSAGE_TEXT = 'El usuario ingresado no está asignado a una categoría de usuario.',
          MYSQL_ERRNO = 1644;
        END IF;
      END;
    END IF;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 DROP PROCEDURE IF EXISTS `sp_pagarOrdenConEfectivo` */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
CREATE DEFINER = CURRENT_USER PROCEDURE `sp_pagarOrdenConEfectivo`(IN p_idRestaurante INT, IN p_idCliente INT,
                                                                   IN p_montoRecibido DECIMAL(20, 2))
  COMMENT 'Realiza el pago de la orden de compra del cliente en un restaurante.'
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM carritos_compras c
                     INNER JOIN menu_restaurantes mr
                       ON mr.id = c.idMenu
                   WHERE (c.idCliente = p_idCliente) AND (mr.idRestaurante = p_idRestaurante)
    ))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'No se han ingresado platillos a la orden de compra.',
      MYSQL_ERRNO = 1644;

    /*	No se permitirá agregar la orden si contiene cantidades de comidas que no pueden ser
		producidas en el restaurante por falta de ingredientes.
	*/
    ELSEIF (exists(SELECT 1
                   FROM carritos_compras cc
                     INNER JOIN menu_restaurantes mr
                       ON mr.id = cc.idMenu
                     INNER JOIN ingredientes_platillos ip
                       ON mr.idPlatillo = ip.idPlatillo
                     INNER JOIN inventario_restaurantes inv
                       ON (mr.idRestaurante = inv.idRestaurante) AND (ip.idIngrediente = inv.idIngrediente)
                   WHERE (cc.idCliente = p_idCliente) AND (mr.idRestaurante = p_idRestaurante)
                         AND ((cc.cantidad * ip.cantidadIngrediente) < inv.cantidadDisponible)
    ))
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La orden de compra no puede concretarse por falta de ingredientes.',
        MYSQL_ERRNO = 1644;

    -- Se ingresa menos efectivo de lo necesario.
    ELSEIF (p_montoRecibido < (SELECT sum(precioEfectivoDetalle)
                               FROM vt_carritos_compras_clientes
                               WHERE (idRestaurante = p_idRestaurante) AND (idCliente = p_idCliente)
                               GROUP BY idCliente
    ))
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Se ha ingresado un monto de efectivo menor al necesario.',
        MYSQL_ERRNO = 1644;
    ELSE
      BEGIN
        DECLARE idNuevaOrden INT;

        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
          ROLLBACK;
          RESIGNAL;
        END;

        START TRANSACTION;
        /* Actualizar inventario primero */
        UPDATE inventario_restaurantes inv
          INNER JOIN vt_carritos_compras_clientes vc
            ON inv.idRestaurante = vc.idRestaurante
          INNER JOIN ingredientes_platillos ip
            ON vc.idPlatillo = ip.idPlatillo
        SET inv.cantidadDisponible = inv.cantidadDisponible -
                                     (vc.cantidad * ip.cantidadIngrediente)
        WHERE (vc.idCliente = p_idCliente) AND (vc.idRestaurante = p_idRestaurante);

        /* Crear orden de compra*/
        INSERT INTO ordenes_compra (idCliente, idRestaurante, fechaFactura)
        VALUES (p_idCliente, p_idRestaurante, now());
        SET idNuevaOrden = (SELECT last_insert_id());

        /* Mover contenido de carrito de compras a orden de compras */
        INSERT INTO platillos_ordenes_compra (idOrden, idPlatillo, cantidad, precioUnidad,
                                              descuento, totalDetalle)
          SELECT
            idNuevaOrden,
            idPlatillo,
            cantidad,
            precioUnidadEfectivo,
            descuentoEfectivoDetalle,
            precioEfectivoDetalle
          FROM vt_carritos_compras_clientes
          WHERE (idCliente = p_idCliente) AND (idRestaurante = p_idRestaurante);

        DELETE c
        FROM carritos_compras c
          INNER JOIN menu_restaurantes mr
            ON mr.id = c.idMenu
        WHERE (mr.idRestaurante = p_idRestaurante) AND (c.idCliente = p_idCliente);

        /* Registrar pago efectivo */
        INSERT INTO compras_efectivo_clientes (idOrden, montoRecibido, cambio)
          SELECT
            idNuevaOrden,
            p_montoRecibido,
            (p_montoRecibido - total)
          FROM vt_costos_ordenes_compra
          WHERE idOrden = idNuevaOrden;

        COMMIT;
        SELECT
          idOrden,
          nombreCliente,
          nombreRestaurante,
          fechaFactura,
          subTotal,
          descuento,
          total
        FROM vt_costos_ordenes_compra
        WHERE idOrden = idNuevaOrden;

      END;
    END IF;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;
/*!50003 DROP PROCEDURE IF EXISTS `sp_pagarOrdenConTarjeta` */;
/*!50003 SET @saved_cs_client = @@character_set_client */;
/*!50003 SET @saved_cs_results = @@character_set_results */;
/*!50003 SET @saved_col_connection = @@collation_connection */;
/*!50003 SET character_set_client = utf8 */;
/*!50003 SET character_set_results = utf8 */;
/*!50003 SET collation_connection = utf8_general_ci */;
/*!50003 SET @saved_sql_mode = @@sql_mode */;
/*!50003 SET sql_mode = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */;
DELIMITER ;;
CREATE DEFINER = CURRENT_USER PROCEDURE `sp_pagarOrdenConTarjeta`(IN p_idRestaurante   INT, IN p_idCliente INT,
                                                                  IN p_idEmisorTarjeta INT,
                                                                  IN p_numeroAuth      DECIMAL(16, 0))
  COMMENT 'Paga la orden de compra del cliente en un restaurante con tarjeta de crédito.'
  BEGIN
    IF (NOT exists(SELECT 1
                   FROM carritos_compras c
                     INNER JOIN menu_restaurantes mr
                       ON mr.id = c.idMenu
                   WHERE (c.idCliente = p_idCliente) AND (mr.idRestaurante = p_idRestaurante)
    ))
    THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'No se han ingresado platillos a la orden de compra.',
      MYSQL_ERRNO = 1644;
    /*	No se permitirá agregar la orden si contiene cantidades de comidas que no pueden ser
		producidas en el restaurante por falta de ingredientes.
	*/
    ELSEIF (exists(SELECT 1
                   FROM carritos_compras cc
                     INNER JOIN menu_restaurantes mr
                       ON mr.id = cc.idMenu
                     INNER JOIN ingredientes_platillos ip
                       ON mr.idPlatillo = ip.idPlatillo
                     INNER JOIN inventario_restaurantes inv
                       ON (mr.idRestaurante = inv.idRestaurante) AND (ip.idIngrediente = inv.idIngrediente)
                   WHERE (cc.idCliente = p_idCliente) AND (mr.idRestaurante = p_idRestaurante)
                         AND ((cc.cantidad * ip.cantidadIngrediente) < inv.cantidadDisponible)
    ))
      THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La orden de compra no puede concretarse por falta de ingredientes.',
        MYSQL_ERRNO = 1644;
    ELSE
      BEGIN
        DECLARE idNuevaOrden INT;

        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
          ROLLBACK;
          RESIGNAL;
        END;

        START TRANSACTION;
        /* Actualizar inventario primero */
        UPDATE inventario_restaurantes inv
          INNER JOIN vt_carritos_compras_clientes vc
            ON inv.idRestaurante = vc.idRestaurante
          INNER JOIN ingredientes_platillos ip
            ON vc.idPlatillo = ip.idPlatillo
        SET inv.cantidadDisponible = inv.cantidadDisponible -
                                     (vc.cantidad * ip.cantidadIngrediente)
        WHERE (vc.idCliente = p_idCliente) AND (vc.idRestaurante = p_idRestaurante);

        /* Crear orden de compra*/
        INSERT INTO ordenes_compra (idCliente, idRestaurante, fechaFactura)
        VALUES (p_idCliente, p_idRestaurante, now());
        SET idNuevaOrden = (SELECT last_insert_id());

        /* Mover contenido de carrito de compras a orden de compras */
        INSERT INTO platillos_ordenes_compra (idOrden, idPlatillo, cantidad, precioUnidad,
                                              descuento, totalDetalle)
          SELECT
            idNuevaOrden,
            idPlatillo,
            cantidad,
            precioUnidadTarjeta,
            0,
            precioTarjetaDetalle
          FROM vt_carritos_compras_clientes
          WHERE (idCliente = p_idCliente) AND (idRestaurante = p_idRestaurante);

        DELETE cc
        FROM carritos_compras cc
          INNER JOIN menu_restaurantes mr
            ON mr.id = cc.idMenu
        WHERE (mr.idRestaurante = p_idRestaurante) AND (cc.idCliente = p_idCliente);

        /* Registrar pago tarjeta crédito */
        INSERT INTO compras_tarjeta_clientes (idOrden, idEmisorTarjeta, numeroAutorizacion)
        VALUES (idNuevaOrden, p_idEmisorTarjeta, p_numeroAuth);
        COMMIT;

        SELECT
          idOrden,
          nombreCliente,
          nombreRestaurante,
          fechaFactura,
          subTotal,
          descuento,
          total
        FROM vt_costos_ordenes_compra
        WHERE idOrden = idNuevaOrden;
      END;
    END IF;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode = @saved_sql_mode */;
/*!50003 SET character_set_client = @saved_cs_client */;
/*!50003 SET character_set_results = @saved_cs_results */;
/*!50003 SET collation_connection = @saved_col_connection */;

--
-- Final view structure for view `vt_carritos_compras_clientes`
--

/*!50001 DROP VIEW IF EXISTS `vt_carritos_compras_clientes`*/;
/*!50001 SET @saved_cs_client = @@character_set_client */;
/*!50001 SET @saved_cs_results = @@character_set_results */;
/*!50001 SET @saved_col_connection = @@collation_connection */;
/*!50001 SET character_set_client = utf8 */;
/*!50001 SET character_set_results = utf8 */;
/*!50001 SET collation_connection = utf8_general_ci */;
  /*!50001 CREATE ALGORITHM = UNDEFINED */
  /*!50013 DEFINER = CURRENT_USER
  SQL SECURITY DEFINER */
  /*!50001 VIEW `vt_carritos_compras_clientes` AS
  SELECT
    `cc`.`idCliente`                                     AS `idCliente`,
    `mr`.`idRestaurante`                                 AS `idRestaurante`,
    `mr`.`idPlatillo`                                    AS `idPlatillo`,
    `mr`.`id`                                            AS `idMenu`,
    `cc`.`cantidad`                                      AS `cantidad`,
    `cp`.`nombrePlatillo`                                AS `nombrePlatillo`,
    `cp`.`precioTarjeta`                                 AS `precioUnidadTarjeta`,
    `cp`.`precioEfectivo`                                AS `precioUnidadEfectivo`,
    (`cc`.`cantidad` * `cp`.`precioTarjeta`)             AS `precioTarjetaDetalle`,
    (CASE WHEN (`cd`.`IdCliente` IS NOT NULL)
      THEN ((`cc`.`cantidad` * `cp`.`precioEfectivo`) * 0.65)
     ELSE (`cc`.`cantidad` * `cp`.`precioEfectivo`) END) AS `precioEfectivoDetalle`,
    (CASE WHEN (`cd`.`IdCliente` IS NOT NULL)
      THEN ((`cc`.`cantidad` * `cp`.`precioEfectivo`) * 0.35)
     ELSE 0 END)                                         AS `descuentoEfectivoDetalle`
  FROM (((`carritos_compras` `cc` JOIN `menu_restaurantes` `mr` ON ((`mr`.`id` = `cc`.`idMenu`))) JOIN
    `vt_costos_platillos` `cp` ON ((`mr`.`idPlatillo` = `cp`.`idPlatillo`))) LEFT JOIN `vt_clientes_con_descuentos` `cd`
      ON (((`cc`.`idCliente` = `cd`.`IdCliente`) AND (`mr`.`idRestaurante` = `cd`.`IdRestaurante`)))) */;
/*!50001 SET character_set_client = @saved_cs_client */;
/*!50001 SET character_set_results = @saved_cs_results */;
/*!50001 SET collation_connection = @saved_col_connection */;

--
-- Final view structure for view `vt_clientes_con_descuentos`
--

/*!50001 DROP VIEW IF EXISTS `vt_clientes_con_descuentos`*/;
/*!50001 SET @saved_cs_client = @@character_set_client */;
/*!50001 SET @saved_cs_results = @@character_set_results */;
/*!50001 SET @saved_col_connection = @@collation_connection */;
/*!50001 SET character_set_client = utf8 */;
/*!50001 SET character_set_results = utf8 */;
/*!50001 SET collation_connection = utf8_general_ci */;
  /*!50001 CREATE ALGORITHM = UNDEFINED */
  /*!50013 DEFINER = CURRENT_USER
  SQL SECURITY DEFINER */
  /*!50001 VIEW `vt_clientes_con_descuentos` AS
  SELECT
    `o`.`idCliente`         AS `IdCliente`,
    `o`.`idRestaurante`     AS `IdRestaurante`,
    sum(`p`.`totalDetalle`) AS `AcumuladoCompras`
  FROM (`ordenes_compra` `o` JOIN `platillos_ordenes_compra` `p` ON ((`o`.`id` = `p`.`idOrden`)))
  WHERE ((year(`o`.`fechaFactura`) = year((curdate() - INTERVAL 1 MONTH))) AND
         (month(`o`.`fechaFactura`) = month((curdate() - INTERVAL 1 MONTH))))
  GROUP BY `o`.`idRestaurante`, `o`.`idCliente`
  HAVING (sum(`p`.`totalDetalle`) >= 20000)
  ORDER BY `o`.`idRestaurante`, `o`.`idCliente` */;
/*!50001 SET character_set_client = @saved_cs_client */;
/*!50001 SET character_set_results = @saved_cs_results */;
/*!50001 SET collation_connection = @saved_col_connection */;

--
-- Final view structure for view `vt_costos_ingredientes_platillos`
--

/*!50001 DROP VIEW IF EXISTS `vt_costos_ingredientes_platillos`*/;
/*!50001 SET @saved_cs_client = @@character_set_client */;
/*!50001 SET @saved_cs_results = @@character_set_results */;
/*!50001 SET @saved_col_connection = @@collation_connection */;
/*!50001 SET character_set_client = utf8 */;
/*!50001 SET character_set_results = utf8 */;
/*!50001 SET collation_connection = utf8_general_ci */;
  /*!50001 CREATE ALGORITHM = UNDEFINED */
  /*!50013 DEFINER = CURRENT_USER
  SQL SECURITY DEFINER */
  /*!50001 VIEW `vt_costos_ingredientes_platillos` AS
  SELECT
    `p`.`id`                                                                  AS `idPlatillo`,
    `i`.`id`                                                                  AS `idIngrediente`,
    `p`.`nombre`                                                              AS `NombrePlatillo`,
    `i`.`nombre`                                                              AS `NombreIngrediente`,
    `ip`.`cantidadIngrediente`                                                AS `Cantidad`,
    cast((`ip`.`cantidadIngrediente` * `i`.`precioUnidad`) AS DECIMAL(20, 2)) AS `precioIngrediente`
  FROM
    ((`ingredientes_platillos` `ip` JOIN `ingredientes` `i` ON ((`i`.`id` = `ip`.`idIngrediente`))) JOIN `platillos` `p`
        ON ((`p`.`id` = `ip`.`idPlatillo`))) */;
/*!50001 SET character_set_client = @saved_cs_client */;
/*!50001 SET character_set_results = @saved_cs_results */;
/*!50001 SET collation_connection = @saved_col_connection */;

--
-- Final view structure for view `vt_costos_ordenes_compra`
--

/*!50001 DROP VIEW IF EXISTS `vt_costos_ordenes_compra`*/;
/*!50001 SET @saved_cs_client = @@character_set_client */;
/*!50001 SET @saved_cs_results = @@character_set_results */;
/*!50001 SET @saved_col_connection = @@collation_connection */;
/*!50001 SET character_set_client = utf8 */;
/*!50001 SET character_set_results = utf8 */;
/*!50001 SET collation_connection = utf8_general_ci */;
  /*!50001 CREATE ALGORITHM = UNDEFINED */
  /*!50013 DEFINER = CURRENT_USER
  SQL SECURITY DEFINER */
  /*!50001 VIEW `vt_costos_ordenes_compra` AS
  SELECT
    `o`.`id`                                                                                       AS `idOrden`,
    `c`.`idUsuario`                                                                                AS `idCliente`,
    `r`.`id`                                                                                       AS `idRestaurante`,
    `u`.`nombre`                                                                                   AS `nombreCliente`,
    `r`.`nombre`                                                                                   AS `nombreRestaurante`,
    date_format(`o`.`fechaFactura`, '%d/%m/%Y %r')                                                 AS `fechaFactura`,
    cast(sum((`p`.`cantidad` * `p`.`precioUnidad`)) AS DECIMAL(20, 2))                             AS `subTotal`,
    cast(sum(`p`.`descuento`) AS DECIMAL(20, 2))                                                   AS `descuento`,
    cast(sum(`p`.`totalDetalle`) AS DECIMAL(20, 2))                                                AS `total`,
    cast((sum(`p`.`totalDetalle`) - sum((`p`.`cantidad` * `p`.`precioUnidad`))) AS DECIMAL(20, 2)) AS `ganancias`
  FROM ((((`usuarios_clientes` `c` JOIN `usuarios` `u` ON ((`u`.`id` = `c`.`idUsuario`))) JOIN `ordenes_compra` `o`
      ON ((`c`.`idUsuario` = `o`.`idCliente`))) JOIN `restaurantes` `r` ON ((`r`.`id` = `o`.`idRestaurante`))) JOIN
    `platillos_ordenes_compra` `p` ON ((`o`.`id` = `p`.`idOrden`)))
  GROUP BY `o`.`id` */;
/*!50001 SET character_set_client = @saved_cs_client */;
/*!50001 SET character_set_results = @saved_cs_results */;
/*!50001 SET collation_connection = @saved_col_connection */;

--
-- Final view structure for view `vt_costos_platillos`
--

/*!50001 DROP VIEW IF EXISTS `vt_costos_platillos`*/;
/*!50001 SET @saved_cs_client = @@character_set_client */;
/*!50001 SET @saved_cs_results = @@character_set_results */;
/*!50001 SET @saved_col_connection = @@collation_connection */;
/*!50001 SET character_set_client = utf8 */;
/*!50001 SET character_set_results = utf8 */;
/*!50001 SET collation_connection = utf8_general_ci */;
  /*!50001 CREATE ALGORITHM = UNDEFINED */
  /*!50013 DEFINER = CURRENT_USER
  SQL SECURITY DEFINER */
  /*!50001 VIEW `vt_costos_platillos` AS
  SELECT
    `p`.`id`                                                       AS `idPlatillo`,
    `p`.`nombre`                                                   AS `nombrePlatillo`,
    cast(sum(`vt`.`precioIngrediente`) AS DECIMAL(32, 2))          AS `precioBase`,
    cast(sum((`vt`.`precioIngrediente` * 0.10)) AS DECIMAL(32, 2)) AS `gananciaTarjeta`,
    cast(sum((`vt`.`precioIngrediente` * 0.15)) AS DECIMAL(32, 2)) AS `gananciaEfectivo`,
    cast(sum((`vt`.`precioIngrediente` * 1.10)) AS DECIMAL(32, 2)) AS `precioTarjeta`,
    cast(sum((`vt`.`precioIngrediente` * 1.15)) AS DECIMAL(32, 2)) AS `precioEfectivo`
  FROM (`vt_costos_ingredientes_platillos` `vt` JOIN `platillos` `p` ON ((`vt`.`idPlatillo` = `p`.`id`)))
  GROUP BY `vt`.`idPlatillo` */;
/*!50001 SET character_set_client = @saved_cs_client */;
/*!50001 SET character_set_results = @saved_cs_results */;
/*!50001 SET collation_connection = @saved_col_connection */;

--
-- Final view structure for view `vt_info_restaurantes`
--

/*!50001 DROP VIEW IF EXISTS `vt_info_restaurantes`*/;
/*!50001 SET @saved_cs_client = @@character_set_client */;
/*!50001 SET @saved_cs_results = @@character_set_results */;
/*!50001 SET @saved_col_connection = @@collation_connection */;
/*!50001 SET character_set_client = utf8 */;
/*!50001 SET character_set_results = utf8 */;
/*!50001 SET collation_connection = utf8_general_ci */;
  /*!50001 CREATE ALGORITHM = UNDEFINED */
  /*!50013 DEFINER = CURRENT_USER
  SQL SECURITY DEFINER */
  /*!50001 VIEW `vt_info_restaurantes` AS
  SELECT
    `r`.`id`     AS `idRestaurante`,
    `c`.`id`     AS `idCategoria`,
    `r`.`nombre` AS `nombreRestaurante`
  FROM (`restaurantes` `r` JOIN `categorias` `c` ON ((`c`.`id` = `r`.`idCategoria`))) */;
/*!50001 SET character_set_client = @saved_cs_client */;
/*!50001 SET character_set_results = @saved_cs_results */;
/*!50001 SET collation_connection = @saved_col_connection */;

--
-- Final view structure for view `vt_reportes_diarios_ganancias`
--

/*!50001 DROP VIEW IF EXISTS `vt_reportes_diarios_ganancias`*/;
/*!50001 SET @saved_cs_client = @@character_set_client */;
/*!50001 SET @saved_cs_results = @@character_set_results */;
/*!50001 SET @saved_col_connection = @@collation_connection */;
/*!50001 SET character_set_client = utf8 */;
/*!50001 SET character_set_results = utf8 */;
/*!50001 SET collation_connection = utf8_general_ci */;
  /*!50001 CREATE ALGORITHM = UNDEFINED */
  /*!50013 DEFINER = CURRENT_USER
  SQL SECURITY DEFINER */
  /*!50001 VIEW `vt_reportes_diarios_ganancias` AS
  SELECT
    `vt_costos_ordenes_compra`.`idRestaurante`                         AS `idRestaurante`,
    `vt_costos_ordenes_compra`.`nombreRestaurante`                     AS `nombreRestaurante`,
    date_format(`vt_costos_ordenes_compra`.`fechaFactura`, '%d/%m/%Y') AS `fechaConsultada`,
    count(`vt_costos_ordenes_compra`.`idOrden`)                        AS `cantidadOrdenes`,
    sum(`vt_costos_ordenes_compra`.`total`)                            AS `totalOrdenes`,
    sum(`vt_costos_ordenes_compra`.`ganancias`)                        AS `gananciasOrdenes`
  FROM `vt_costos_ordenes_compra`
  GROUP BY `vt_costos_ordenes_compra`.`idRestaurante`,
    date_format(`vt_costos_ordenes_compra`.`fechaFactura`, '%d/%m/%Y') */;
/*!50001 SET character_set_client = @saved_cs_client */;
/*!50001 SET character_set_results = @saved_cs_results */;
/*!50001 SET collation_connection = @saved_col_connection */;
/*!40103 SET TIME_ZONE = @OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE = @OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS = @OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS = @OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT = @OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS = @OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION = @OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES = @OLD_SQL_NOTES */;

-- Dump completed on 2015-11-15  3:06:26
