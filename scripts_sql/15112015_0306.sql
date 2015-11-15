CREATE DATABASE  IF NOT EXISTS `sistemarestaurantes` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `sistemarestaurantes`;
-- MySQL dump 10.13  Distrib 5.7.9, for Win64 (x86_64)
--
-- Host: localhost    Database: sistemarestaurantes
-- ------------------------------------------------------
-- Server version	5.7.9

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='-06:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `bitacora_cambios`
--

DROP TABLE IF EXISTS `bitacora_cambios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bitacora_cambios` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fechaHora` datetime NOT NULL,
  `idUsuario` int(11) DEFAULT NULL,
  `detalles` varchar(2500) DEFAULT 'Ningún cambio',
  PRIMARY KEY (`id`),
  KEY `FK_Bitacoras_u_idx` (`idUsuario`),
  CONSTRAINT `FK_Bitacoras_u` FOREIGN KEY (`idUsuario`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
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
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `carritos_compras` (
  `idCliente` int(11) NOT NULL,
  `idMenu` int(11) NOT NULL,
  `cantidad` decimal(13,3) NOT NULL DEFAULT '1.000',
  PRIMARY KEY (`idCliente`,`idMenu`),
  KEY `FK_CarritosCompras_m_idx` (`idMenu`),
  CONSTRAINT `FK_CarritosCompras_c` FOREIGN KEY (`idCliente`) REFERENCES `usuarios_clientes` (`idUsuario`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CarritosCompras_m` FOREIGN KEY (`idMenu`) REFERENCES `menu_restaurantes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `carritos_compras`
--

LOCK TABLES `carritos_compras` WRITE;
/*!40000 ALTER TABLE `carritos_compras` DISABLE KEYS */;
/*!40000 ALTER TABLE `carritos_compras` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=CURRENT_USER*/ /*!50003 TRIGGER `sistemarestaurantes`.`carritos_compras_BEFORE_INSERT` BEFORE INSERT ON `carritos_compras` FOR EACH ROW
BEGIN
	if (not exists (select 1 from usuarios_clientes
			where (idUsuario = new.idCliente)
		)) then
        signal	sqlstate '45000'
			set	message_text = 'El cliente ingresado no se encuentra registrado.',
				mysql_errno = 1644;
	elseif (not exists (select 1 from menu_restaurantes
			where (id = new.idMenu)
		)) then
        signal	sqlstate '45000'
			set	message_text = 'La entrada de menú ingresada no se encuentra registrada.',
				mysql_errno = 1644;
	elseif (exists (select 1 from menu_restaurantes
			where (idCliente = new.idCliente) and (idMenu = new.idMenu)
		)) then
		signal	sqlstate '45000'
			set	message_text = 'El producto ingresado ya se encuentra asociado al carrito del cliente.',
				mysql_errno = 1644;
	elseif (new.cantidad <= 0) then
		signal	sqlstate '45000'
			set	message_text = 'La cantidad ingresada no debe ser menor a uno.',
				mysql_errno = 1644;
	end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=CURRENT_USER*/ /*!50003 TRIGGER `sistemarestaurantes`.`carritos_compras_BEFORE_DELETE` BEFORE DELETE ON `carritos_compras` FOR EACH ROW
BEGIN
	if (not exists (select 1 from usuarios_clientes
			where (idUsuario = old.idCliente)
		)) then
        signal	sqlstate '45000'
			set	message_text = 'El cliente ingresado no se encuentra registrado.',
				mysql_errno = 1644;
	elseif (not exists (select 1 from menu_restaurantes
			where (id = old.idMenu)
		)) then
        signal	sqlstate '45000'
			set	message_text = 'La entrada de menú ingresada no se encuentra registrada.',
				mysql_errno = 1644;
	end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `categorias`
--

DROP TABLE IF EXISTS `categorias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `categorias` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Identificador autogenerado de la categoría de alimentos.',
  `nombre` varchar(50) NOT NULL COMMENT 'Nombre de la categoría de alimentos.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre_UNIQUE` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 COMMENT='Tabla con registro de categorías de alimentos/ingredientes.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categorias`
--

LOCK TABLES `categorias` WRITE;
/*!40000 ALTER TABLE `categorias` DISABLE KEYS */;
INSERT INTO `categorias` VALUES (11,'Barbacoa'),(4,'Cerdo'),(6,'Frutas'),(7,'Granos'),(3,'Pescado'),(2,'Pollo'),(9,'Repostería Dulce'),(10,'Repostería Salada'),(1,'Res'),(13,'Salsas'),(12,'Sopas'),(8,'Tubérculos'),(5,'Vegetales Verdes');
/*!40000 ALTER TABLE `categorias` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=CURRENT_USER*/ /*!50003 TRIGGER `sistemarestaurantes`.`categorias_BEFORE_INSERT` BEFORE INSERT ON `categorias` FOR EACH ROW
BEGIN
	if (exists (select 1 from categorias where nombre = new.nombre)) then
		signal	sqlstate '45000'
			set	message_text = 'La categoría ingresada ya se encuentra registrada.',
				mysql_errno = 1644;
	end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `categorias_ingredientes`
--

DROP TABLE IF EXISTS `categorias_ingredientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `categorias_ingredientes` (
  `idIngrediente` int(11) NOT NULL COMMENT 'Identificador del ingrediente.',
  `idCategoria` int(11) NOT NULL COMMENT 'Identificador de la categoría de alimentos.',
  PRIMARY KEY (`idIngrediente`),
  KEY `FK_CategoriasIngredientes_c_idx` (`idCategoria`),
  CONSTRAINT `FK_CategoriasIngredientes_c` FOREIGN KEY (`idCategoria`) REFERENCES `categorias` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CategoriasIngredientes_i` FOREIGN KEY (`idIngrediente`) REFERENCES `restaurantes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Tabla para clasificar los ingredientes registrados con categorias de ingredientes.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categorias_ingredientes`
--

LOCK TABLES `categorias_ingredientes` WRITE;
/*!40000 ALTER TABLE `categorias_ingredientes` DISABLE KEYS */;
/*!40000 ALTER TABLE `categorias_ingredientes` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=CURRENT_USER*/ /*!50003 TRIGGER `sistemarestaurantes`.`categorias_ingredientes_BEFORE_INSERT` BEFORE INSERT ON `categorias_ingredientes` FOR EACH ROW
BEGIN
	if (not exists (select 1
		from categorias
        where id = new.idCategoria
        )) then
        signal	sqlstate '45000'
			set	message_text = 'La categoría seleccionada no se encuentra registrada.',
				mysql_errno = 1644;
	elseif (not exists (select 1
		from ingredientes
        where id = new.idIngrediente
        )) then
        signal	sqlstate '45000'
			set	message_text = 'El ingrediente ingresado no se encuentra registrado.',
				mysql_errno = 1644;
	elseif (exists (select 1
		from categorias_ingredientes
        where (idIngrediente = new.idIngrediente)
        )) then
        signal	sqlstate '45000'
			set	message_text = 'El ingrediente ingresado ya se encuentra clasificado.',
				mysql_errno = 1644;
	end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=CURRENT_USER*/ /*!50003 TRIGGER `sistemarestaurantes`.`categorias_ingredientes_BEFORE_UPDATE` BEFORE UPDATE ON `categorias_ingredientes` FOR EACH ROW
BEGIN
	if (not exists (select 1
		from categorias
        where id = new.idCategoria
        )) then
        signal	sqlstate '45000'
			set	message_text = 'La categoría seleccionada no se encuentra registrada.',
				mysql_errno = 1644;
	elseif (not exists (select 1
		from ingredientes
        where id = new.idIngrediente
        )) then
        signal	sqlstate '45000'
			set	message_text = 'El ingrediente ingresado no se encuentra registrado.',
				mysql_errno = 1644;
	elseif (exists (select 1
		from categorias_ingredientes
        where (idIngrediente = new.idIngrediente)
        )) then
        signal	sqlstate '45000'
			set	message_text = 'El ingrediente ingresado ya se encuentra clasificado.',
				mysql_errno = 1644;
	end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=CURRENT_USER*/ /*!50003 TRIGGER `sistemarestaurantes`.`categorias_ingredientes_AFTER_UPDATE` AFTER UPDATE ON `categorias_ingredientes` FOR EACH ROW
BEGIN
	if (old.idCategoria != new.idCategoria) then
    	/* Borra los platillos de los menús de los restaurantes donde 
        la categoría no está soportada */
		delete mr
			from menu_restaurantes mr
				inner join ingredientes_platillos ip
					on ip.idPlatillo = mr.idPlatillo
				inner join categorias_ingredientes ci
					on ip.idIngrediente = ci.idIngrediente
				left join categorias_ingredientes_restaurantes cr
					on cr.idCategoria = ci.idCategoria
			where (ci.idCategoria = new.idCategoria) and (cr.idCategoria is null);
	end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `categorias_ingredientes_restaurantes`
--

DROP TABLE IF EXISTS `categorias_ingredientes_restaurantes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `categorias_ingredientes_restaurantes` (
  `idRestaurante` int(11) NOT NULL COMMENT 'Identificador del restaurante.',
  `idCategoria` int(11) NOT NULL COMMENT 'Identificador de la categoría de comida que puede usar el restaurante.',
  PRIMARY KEY (`idRestaurante`,`idCategoria`),
  KEY `FK_CatIngRest_CatIng_idx` (`idCategoria`),
  CONSTRAINT `FK_CatIngRest_CatIng` FOREIGN KEY (`idCategoria`) REFERENCES `categorias` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_CatIngRest_Rest` FOREIGN KEY (`idRestaurante`) REFERENCES `restaurantes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Tabla que define los tipos de ingredientes que pueden servirse en los restaurantes.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categorias_ingredientes_restaurantes`
--

LOCK TABLES `categorias_ingredientes_restaurantes` WRITE;
/*!40000 ALTER TABLE `categorias_ingredientes_restaurantes` DISABLE KEYS */;
/*!40000 ALTER TABLE `categorias_ingredientes_restaurantes` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=CURRENT_USER*/ /*!50003 TRIGGER `sistemarestaurantes`.`categorias_ingredientes_restaurantes_BEFORE_INSERT` BEFORE INSERT ON `categorias_ingredientes_restaurantes` FOR EACH ROW
BEGIN
	if (not exists (select 1
		from categorias
        where id = new.idCategoria
        )) then
        signal	sqlstate '45000'
			set	message_text = 'La categoría seleccionada no se encuentra registrada.',
				mysql_errno = 1644;
	elseif (not exists (select 1
		from restaurantes
        where id = new.idRestaurante
        )) then
        signal	sqlstate '45000'
			set	message_text = 'El restaurante ingresado no se encuentra registrado.',
				mysql_errno = 1644;
	elseif (exists (select 1
		from categorias_ingredientes_restaurantes
        where (idRestaurante = new.idRestaurante) and (idCategoria = new.idCategoria)
        )) then
        signal	sqlstate '45000'
			set	message_text = 'La categoría ingresada ya se encuentra asociada al restaurante.',
				mysql_errno = 1644;
	end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=CURRENT_USER*/ /*!50003 TRIGGER `sistemarestaurantes`.`categorias_ingredientes_restaurantes_BEFORE_UPDATE` BEFORE UPDATE ON `categorias_ingredientes_restaurantes` FOR EACH ROW
BEGIN
	if (not exists (select 1
		from categorias
        where id = new.idCategoria
        )) then
        signal	sqlstate '45000'
			set	message_text = 'La categoría seleccionada no se encuentra registrada.',
				mysql_errno = 1644;
	elseif (not exists (select 1
		from restaurantes
        where id = new.idRestaurante
        )) then
        signal	sqlstate '45000'
			set	message_text = 'El restaurante ingresado no se encuentra registrado.',
				mysql_errno = 1644;
	elseif (exists (select 1
		from categorias_ingredientes_restaurantes
        where (idRestaurante = new.idRestaurante) and (idCategoria = new.idCategoria)
        )) then
        signal	sqlstate '45000'
			set	message_text = 'La categoría ingresada ya se encuentra asociada al restaurante.',
				mysql_errno = 1644;
	end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=CURRENT_USER*/ /*!50003 TRIGGER `sistemarestaurantes`.`categorias_ingredientes_restaurantes_AFTER_UPDATE` AFTER UPDATE ON `categorias_ingredientes_restaurantes` FOR EACH ROW
BEGIN
	if (old.idCategoria != new.idCategoria) then
		delete mr
			from menu_restaurantes mr
				inner join ingredientes_platillos ip
					on (ip.idPlatillo = mr.idPlatillo)
				inner join categorias_ingredientes ci
					on (ip.idPlatillo = ci.idPlatillo)
				left join categorias_ingredientes_restaurantes cr
					on (ci.idCategoria = cr.idPlatillo)
			where (cr.idRestaurante = old.idRestaurante) 
				and (cr.idCategoria is null);
    end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=CURRENT_USER*/ /*!50003 TRIGGER `sistemarestaurantes`.`categorias_ingredientes_restaurantes_AFTER_DELETE` AFTER DELETE ON `categorias_ingredientes_restaurantes` FOR EACH ROW
BEGIN
    	/* Borra los platillos de los menús de los restaurantes donde 
        la categoría no está soportada */
		delete mr
			from menu_restaurantes mr
				inner join ingredientes_platillos ip
					on (ip.idPlatillo = mr.idPlatillo)
				inner join categorias_ingredientes ci
					on (ip.idPlatillo = ci.idPlatillo)
				inner join categorias_ingredientes_restaurantes cr
					on (ci.idCategoria = cr.idPlatillo)
			where (cr.idRestaurante = old.idRestaurante) 
				and (cr.idCategoria = old.idCategoria);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `compras_efectivo_clientes`
--

DROP TABLE IF EXISTS `compras_efectivo_clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `compras_efectivo_clientes` (
  `idOrden` int(11) NOT NULL,
  `montoRecibido` decimal(20,2) NOT NULL DEFAULT '0.00',
  `cambio` decimal(20,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`idOrden`),
  CONSTRAINT `FK_ComprasEfectivoClientes` FOREIGN KEY (`idOrden`) REFERENCES `ordenes_compra` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `compras_efectivo_clientes`
--

LOCK TABLES `compras_efectivo_clientes` WRITE;
/*!40000 ALTER TABLE `compras_efectivo_clientes` DISABLE KEYS */;
/*!40000 ALTER TABLE `compras_efectivo_clientes` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=CURRENT_USER*/ /*!50003 TRIGGER `sistemarestaurantes`.`compras_efectivo_clientes_BEFORE_INSERT` BEFORE INSERT ON `compras_efectivo_clientes` FOR EACH ROW
BEGIN
	if (not exists (select 1
		from ordenes_compra
        where id = new.idOrden
        )) then
        signal	sqlstate '45000'
			set	message_text = 'El número de orden ingresado no se encuentra registrado.',
				mysql_errno = 1644;
	elseif (exists (select 1
		from compras_efectivo_clientes
		where idOrden = new.idOrden
        )) then
        signal	sqlstate '45000'
			set	message_text = 'La orden ingresada ya se encuentra cancelada.',
				mysql_errno = 1644;
	elseif (exists (select 1
		from compras_tarjeta_clientes
        where idOrden = new.idOrden
        )) then
        signal	sqlstate '45000'
			set	message_text = 'La orden ingresada ya se encuentra cancelada con tarjeta.',
				mysql_errno = 1644;
	elseif (new.montoRecibido < (select total
		from vt_costos_ordenes_compra
        where idOrden = new.idOrden
        )) then
        signal	sqlstate '45000'
			set	message_text = 'El monto recibido es menor al costo total de la orden.',
				mysql_errno = 1644;
	end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `compras_tarjeta_clientes`
--

DROP TABLE IF EXISTS `compras_tarjeta_clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `compras_tarjeta_clientes` (
  `idOrden` int(11) NOT NULL,
  `idEmisorTarjeta` decimal(2,0) DEFAULT NULL,
  `numeroAutorizacion` decimal(16,0) NOT NULL,
  PRIMARY KEY (`idOrden`),
  KEY `FK_ComprasTarjetaClientes_t_idx` (`idEmisorTarjeta`),
  CONSTRAINT `FK_ComprasTarjetaClientes_t` FOREIGN KEY (`idEmisorTarjeta`) REFERENCES `emisores_tarjetas` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `compras_tarjeta_clientes`
--

LOCK TABLES `compras_tarjeta_clientes` WRITE;
/*!40000 ALTER TABLE `compras_tarjeta_clientes` DISABLE KEYS */;
/*!40000 ALTER TABLE `compras_tarjeta_clientes` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=CURRENT_USER*/ /*!50003 TRIGGER `sistemarestaurantes`.`compras_tarjeta_clientes_BEFORE_INSERT` BEFORE INSERT ON `compras_tarjeta_clientes` FOR EACH ROW
BEGIN
	if (not exists (select 1
		from ordenes_compra
        where id = new.idOrden
        )) then
        signal	sqlstate '45000'
			set	message_text = 'El número de orden ingresado no se encuentra registrado.',
				mysql_errno = 1644;
	elseif (exists (select 1
		from emisores_tarjetas
        where id = new.idEmisorTarjeta
        )) then
        signal	sqlstate '45000'
			set	message_text = 'El emisor de tarjetas ingresado no se encuentra registrado.',
				mysql_errno = 1644;
	elseif (exists (select 1
		from compras_tarjeta_clientes
        where idOrden = new.idOrden
        )) then
        signal	sqlstate '45000'
			set	message_text = 'La orden ingresada ya se encuentra cancelada.',
				mysql_errno = 1644;      
	elseif (exists (select 1
		from compras_efectivo_clientes
		where (idEmisorTarjeta = new.idEmisorTarjeta) and (numeroAutorizacion = new.numeroAutorizacion)
        )) then
        signal	sqlstate '45000'
			set	message_text = 'El número de autorización ingresado ya está en uso.',
				mysql_errno = 1644;
	end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `descuentos_clientes_aplicados`
--

DROP TABLE IF EXISTS `descuentos_clientes_aplicados`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `descuentos_clientes_aplicados` (
  `idOrden` int(11) NOT NULL,
  PRIMARY KEY (`idOrden`),
  CONSTRAINT `FK_DescuentosClientesAplicados` FOREIGN KEY (`idOrden`) REFERENCES `ordenes_compra` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Registro de las órdenes de compra a las cuales se le aplica el descuento.';
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
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emisores_tarjetas` (
  `id` decimal(2,0) NOT NULL,
  `nombre` varchar(30) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre_UNIQUE` (`nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emisores_tarjetas`
--

LOCK TABLES `emisores_tarjetas` WRITE;
/*!40000 ALTER TABLE `emisores_tarjetas` DISABLE KEYS */;
INSERT INTO `emisores_tarjetas` VALUES (4,'American Express'),(5,'Dinner´s Club'),(2,'MasterCard'),(1,'N/A'),(3,'VISA');
/*!40000 ALTER TABLE `emisores_tarjetas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ingredientes`
--

DROP TABLE IF EXISTS `ingredientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ingredientes` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Identificador del restaurante',
  `nombre` varchar(50) NOT NULL COMMENT 'Nombre del restaurante',
  `precioUnidad` decimal(8,2) NOT NULL DEFAULT '100.00' COMMENT 'Precio por unidad (cantidad: 1.00) del ingrediente seleccionado.',
  `urlFoto` varchar(200) DEFAULT NULL COMMENT 'URL de la foto del ingrediente. La URL debe ser de un sitio web, ya sea del sitio web donde corre el programa o un sitio web externo.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre_UNIQUE` (`nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Tabla con el registro de ingredientes.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ingredientes`
--

LOCK TABLES `ingredientes` WRITE;
/*!40000 ALTER TABLE `ingredientes` DISABLE KEYS */;
/*!40000 ALTER TABLE `ingredientes` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=CURRENT_USER*/ /*!50003 TRIGGER `sistemarestaurantes`.`ingredientes_BEFORE_INSERT` BEFORE INSERT ON `ingredientes` FOR EACH ROW
BEGIN
	if (exists (select 1 from ingredientes where nombre = new.nombre)) then
		signal	sqlstate '45000'
			set	message_text = 'El ingrediente ingresado ya se encuentra registrado.',
				mysql_errno = 1644;

    elseif (new.precioUnidad <= 0) then
		signal	sqlstate '45000'
			set	message_text = 'El precio por unidad del ingrediente no puede ser menor o igual a cero.',
				mysql_errno = 1644;
	end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=CURRENT_USER*/ /*!50003 TRIGGER `sistemarestaurantes`.`ingredientes_BEFORE_UPDATE` BEFORE UPDATE ON `ingredientes` FOR EACH ROW
BEGIN
	if (exists (select 1 from ingredientes where nombre = new.nombre)) then
		signal	sqlstate '45000'
			set	message_text = 'El ingrediente ingresado ya se encuentra registrado.',
				mysql_errno = 1644;

    elseif (new.precioUnidad <= 0) then
		signal	sqlstate '45000'
			set	message_text = 'El precio por unidad del ingrediente no puede ser menor o igual a cero.',
				mysql_errno = 1644;
	end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `ingredientes_platillos`
--

DROP TABLE IF EXISTS `ingredientes_platillos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ingredientes_platillos` (
  `idPlatillo` int(11) NOT NULL COMMENT 'Identificador del platillo.',
  `idIngrediente` int(11) NOT NULL COMMENT 'Identificador del ingrediente del platillo.',
  `cantidadIngrediente` decimal(10,3) NOT NULL DEFAULT '1.000' COMMENT 'Cantidad del ingrediente necesaria para el platillo.',
  PRIMARY KEY (`idPlatillo`,`idIngrediente`),
  KEY `FK_IngredientesPlatillos_i_idx` (`idIngrediente`),
  CONSTRAINT `FK_IngredientesPlatillos_i` FOREIGN KEY (`idIngrediente`) REFERENCES `ingredientes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_IngredientesPlatillos_p` FOREIGN KEY (`idPlatillo`) REFERENCES `platillos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ingredientes_platillos`
--

LOCK TABLES `ingredientes_platillos` WRITE;
/*!40000 ALTER TABLE `ingredientes_platillos` DISABLE KEYS */;
/*!40000 ALTER TABLE `ingredientes_platillos` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=CURRENT_USER*/ /*!50003 TRIGGER `sistemarestaurantes`.`ingredientes_platillos_BEFORE_INSERT` BEFORE INSERT ON `ingredientes_platillos` FOR EACH ROW
BEGIN
	if (not exists (select 1 from ingredientes where id = new.idIngrediente)) then
		signal	sqlstate '45000'
			set	message_text = 'El ingrediente ingresado no se encuentra registrado.',
				mysql_errno = 1644;
	
    elseif (not exists (select 1 from platillos where id = new.idPlatillo)) then
		signal	sqlstate '45000'
			set	message_text = 'El platillo ingresado no se encuentra registrado.',
				mysql_errno = 1644;
	elseif (not exists (select 1 from categorias_ingredientes
				where (idIngrediente = new.idIngrediente)
        )) then
        signal	sqlstate '45000'
			set	message_text = 'El ingrediente ingresado no tiene clasificación.',
				mysql_errno = 1644;
	
    elseif (exists (select 1 from ingredientes_platillos
			where (idPlatillo = new.idPlatillo) and (idIngrediente = new.idIngrediente)
            )) then
		signal	sqlstate '45000'
			set	message_text = 'El ingrediente ingresado ya forma parte de este platillo.',
				mysql_errno = 1644;
    end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=CURRENT_USER*/ /*!50003 TRIGGER `sistemarestaurantes`.`ingredientes_platillos_AFTER_INSERT` AFTER INSERT ON `ingredientes_platillos` FOR EACH ROW
BEGIN
	delete mr
		from menu_restaurantes mr
			inner join ingredientes_platillos ip
				on ip.idPlatillo = mr.idPlatillo
			inner join categorias_ingredientes ci
				on ip.idIngrediente = ci.idIngrediente
			left join inventario_restaurantes ir
				on ip.idIngrediente = ir.idIngrediente
			left join categorias_ingredientes_restaurantes cr
				on cr.idCategoria = ci.idCategoria
		where (ip.idPlatillo = new.idPlatillo)
			and (ip.idIngrediente = new.idIngrediente) 
            and ((cr.idCategoria is null) or (ir.idIngrediente is null));
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `inventario_restaurantes`
--

DROP TABLE IF EXISTS `inventario_restaurantes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `inventario_restaurantes` (
  `idRestaurante` int(11) NOT NULL COMMENT 'Identificador del restaurante asociado.',
  `idIngrediente` int(11) NOT NULL COMMENT 'Identificador del ingrediente asociado al restaurante.',
  `cantidadDisponible` decimal(13,3) NOT NULL DEFAULT '0.000' COMMENT 'Cantidad disponible del ingrediente asociado.',
  PRIMARY KEY (`idRestaurante`,`idIngrediente`),
  KEY `FK_InventarioRestuarantes_i_idx` (`idIngrediente`),
  CONSTRAINT `FK_InventarioRestaurantes_r` FOREIGN KEY (`idRestaurante`) REFERENCES `restaurantes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_InventarioRestuarantes_i` FOREIGN KEY (`idIngrediente`) REFERENCES `ingredientes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventario_restaurantes`
--

LOCK TABLES `inventario_restaurantes` WRITE;
/*!40000 ALTER TABLE `inventario_restaurantes` DISABLE KEYS */;
/*!40000 ALTER TABLE `inventario_restaurantes` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=CURRENT_USER*/ /*!50003 TRIGGER `sistemarestaurantes`.`inventario_restaurantes_BEFORE_INSERT` BEFORE INSERT ON `inventario_restaurantes` FOR EACH ROW
BEGIN
	if	(not exists (select 1 from restaurantes where id = new.idRestaurante)) then
		signal	sqlstate '45000'
			set	message_text = 'El restaurante ingresado no se encuentra registrado.',
				mysql_errno = 1644;
                
	elseif (not exists (select 1 from ingredientes where id = new.idIngrediente)) then
		signal	sqlstate '45000'
			set	message_text = 'El ingrediente ingresado no se encuentra registrado.',
				mysql_errno = 1644;
	elseif (not exists (select 1
		from categorias_ingredientes_restaurantes cir
			inner join categorias_ingredientes ci
				on ci.idCategoria = cir.idCategoria
			inner join restaurantes r
				on r.id = cir.idRestaurante
		where (cir.idRestaurante = new.idRestaurante) and (ci.idIngrediente = new.idIngrediente)
        )) then
			signal	sqlstate '45000'
				set	message_text = 'El ingrediente ingresado no forma parte de las categorías registradas para el restaurante.',
					mysql_errno = 1644;
	elseif (exists (select 1
		from inventario_restaurantes
        where (idRestaurante = new.idRestaurante) and (idIngrediente = new.idIngrediente)
        )) then
			signal	sqlstate '45000'
				set	message_text = 'El ingrediente ingresado ya forma parte del inventario del restaurante seleccionado.',
					mysql_errno = 1644;
	end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `menu_restaurantes`
--

DROP TABLE IF EXISTS `menu_restaurantes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `menu_restaurantes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `idRestaurante` int(11) NOT NULL,
  `idPlatillo` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_MenuRestaurantes` (`idRestaurante`,`idPlatillo`),
  KEY `FK_MenuRestaurantes_p_idx` (`idPlatillo`),
  CONSTRAINT `FK_MenuRestaurantes_p` FOREIGN KEY (`idPlatillo`) REFERENCES `platillos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_MenuRestaurantes_r` FOREIGN KEY (`idRestaurante`) REFERENCES `restaurantes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `menu_restaurantes`
--

LOCK TABLES `menu_restaurantes` WRITE;
/*!40000 ALTER TABLE `menu_restaurantes` DISABLE KEYS */;
/*!40000 ALTER TABLE `menu_restaurantes` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=CURRENT_USER*/ /*!50003 TRIGGER `sistemarestaurantes`.`menu_restaurantes_BEFORE_INSERT` BEFORE INSERT ON `menu_restaurantes` FOR EACH ROW
BEGIN
	-- El restaurante debe estar registrado.
	if	(not exists (select 1 from restaurantes where id = new.idRestaurante)) then
		signal	sqlstate '45000'
			set	message_text = 'El restaurante ingresado no se encuentra registrado.',
				mysql_errno = 1644;
	-- El platillo debe estar registrado.
    elseif (not exists (select 1 from platillos where id = new.idPlatillo)) then
		signal	sqlstate '45000'
			set	message_text = 'El platillo ingresado no se encuentra registrado.',
				mysql_errno = 1644;
	-- El platillo debe contener ingredientes de una categoría aceptada para el restaurante.
	elseif (not exists (select 1
		from ingredientes_platillos ip
			inner join categorias_ingredientes ci
				on ci.idIngrediente = ip.idIngrediente
			inner join categorias_ingredientes_restaurantes cr
				on (ci.idCategoria = cr.idCategoria)
		where (ip.idPlatillo = new.idPlatillo)
			and (cr.idRestaurante = new.idRestaurante)
        )) then
		signal	sqlstate '45000'
			set	message_text = 'El platillo ingresado tiene ingredientes que no son utilizados por el restaurante seleccionado.',
				mysql_errno = 1644;
                
	-- El platillo contiene ingredientes que no están en el inventario del restaurante
    elseif (not exists (select 1
		from ingredientes_platillos ip
			inner join inventario_restaurantes ir
				on ip.idIngrediente = ir.idIngrediente
			where (ip.idPlatillo = new.idPlatillo) and (ir.idRestaurante = new.idRestaurante)
		)) then
        signal sqlstate '45000'
			set message_text = 'El platillo ingresado tiene ingredientes que no forma parte del inventario del restaurante.',
				mysql_errno = 1644;
    
    -- El platillo no debe haber sido registrado antes.
    elseif (exists (select 1
		from menu_restaurantes
		where (idRestaurante = new.idRestaurante) and (idPlatillo = new.idPlatillo)
        )) then
        signal	sqlstate '45000'
			set	message_text = 'El platillo ingresado ya forma parte del menú del restaurante seleccionado.',
				mysql_errno = 1644;
    end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `ordenes_compra`
--

DROP TABLE IF EXISTS `ordenes_compra`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ordenes_compra` (
  `id` int(11) NOT NULL,
  `idCliente` int(11) DEFAULT NULL,
  `idRestaurante` int(11) DEFAULT NULL,
  `fechaFactura` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_OrdenesCompra_r_idx` (`idRestaurante`),
  KEY `FK_OrdenesCompra_c` (`idCliente`),
  CONSTRAINT `FK_OrdenesCompra_c` FOREIGN KEY (`idCliente`) REFERENCES `usuarios_clientes` (`idUsuario`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `FK_OrdenesCompra_r` FOREIGN KEY (`idRestaurante`) REFERENCES `restaurantes` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ordenes_compra`
--

LOCK TABLES `ordenes_compra` WRITE;
/*!40000 ALTER TABLE `ordenes_compra` DISABLE KEYS */;
/*!40000 ALTER TABLE `ordenes_compra` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=CURRENT_USER*/ /*!50003 TRIGGER `sistemarestaurantes`.`ordenes_compra_BEFORE_INSERT` BEFORE INSERT ON `ordenes_compra` FOR EACH ROW
BEGIN
	if (not exists (select 1
		from usuarios_clientes
        where idUsuario = new.idCliente
		)) then
        signal	sqlstate '45000'
			set	message_text = 'El cliente ingresado no se encuentra registrado.',
				mysql_errno = 1644;
	elseif (not exists (select 1
		from restaurantes
        where id = new.idRestaurante
        )) then
        signal	sqlstate '45000'
			set	message_text = 'El restaurante ingresado no se encuentra registrado.',
				mysql_errno = 1644;
	elseif (isnull(fechaFactura)) then
		signal	sqlstate '45000'
			set	message_text = 'Debe ingresar la fecha de registro.',
				mysql_errno = 1644;
    end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `platillos`
--

DROP TABLE IF EXISTS `platillos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `platillos` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Identificador autogenerado del platillo.',
  `nombre` varchar(45) NOT NULL COMMENT 'Nombre del platillo.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `Platilloscol_UNIQUE` (`nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `platillos`
--

LOCK TABLES `platillos` WRITE;
/*!40000 ALTER TABLE `platillos` DISABLE KEYS */;
/*!40000 ALTER TABLE `platillos` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=CURRENT_USER*/ /*!50003 TRIGGER `sistemarestaurantes`.`platillos_BEFORE_INSERT` BEFORE INSERT ON `platillos` FOR EACH ROW
BEGIN
	if (exists (select 1
		from platillos
        where nombre = new.nombre
        )) then
        signal	sqlstate '45000'
			set	message_text = 'El platillo ingresado ya se encuentra registrado.',
				mysql_errno = 1644;
	end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `platillos_ordenes_compra`
--

DROP TABLE IF EXISTS `platillos_ordenes_compra`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `platillos_ordenes_compra` (
  `idOrden` int(11) NOT NULL,
  `idPlatillo` int(11) NOT NULL,
  `cantidad` decimal(13,3) NOT NULL DEFAULT '1.000',
  `precioUnidad` decimal(8,2) NOT NULL DEFAULT '0.00',
  `descuento` decimal(3,0) NOT NULL DEFAULT '0',
  `totalDetalle` decimal(20,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`idOrden`),
  UNIQUE KEY `UK_PlatillosOrdenesCompra` (`idOrden`,`idPlatillo`),
  KEY `FK_PlatillosOrdenesCompra_p_idx` (`idPlatillo`),
  CONSTRAINT `FK_PlatillosOrdenesCompra_o` FOREIGN KEY (`idOrden`) REFERENCES `ordenes_compra` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_PlatillosOrdenesCompra_p` FOREIGN KEY (`idPlatillo`) REFERENCES `platillos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `platillos_ordenes_compra`
--

LOCK TABLES `platillos_ordenes_compra` WRITE;
/*!40000 ALTER TABLE `platillos_ordenes_compra` DISABLE KEYS */;
/*!40000 ALTER TABLE `platillos_ordenes_compra` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=CURRENT_USER*/ /*!50003 TRIGGER `sistemarestaurantes`.`platillos_ordenes_compra_BEFORE_INSERT` BEFORE INSERT ON `platillos_ordenes_compra` FOR EACH ROW
BEGIN
	if (not exists (select 1
		from ordenes
        where id = new.idOrden
        )) then
        signal	sqlstate '45000'
			set	message_text = 'El número de orden de compra ingresado no se encuentra registrado.',
				mysql_errno = 1644;
	elseif (not exists (select 1
		from platillos
        where id = new.idPlatillo
        )) then
        signal	sqlstate '45000'
			set	message_text = 'El platillo ingresado no se encuentra registrado.',
				mysql_errno = 1644;
	elseif (exists (select 1
		from platillos_ordenes_compra
        where (idOrden = new.idOrden) and (idPlatillo = new.idPlatillo)
        )) then
        signal	sqlstate '45000'
			set	message_text = 'El platillo ingresado ya forma parte del pedido.',
				mysql_errno = 1644;
	elseif (new.cantidad <= 0) then
		signal sqlstate '45000'
			set message_text = 'La cantidad ingresada debe ser mayor que cero.',
				mysql_errno = 1644;
	end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `restaurantes`
--

DROP TABLE IF EXISTS `restaurantes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `restaurantes` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Identificador autogenerado del restaurante.',
  `nombre` varchar(50) NOT NULL COMMENT 'Nombre del restaurante.',
  `direccion` varchar(200) NOT NULL COMMENT 'Dirección del restaurante.',
  `idCategoria` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre_UNIQUE` (`nombre`),
  KEY `FK_Restaurantes_idx` (`idCategoria`),
  CONSTRAINT `FK_Restaurantes` FOREIGN KEY (`idCategoria`) REFERENCES `categorias` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `restaurantes`
--

LOCK TABLES `restaurantes` WRITE;
/*!40000 ALTER TABLE `restaurantes` DISABLE KEYS */;
INSERT INTO `restaurantes` VALUES (1,'Restaurante1','abc1234',1);
/*!40000 ALTER TABLE `restaurantes` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=CURRENT_USER*/ /*!50003 TRIGGER `sistemarestaurantes`.`restaurantes_BEFORE_INSERT` BEFORE INSERT ON `restaurantes` FOR EACH ROW
BEGIN
	if	(not exists (select 1 from categorias where id = new.idCategoria)) then
		signal	sqlstate '45000'
			set	message_text = 'La categoría ingresada no se encuentra registrada.',
				mysql_errno = 1644;
	elseif	(exists (select 1 from restaurantes where nombre = new.nombre)) then
		signal	sqlstate '45000'
			set	message_text = 'El restaurante ingresado ya se encuentra registrado.',
				mysql_errno = 1644;
    end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `eMail` varchar(50) NOT NULL,
  `nombre` varchar(30) NOT NULL,
  `apellidos` varchar(100) NOT NULL,
  `pwd` varchar(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_Usuarios` (`eMail`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT INTO `usuarios` VALUES (1,'hola1@abc.com','Hola','Mundo','abc123'),(2,'cyka@blyat.ru','ayy','lmao','pwd123');
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=CURRENT_USER*/ /*!50003 TRIGGER `sistemarestaurantes`.`usuarios_BEFORE_INSERT` BEFORE INSERT ON `usuarios` FOR EACH ROW
BEGIN
	if (exists (select 1 from usuarios where eMail = new.eMail)) then
		signal	sqlstate '45000'
			set	message_text = 'El e-mail ingresado ya se encuentra registrado.',
				mysql_errno = 1644;
	end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=CURRENT_USER*/ /*!50003 TRIGGER `sistemarestaurantes`.`usuarios_BEFORE_UPDATE` BEFORE UPDATE ON `usuarios` FOR EACH ROW
BEGIN
	if (not exists (select 1 from usuarios where eMail = new.eMail)) then
		signal	sqlstate '45000'
			set	message_text = 'El e-mail ingresado no se encuentra registrado.',
				mysql_errno = 1644;
	end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `usuarios_administradores`
--

DROP TABLE IF EXISTS `usuarios_administradores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usuarios_administradores` (
  `idUsuario` int(11) NOT NULL,
  PRIMARY KEY (`idUsuario`),
  CONSTRAINT `FK_UsuariosAdministradores_u` FOREIGN KEY (`idUsuario`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Tabla para registrar los usuarios administradores asignados a cada restaurante.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios_administradores`
--

LOCK TABLES `usuarios_administradores` WRITE;
/*!40000 ALTER TABLE `usuarios_administradores` DISABLE KEYS */;
INSERT INTO `usuarios_administradores` VALUES (2);
/*!40000 ALTER TABLE `usuarios_administradores` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=CURRENT_USER*/ /*!50003 TRIGGER `sistemarestaurantes`.`usuarios_administradores_BEFORE_INSERT` BEFORE INSERT ON `usuarios_administradores` FOR EACH ROW
BEGIN
	if (not exists(select 1 
			from usuarios 
            where id = new.idUsuario
		)) then
		signal	sqlstate '45000'
			set	message_text = 'El usuario ingresado no se encuentra registrado.',
				mysql_errno = 1644;
	elseif (exists (select 1 
				from usuarios_clientes
				where idUsuario = new.idUsuario
            )) then
            signal	sqlstate '45000'
				set	message_text = 'El usuario registrado ya es un cliente.',
					mysql_errno = 1644;
	elseif (exists (select 1
				from usuarios_administradores
				where idUsuario = new.idUsuario
			)) then
            signal	sqlstate '45000'
				set	message_text = 'El usuario registrado ya es un administrador.',
					mysql_errno = 1644;
    end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=CURRENT_USER*/ /*!50003 TRIGGER `sistemarestaurantes`.`usuarios_administradores_BEFORE_UPDATE` BEFORE UPDATE ON `usuarios_administradores` FOR EACH ROW
BEGIN
	if (not exists(select 1 
			from usuarios 
            where id = new.idUsuario
		)) then
		signal	sqlstate '45000'
			set	message_text = 'El usuario ingresado no se encuentra registrado.',
				mysql_errno = 1644;
	elseif (exists (select 1 
				from usuarios_clientes
				where idUsuario = new.idUsuario
            )) then
            signal	sqlstate '45000'
				set	message_text = 'El usuario ingresado no es un administrador.',
					mysql_errno = 1644;
	end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `usuarios_clientes`
--

DROP TABLE IF EXISTS `usuarios_clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usuarios_clientes` (
  `idUsuario` int(11) NOT NULL,
  `numeroTelefono` decimal(8,0) NOT NULL,
  PRIMARY KEY (`idUsuario`),
  CONSTRAINT `FK_UsuariosClientes` FOREIGN KEY (`idUsuario`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios_clientes`
--

LOCK TABLES `usuarios_clientes` WRITE;
/*!40000 ALTER TABLE `usuarios_clientes` DISABLE KEYS */;
INSERT INTO `usuarios_clientes` VALUES (1,12345678);
/*!40000 ALTER TABLE `usuarios_clientes` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=CURRENT_USER*/ /*!50003 TRIGGER `sistemarestaurantes`.`usuarios_clientes_BEFORE_INSERT` BEFORE INSERT ON `usuarios_clientes` FOR EACH ROW
BEGIN
	if (not exists(select 1 
			from usuarios 
            where id = new.idUsuario
		)) then
		signal	sqlstate '45000'
			set	message_text = 'El usuario ingresado no se encuentra registrado.',
				mysql_errno = 1644;
	elseif (exists (select 1
				from usuarios_administradores
				where idUsuario = new.idUsuario
			)) then
            signal	sqlstate '45000'
				set	message_text = 'El usuario registrado ya es un administrador.',
					mysql_errno = 1644;
	elseif (exists (select 1 
				from usuarios_clientes
				where idUsuario = new.idUsuario
            )) then
            signal	sqlstate '45000'
				set	message_text = 'El usuario registrado ya es un cliente.',
					mysql_errno = 1644;
    end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=CURRENT_USER*/ /*!50003 TRIGGER `sistemarestaurantes`.`usuarios_clientes_BEFORE_UPDATE` BEFORE UPDATE ON `usuarios_clientes` FOR EACH ROW
BEGIN
	if (not exists(select 1 
			from usuarios 
            where id = new.idUsuario
		)) then
		signal	sqlstate '45000'
			set	message_text = 'El usuario ingresado no se encuentra registrado.',
				mysql_errno = 1644;
	elseif (exists (select 1 
				from usuarios_administradores
				where idUsuario = new.idUsuario
            )) then
            signal	sqlstate '45000'
				set	message_text = 'El usuario ingresado no es un cliente.',
					mysql_errno = 1644;
	end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Temporary view structure for view `vt_carritos_compras_clientes`
--

DROP TABLE IF EXISTS `vt_carritos_compras_clientes`;
/*!50001 DROP VIEW IF EXISTS `vt_carritos_compras_clientes`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `vt_carritos_compras_clientes` AS SELECT 
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
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `vt_clientes_con_descuentos` AS SELECT 
 1 AS `IdCliente`,
 1 AS `IdRestaurante`,
 1 AS `AcumuladoCompras`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vt_costos_ingredientes_platillos`
--

DROP TABLE IF EXISTS `vt_costos_ingredientes_platillos`;
/*!50001 DROP VIEW IF EXISTS `vt_costos_ingredientes_platillos`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `vt_costos_ingredientes_platillos` AS SELECT 
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
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `vt_costos_ordenes_compra` AS SELECT 
 1 AS `idOrden`,
 1 AS `idCliente`,
 1 AS `idRestaurante`,
 1 AS `NombreCliente`,
 1 AS `NombreRestaurante`,
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
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `vt_costos_platillos` AS SELECT 
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
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `vt_info_restaurantes` AS SELECT 
 1 AS `idRestaurante`,
 1 AS `idCategoria`,
 1 AS `NombreRestaurante`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vt_reportes_diarios_ganancias`
--

DROP TABLE IF EXISTS `vt_reportes_diarios_ganancias`;
/*!50001 DROP VIEW IF EXISTS `vt_reportes_diarios_ganancias`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `vt_reportes_diarios_ganancias` AS SELECT 
 1 AS `idRestaurante`,
 1 AS `NombreRestaurante`,
 1 AS `fechaConsultada`,
 1 AS `cantidadOrdenes`,
 1 AS `totalOrdenes`,
 1 AS `gananciasOrdenes`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping routines for database 'sistemarestaurantes'
--
/*!50003 DROP PROCEDURE IF EXISTS `sp_agregarCategoria` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_agregarCategoria`(in p_idAdmin int, in p_nombre nvarchar(50))
    COMMENT 'Crea una nueva categoría de alimentos.'
BEGIN
	if (not exists (select 1
			from usuarios_administradores 
            where idUsuario = p_idAdmin
		)) then
		signal	sqlstate '45000'
			set	message_text = 'El usuario registrado no existe o no tiene autorización para esta operación.',
				mysql_errno = 1644;
	else
		begin
			declare idObtenido int;
			declare exit handler for sqlexception
				begin
					rollback;
					resignal;
				end;
			start transaction;
				insert into categorias(nombre)
					values (p_nombre);
				set idObtenido = (select last_insert_id());
				
                insert into bitacora_cambios(fechaHora, idUsuario, detalles)
					select now(), u.id, 
						concat("El administrador ", u.nombre, " ", u.apellidos, " ha creado el restaurante \"",
								r.nombre, "\".")
						from usuarios u, restaurantes r
                        where u.id = p_idNombre and r.id = idObtenido;
			commit;
			
			select id, nombre
				from categorias
				where id = idObtenido;
		end;
	end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_agregarCategoriaAdmitidaEnRestaurante` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_agregarCategoriaAdmitidaEnRestaurante`(in p_idAdmin int, in p_idRestaurante int, in p_idCategoria int)
    COMMENT 'Agrega una categoría de alimentos a la lista de categorías que administra un restaurante.'
BEGIN
	if (not exists (select 1
			from usuarios_administradores 
            where idUsuario = p_idAdmin
		)) then
		signal	sqlstate '45000'
			set	message_text = 'El usuario registrado no existe o no tiene autorización para esta operación.',
				mysql_errno = 1644;
	else
		begin
			declare exit handler for sqlexception
				begin
					rollback;
					resignal;
				end;
			
			start transaction;
				insert into categorias_ingredientes_restaurantes(idRestaurante, idCategoria)
					values (p_idRestaurante, p_idCategoria);
				
				insert into bitacora_cambios(fechaHora, idUsuario, detalles)
					select now(), p_idAdmin, concat("El administrador ", u.nombre, " ", u.apellidos,
						"agregó la categoría \"", c.nombre, "\" a la lista de categorías aceptadas por el
                         restaurante ", r.nombre, ".")
						from usuarios u, categorias c, restaurantes r
                        where (u.id = p_idAdmin) and (c.id = p_idCategoria) and (r.id = p_idRestaurante);
			commit;
		end;
	end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_agregarCategoriaAIngrediente` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_agregarCategoriaAIngrediente`(in p_idIngrediente int, in p_idCategoria int)
    COMMENT 'Clasifica el ingrediente ingresado a la categoría ingresada.'
BEGIN
	declare exit handler for sqlexception
		begin
			rollback;
            resignal;
        end;
	start transaction;
		insert into categorias_ingredientes(idIngrediente, idCategoria)
			values (p_idIngrediente, p_idCategoria);
    commit;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_agregarDetalleMenuACarrito` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_agregarDetalleMenuACarrito`(in p_idAdmin int, in p_idCliente int, in p_idMenu int, in p_cantidad int)
    COMMENT 'Agrega la comida del menú al carrito de compras (orden temporal) del cliente para un restaurante.'
BEGIN
	if (not exists (select 1
			from usuarios_administradores 
            where idUsuario = p_idAdmin
		)) then
		signal	sqlstate '45000'
			set	message_text = 'El usuario registrado no existe o no tiene autorización para esta operación.',
				mysql_errno = 1644;
	elseif (exists (select 1 from carritos_compras
			where (idCliente = p_idCliente) and (idMenu = p_idMenu)
		)) then
		begin
			start transaction;
				update carritos_compras
					set cantidad = cantidad + p_cantidad
					where (idCliente = p_idCliente) and (idMenu = p_idMenu);
				
				set @nombreCompletoAdmin = (select concat(nombre, " ", apellidos) from usuarios
					where u.id = p_idAmin);
				set @nombreCompletoCliente = (select concat(nombre, " ", apellidos) from usuarios
					where u.id = p_idCliente);
				
				insert into bitacora_cambios(fechaHora, idUsuario, detalles)
					select now(), p_idAdmin, concat("El administrador ", @nombreCompletoAdmin, " agregó ",
						p_cantidad, " unidades del platillo ", p.nombre, " a la orden del cliente ",
						@nombreCompletoCliente, " del restaurante ", r.nombre, ".")
						from usuarios u
							inner join carritos_compras cc
								on u.id = cc.idCliente
							inner join menu_restaurantes mr
								on mr.id = cc.idMenu
							inner join platillos p
								on p.id = mr.idPlatillo
							inner join restaurantes r
								on r.id = mr.idRestaurante
							where (mr.id = p_idMenu);
			commit;
			
			select cantidad, nombrePlatillo, precioTarjetaDetalle, precioEfectivoDetalle
				from vt_carritos_compras_clientes
				where (idCliente = p_idCliente) and (idMenu = p_idMenu);
		end;

	else
		begin
			declare exit handler for sqlexception
				begin
					rollback;
                    resignal;
				end;
                
			start transaction;
				insert into carritos_compras(idCliente, idMenu, cantidad)
					values (p_idCliente, p_idMenu, p_cantidad);
                    
				set @nombreCompletoAdmin = (select concat(nombre, " ", apellidos) 
					from usuarios
                    where u.id = p_idAmin);
				set @nombreCompletoCliente = (select concat(nombre, " ", apellidos) 
					from usuarios
					where u.id = p_idCliente);
				
				insert into bitacora_cambios(fechaHora, idUsuario, detalles)
					select now(), p_idAdmin, concat("El administrador ", @nombreCompletoAdmin, 
                    " agregó ", p_cantidad, " unidades del platillo ", p.nombre, 
                    " a la orden del cliente ", @nombreCompletoCliente, " del restaurante ", 
                    r.nombre, ".")
						from usuarios u
							inner join carritos_compras cc
								on u.id = cc.idCliente
							inner join menu_restaurantes mr
								on mr.id = cc.idMenu
							inner join platillos p
								on p.id = mr.idPlatillo
							inner join restaurantes r
								on r.id = mr.idRestaurante
							where (mr.id = p_idMenu);
            commit;
            
			select cantidad, nombrePlatillo, precioTarjetaDetalle, precioEfectivoDetalle
				from vt_carritos_compras_clientes
				where (idCliente = p_idCliente) and (idMenu = p_idMenu);
        end;
	end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_agregarIngrediente` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_agregarIngrediente`(in p_idAdmin int, in p_nombre nvarchar(50), in p_precioUnidad decimal(8,2),
    in p_urlFoto nvarchar(200), in p_idCategoria int)
    COMMENT 'Agrega un nuevo ingrediente al sistema.'
BEGIN
	if (not exists (select 1
			from usuarios_administradores 
            where idUsuario = p_idAdmin
		)) then
		signal	sqlstate '45000'
			set	message_text = 'El usuario registrado no existe o no tiene autorización para esta operación.',
				mysql_errno = 1644;
	else
		begin
			declare idObtenido int;
			
			declare exit handler for sqlexception
				begin
					rollback;
					resignal;
				end;
			start transaction;
				insert into ingredientes(nombre, precioUnidad, urlFoto)
					values (p_nombre, p_precioUnidad, p_urlFoto);
                    
				set idObtenido = (select last_insert_id());
                
                insert into categorias_ingredientes(idIngrediente, idCategoria)
					values (idObtenido, p_idCategoria);
                
                insert into bitacora_cambios(fechaHora, idUsuario, detalles)
					select now(), p_idAdmin, concat("El administrador ", u.nombre, 
                    " agregó el ingrediente ", i.nombre, " al sistema.")
						from usuarios u, ingredientes i
                        where (u.id = p_idAdmin) and (i.id = idObtenido);
			commit;
			
			select id, nombre, precioUnidad
				from ingredientes
				where id = idObtenido;
		end;
    end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_agregarIngredienteAInventario` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_agregarIngredienteAInventario`(in p_idAdmin int, 
		in p_idRestaurante int, in p_idIngrediente int, 
        in p_cantidadDisponible decimal(13,3))
    COMMENT 'Agrega un nuevo ingrediente al inventario del restaurante.'
BEGIN
	if (not exists (select 1
			from usuarios_administradores 
            where idUsuario = p_idAdmin
		)) then
		signal	sqlstate '45000'
			set	message_text = 'El usuario registrado no existe o no tiene autorización para esta operación.',
				mysql_errno = 1644;
	else
		begin
			declare exit handler for sqlexception
				begin
					rollback;
					resignal;
				end;
			start transaction;
				insert into inventario_restaurantes(idRestaurante, idIngrediente, cantidadDisponible)
					values (p_idRestaurante, p_idIngrediente, p_cantidadDisponible);

				insert into bitacora_cambios(fechaHora, idUsuario, detalles)
					select now(), p_idUsuario, concat("El administrador ", u.nombre, " ", u.apellidos,
						"ha insertado el ingrediente ", i.nombre, " al inventario del restaurante ",
						r.nombre, ".")
						from ingredientes i, restaurantes r, usuarios u
						where (i.id = p_idIngrediente) and (r.id = p_idRestaurante) 
							and (u.id = p_idUsuario);
			commit;
				/* Se retorna un conjunto resultado con la nueva entrada de inventario */
				select idRestaurante, idIngrediente, cantidadDisponible
					from inventario_restaurante
					where (idRestaurante = p_idRestaurante) and (idIngrediente = p_idIngrediente);
		end;
	end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_agregarIngredienteAPlatillo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_agregarIngredienteAPlatillo`(in p_idAdmin int, in p_idPlatillo int, in p_idIngrediente int, in p_cantidad decimal(10,3))
    COMMENT 'Agrega un ingrediente a la receta de un platillo.'
BEGIN
	if (not exists (select 1
			from usuarios_administradores 
            where idUsuario = p_idAdmin
		)) then
		signal	sqlstate '45000'
			set	message_text = 'El usuario registrado no existe o no tiene autorización para esta operación.',
				mysql_errno = 1644;
	else	
        begin
			declare exit handler for sqlexception
				begin
					rollback;
					resignal;
				end;
			
			start transaction;
				insert into ingredientes_platillos(idPlatillo, idIngrediente, cantidadIngrediente)
					values (p_idPlatillo, p_idIngrediente, p_cantidad);
                    
				insert into bitacora_cambios(fechaHora, idUsuario, detalles)
					select now(), p_idAdmin, concat("El administrador ", u.nombre, " ", u.apellidos,
						" agregó el ingrediente ", i.nombre, " al platillo ", p.nombre,
                        " y se actualizó el menú de los restaurantes que no permiten el ingrediente.")
						from usuarios u, ingredientes i, platillos p
						where (u.id = p_idAdmin) and (i.id = p_idIngrediente) and (p.id = p_idPlatillo);
			commit;
		end;
    end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_agregarPlatilloAMenuRestaurante` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_agregarPlatilloAMenuRestaurante`(in p_idAdmin int, in p_idRestaurante int, in p_idPlatillo int)
    COMMENT 'Agrega un nuevo platillo al menú del restaurante.'
BEGIN
	if (not exists (select 1
			from usuarios_administradores 
            where idUsuario = p_idAdmin
		)) then
		signal	sqlstate '45000'
			set	message_text = 'El usuario registrado no existe o no tiene autorización para esta operación.',
				mysql_errno = 1644;
	else
		begin
			declare idObtenido int;
			declare exit handler for sqlexception
				begin
					rollback;
					resignal;
				end;
			start transaction;
				insert into menu_restaurantes(idRestaurante, idPlatillo)
					values (p_idRestaurante, p_idPlatillo);
				set idObtenido = (select last_insert_id());
                
                insert into bitacora_cambios(fechaHora, idUsuario, detalles)
					select now(), p_idAdmin, concat("El administrador ", u.nombre, " ", u.apellidos,
						" agregó el platillo ", p.nombre, " al menú del restaurante ",
                        r.nombre, ".")
						from platiilos p, restaurantes r, usuarios u
						where (p.id = p_idPlatillo) and (r.id = p_idRestaurante)
							and (u.id = p_idAdmin);
			commit;
			
			select idRestaurante, idPlatillo
				from menu_restaurantes
				where id = idObtenido;
		end;
	end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_agregarRestaurante` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_agregarRestaurante`(in p_idAdmin int, in p_nombre nvarchar(50), in p_direccion nvarchar(200), in p_idCategoria int)
    COMMENT 'Agrega un nuevo restaurante en el sistema.'
BEGIN
	if (not exists (select 1
			from usuarios_administradores 
            where idUsuario = p_idAdmin
		)) then
		signal	sqlstate '45000'
			set	message_text = 'El usuario registrado no existe o no tiene autorización para esta operación.',
				mysql_errno = 1644;
	else
		begin
			declare idObtenido int;
			declare exit handler for sqlexception
				begin
					rollback;
					resignal;
				end;
				
			start transaction;
				insert into restaurantes(nombre, direccion, idCategoria)
					values (p_nombre, p_direccion, p_idCategoria);
				set idObtenido = (select last_insert_id());
				
				/* La categoría del restaurante pasa a ser el primer tipo de ingredientes aceptado */
				insert into categorias_ingredientes_restaurantes(idRestaurante, idCategoria)
					values (idObtenido, p_idCategoria);
                    
				insert into bitacora_cambios(fechaHora, idUsuario, detalles)
					select now(), p_idAdmin, concat("El administrador ", u.nombre, " ", u.apellidos,
						" agregó el restaurante ", r.nombre, " en el sistema.")
						from usuarios u, restaurante r
                        where (u.id = p_idAdmin) and (r.id = idObtenido);
			commit;
		end;
	end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_agregarUsuario` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_agregarUsuario`(in p_idAdmin int, in p_nombre nvarchar(50), in p_apellidos nvarchar(100), 
		in p_eMail nvarchar(50), in p_password nvarchar(20))
    COMMENT 'Registra a un nuevo usuario en el sistema.'
BEGIN
	if (not exists (select 1
			from usuarios_administradores 
            where idUsuario = p_idAdmin
		)) then
		signal	sqlstate '45000'
			set	message_text = 'El usuario registrado no existe o no tiene autorización para esta operación.',
				mysql_errno = 1644;
	else
		begin
			declare exit handler for sqlexception
				begin
					rollback;
					resignal;
				end;
			start transaction;
				insert into usuarios(eMail, nombre, apellidos, pwd)
					values (p_eMail, p_nombre, p_apellidos, p_password);
                    
				set @nombreCompletoAdmin = (select concat(nombre, " ", apellidos)
					from usuarios
                    where id = p_idAdmin);
				set @nombreCompletoUsuario = (select concat(p_nombre, " ", p_apellidos));
                
                insert into bitacora_cambios(fechaHora, idUsuario, detalles)
					values (now(), p_idAdmin, concat("El administrador ", @nombreCompletoAdmin,
						" ha creado el usuario ", @nombreCompletoUsuario, " en el sistema."));
			commit;
		end;
	end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_agregarUsuarioAdministrador` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_agregarUsuarioAdministrador`(in p_idAdmin int, in p_nombre nvarchar(50), in p_apellidos nvarchar(100),
		in p_eMail nvarchar(50), in p_password nvarchar(20))
    COMMENT 'Registra un nuevo usuario administrador al sistema.'
BEGIN
	if (not exists (select 1
			from usuarios_administradores 
            where idUsuario = p_idAdmin
		)) then
		signal	sqlstate '45000'
			set	message_text = 'El usuario registrado no existe o no tiene autorización para esta operación.',
				mysql_errno = 1644;
	else
		begin
			declare idGenerado int;
			
			declare exit handler for sqlexception
				begin
					rollback;
					resignal;
				end;
			
			start transaction;
				call sp_agregarUsuario(p_idAdmin, p_nombre, p_apellidos, p_eMail, p_password);
				set idGenerado = last_insert_id();	/* Obtiene el último valor de una columna auto-generada/identidad */ 
				call sp_asignarUsuarioAdministrador(p_idAdmin, idGenerado);
			commit;
			
			/* Si el usuario fue creado, selecciona su correo y el identificador generado. */
			select u.id, u.eMail
				from usuarios u
					inner join usuarios_administradores a
						on u.id = a.idUsuario
				where u.id = idGenerado;
		end;
    end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_agregarUsuarioCliente` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_agregarUsuarioCliente`(in p_idAdmin int, in p_nombre nvarchar(50), in p_apellidos nvarchar(100), 
     in p_eMail nvarchar(50), in p_password nvarchar(20), in p_numeroTelefono decimal(8,0))
    COMMENT 'Registra un nuevo usuario cliente al sistema.'
BEGIN
	if (not exists (select 1
			from usuarios_administradores 
            where idUsuario = p_idAdmin
		)) then
		signal	sqlstate '45000'
			set	message_text = 'El usuario registrado no existe o no tiene autorización para esta operación.',
				mysql_errno = 1644;
	else
		begin
			declare idGenerado int;
			
			declare exit handler for sqlexception
				begin
					rollback;
					resignal;
				end;
			
			start transaction;
				call sp_agregarUsuario(p_idAdmin, p_nombre, p_apellidos, p_eMail, p_password);
				set idGenerado = (select last_insert_id());
				call sp_asignarUsuarioCliente(p_idAdmin, idGenerado, p_numeroTelefono);
			commit;
            
			/* Si el usuario fue creado, selecciona su correo y el identificador generado */
			select u.id, u.eMail
				from usuarios u
					inner join usuarios_clientes c
						on u.id = c.idUsuario
				where u.id = idGenerado;
		end;
    end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_asignarCategoriaAIngrediente` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_asignarCategoriaAIngrediente`(in p_idAdmin int, in p_idIngrediente int, in p_idCategoria int)
    COMMENT 'Clasifica el ingrediente ingresado a la categoría ingresada.'
BEGIN
	if (not exists (select 1
			from usuarios_administradores 
            where idUsuario = p_idAdmin
		)) then
		signal	sqlstate '45000'
			set	message_text = 'El usuario registrado no existe o no tiene autorización para esta operación.',
				mysql_errno = 1644;
	else
		begin
	declare exit handler for sqlexception
		begin
			rollback;
            resignal;
        end;
			start transaction;
				insert into categorias_ingredientes(idIngrediente, idCategoria)
					values (p_idIngrediente, p_idCategoria);
                    
				insert into bitacoras_cambios(fechaHora, idUsuario, detalles)
					select now(), p_idAdmin, concat("El administrador ", u.nombre, " ", u.apellidos,
						" asignó la categoría ", c.nombre, " al ingrediente ", i.nombre, ".")
                        from usuarios u, categorias c, ingredientes i
						where (u.id = p_idAdmin) and (c.id = p_idCategoria) 
                            and (i.id = p_idIngrediente);
			commit;
		end;
	end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_asignarUsuarioAdministrador` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_asignarUsuarioAdministrador`(in p_idAdmin int, in p_idUsuario int)
    COMMENT 'Asigna a un nuevo usuario derechos de administrador.'
BEGIN
	if (not exists (select 1
			from usuarios_administradores 
            where idUsuario = p_idAdmin
		)) then
		signal	sqlstate '45000'
			set	message_text = 'El usuario registrado no existe o no tiene autorización para esta operación.',
				mysql_errno = 1644;
	else
		begin
			declare exit handler for sqlexception
				begin
					rollback;
					resignal;
				end;

			start transaction;
				insert into usuarios_administradores (idUsuario)
					values (p_idUsuario);
				
				set @nombreCompletoAdmin = (select concat(nombre, " ", apellidos) from usuarios
					where u.id = p_idAdmin);
				set @nombreCompletoUsuario = (select concat(nombre, " ", apellidos) from usuarios
					where u.id = p_idUsuario);
				
                insert into bitacora_cambios(fechaHora, idUsuario, detalles)
					values(now(), p_idAdmin, concat("El administrador ", @nombreCompletoAdmin,
						" ha designado al usuario ", @nombreCompletoUsuario, 
                        " como un administrador.")
                        );
			commit;
		end;
	end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_asignarUsuarioCliente` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_asignarUsuarioCliente`(in p_idAdmin int, in p_idUsuario int, in p_numeroTelefono decimal(8,0))
    COMMENT 'Agrega un nuevo usuario cliente al sistema.'
BEGIN
	if (not exists (select 1
			from usuarios_administradores 
            where idUsuario = p_idAdmin
		)) then
		signal	sqlstate '45000'
			set	message_text = 'El usuario registrado no existe o no tiene autorización para esta operación.',
				mysql_errno = 1644;
	else
		begin
			declare exit handler for sqlexception
				begin
					rollback;
					resignal;
				end;

			start transaction;
				insert into usuarios_clientes (idUsuario, numeroTelefono)
					values (p_idUsuario, p_numeroTelefono);
				
				set @nombreCompletoAdmin = (select concat(nombre, " ", apellidos) from usuarios
					where u.id = p_idAdmin);
				set @nombreCompletoUsuario = (select concat(nombre, " ", apellidos) from usuarios
					where u.id = p_idUsuario);
				
                insert into bitacora_cambios(fechaHora, idUsuario, detalles)
					values(now(), p_idAdmin, concat("El administrador ", @nombreCompletoAdmin,
						" ha designado al usuario ", @nombreCompletoUsuario, 
                        " como un cliente.")
                        );
			commit;
		end;
	end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_borrarCarritoComprasClienteEnRestaurante` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_borrarCarritoComprasClienteEnRestaurante`(in p_idRestaurante int, in p_idCliente int)
    COMMENT 'Borra el carrito de compras del cliente en un restaurante.'
BEGIN
	if (not exists (select 1
			from usuarios_administradores 
            where idUsuario = p_idAdmin
		)) then
		signal	sqlstate '45000'
			set	message_text = 'El usuario registrado no existe o no tiene autorización para esta operación.',
				mysql_errno = 1644;

	elseif (not exists (select 1 from usuarios_clientes
			where (idUsuario = p_idCliente)
		)) then
        signal	sqlstate '45000'
			set	message_text = 'El cliente ingresado no se encuentra registrado.',
				mysql_errno = 1644;
	elseif (not exists (select 1 from restaurantes
			where (id = p_idRestaurante)
		)) then
        signal	sqlstate '45000'
			set message_text = 'El restaurante ingresado no se encuentra registrado.',
				mysql_errno = 1644;
	else
		begin
			declare exit handler for sqlexception
				begin
					rollback;
					resignal;
				end;

			start transaction;
				delete c
					from carritos_compras c
						inner join vt_carritos_compras_clientes vt
							on m.id = vt.idMenu
					where (vt.idRestaurante = p_idRestaurante) and (c.idCliente = p_idCliente);
				
				set @nombreCompletoAdmin = (select concat(nombre, " ", apellidos) from usuarios
					where id = p_idAdmin);
				set @nombreCompletoCliente = (select concat(nombre, " ", apellidos) from usuarios
					where id = p_idCliente);
				
				insert into bitacora_cambios(fechaHora, idUsuario, detalles)
					select now(), p_idAdmin, concat("El administrador ", @nombreCompletoAdmin, 
					" ha borrado la lista de productos de la orden del cliente ",  @nombreCompletoCliente,
					" del restaurante ", r.nombre, ".")
						from restaurantes
						where r.id = p_idRestaurante;
			commit;
		end;
	end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_borrarDetalleCarritoComprasClienteEnRestaurante` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_borrarDetalleCarritoComprasClienteEnRestaurante`(in p_idAdmin int, in p_idCliente int, in p_idMenu int)
    COMMENT 'Borra un detalle del carrito de compras de un cliente.'
BEGIN
	if (not exists (select 1 from usuarios_administradores 
            where idUsuario = p_idAdmin
		)) then
		signal	sqlstate '45000'
			set	message_text = 'El usuario registrado no existe o no tiene autorización para esta operación.',
				mysql_errno = 1644;
	elseif (not exists (select 1 from usuarios_clientes
			where (idUsuario = p_idCliente)
		)) then
        signal	sqlstate '45000'
			set	message_text = 'El cliente ingresado no se encuentra registrado.',
				mysql_errno = 1644;
	elseif (not exists (select 1 from restaurantes
			where (id = p_idRestaurante)
		)) then
        signal	sqlstate '45000'
			set message_text = 'El restaurante ingresado no se encuentra registrado.',
				mysql_errno = 1644;
	else
		begin
        	declare exit handler for sqlexception
				begin
					rollback;
					resignal;
				end;
        
			start transaction;
				delete
					from carritos_compras
					where (idCliente = p_idCliente) and (idMenu = p_idMenu);
                    
                set @nombreCompletoAdmin = (select concat(nombre, " ", apellidos)
					from usuarios
                    where id = p_idAdmin);
				set @nombreCompletoCliente = (select concat(nombre, " ", apellidos)
					from usuarios
                    where id = p_idCliente);
				
				insert into bitacora_cambios(fechaHora, idUsuario, detalles)
					select now(), p_idAdmin, concat("El administrado ", @nombreCompletoAdmin, 
							"ha eliminado el platillo ", p.nombre, " de la orden del cliente ", 
                            @nombreCompletoCliente, " del restaurante ", r.nombre, ".")
						from carritos_compras cc
							inner join menu_restaurantes mr
								on mr.id = cc.idMenu
							inner join restaurante r
								on r.id = mr.idRestaurante
							inner join platillos p
								on p.id = mr.idPlatillo
							inner join usuarios u
								on u.id = mr.idCliente
						where (mr.id = p_idMenu) and (u.id = p_idCliente);
			commit;
        end;
    end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_borrarUsuario` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_borrarUsuario`(in p_idAdmin int, in p_idUsuario int)
    COMMENT 'Borra el usuario del sistema.'
BEGIN
	if (not exists (select 1 from usuarios_administradores 
            where idUsuario = p_idAdmin
		)) then
		signal	sqlstate '45000'
			set	message_text = 'El usuario registrado no existe o no tiene autorización para esta operación.',
				mysql_errno = 1644;
	else
		begin
        	declare exit handler for sqlexception
				begin
					rollback;
					resignal;
				end;
                
			set @nombreCompletoAdmin = (select concat(nombre, " ", apellidos)
				from usuarios
				where id = p_idAdmin);
			set @nombreCompletoUsuario = (select concat(nombre, " ", apellidos)
				from usuarios
				where id = p_idUsuario);
        
			start transaction;
				delete
					from usuarios
					where id = idUsuario;
				insert into bitacora_cambios(fechaHora, idUsuario, detalles)
					select now(), p_idAdmin, concat("El administrador ", @nombreCompletoAdmin, 
							"ha eliminado el usuario ", @nombreCompletoUsuario, " del sistema.")
			commit;
        end;
    end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_borrarUsuarioAdministrador` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_borrarUsuarioAdministrador`(in p_idAdmin int, in p_idAdminBorrado int)
    COMMENT 'Borra un usuario administrador del sistema.'
BEGIN
	if (not exists (select 1 from usuarios_administradores 
            where idUsuario = p_idAdmin
		)) then
		signal	sqlstate '45000'
			set	message_text = 'El usuario registrado no existe o no tiene autorización para esta operación.',
				mysql_errno = 1644;
	elseif (not exists (select 1 from usuarios_administradores 
			where idUsuario = p_idAdminBorrado
		)) then
        signal	sqlstate '45000'
			set message_text = 'El usuario ingresado no se encuentra registrado como administrador.',
				mysql_errno = 1644;
	elseif ((select count(*) from usuarios_administradores) = 1) then
		signal	sqlstate '45000'
			set	message_text = 'Debe existir al menos un usuario administrador.',
				mysql_errno = 1644;
	else
		begin
			call sp_borrarUsuario(p_idAdmin, p_idAdminBorrado);
        end;
    end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_borrarUsuarioCliente` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_borrarUsuarioCliente`(in p_idAdmin int, in p_idClienteBorrado int)
    COMMENT 'Borra un usuario cliente del sistema.'
BEGIN
	if (not exists (select 1 from usuarios_administradores 
            where idUsuario = p_idAdmin
		)) then
		signal	sqlstate '45000'
			set	message_text = 'El usuario registrado no existe o no tiene autorización para esta operación.',
				mysql_errno = 1644;
	elseif (not exists (select 1 from usuarios_clientes 
			where idUsuario = p_idClienteBorrado
		)) then
        signal	sqlstate '45000'
			set message_text = 'El usuario ingresado no se encuentra registrado como cliente.',
				mysql_errno = 1644;
	else
		begin
			call sp_borrarUsuario(p_idAdmin, p_idClienteBorrado);
        end;
    end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_cambiarIngrediente` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_cambiarIngrediente`(in p_idAdmin int, in p_idIngrediente int, in p_nuevo_nombre nvarchar(50), 
    in p_nuevo_precioUnidad decimal(8,2), in p_nuevo_urlFoto nvarchar(200), 
    in p_nuevo_idCategoria int)
    COMMENT 'Modifica la información de un ingrediente en el sistema. Los parámetros son\n    opcionales; aquellos dejados en NULL no se modifican.'
BEGIN
	if (not exists (select 1
			from usuarios_administradores 
            where idUsuario = p_idAdmin
		)) then
		signal	sqlstate '45000'
			set	message_text = 'El usuario registrado no existe o no tiene autorización para esta operación.',
				mysql_errno = 1644;
	else
		begin
			declare idObtenido int;
			
			declare exit handler for sqlexception
				begin
					rollback;
					resignal;
				end;
			start transaction;
				update ingredientes i
						inner join categorias_ingredientes c
							on i.id = c.idIngrediente
					set i.nombre = ifnull(p_nuevo_nombre, i.nombre),
						i.precioUnidad = ifnull(p_nuevo_precioUnidad, i.precioUnidad),
                        i.urlFoto = ifnull(p_nuevo_urlFoto, i.urlFoto),
                        c.idCategoria = ifnull(p_nuevo_idCategoria, c.idCategoria)
					where i.id = p_idIngrediente;
                
                insert into bitacora_cambios(fechaHora, idUsuario, detalles)
					select now(), p_idAdmin, concat("El administrador ", u.nombre, " ", u.apellidos,
							" modificó la información del ingrediente con identificador ", i.id, 
                            " en el sistema.")
						from usuarios u, ingredientes i
                        where (u.id = p_idAdmin) and (i.id = p_idIngrediente);
			commit;
			
			select id, nombre, precioUnidad
				from ingredientes
				where id = idObtenido;
		end;
    end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_cambiarInventarioRestaurante` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_cambiarInventarioRestaurante`(in p_idAdmin int, in p_idRestaurante int, in p_idIngrediente int, in p_nuevaCantidad decimal(13,3))
    COMMENT 'Modifica el inventario de un ingrediente para un restaurante.'
BEGIN
	if (not exists (select 1
			from usuarios_administradores 
            where idUsuario = p_idAdmin
		)) then
		signal	sqlstate '45000'
			set	message_text = 'El usuario registrado no existe o no tiene autorización para esta operación.',
				mysql_errno = 1644;
	else
		begin
			declare exit handler for sqlexception
				begin
					rollback;
					resignal;
				end;
			
			start transaction;
				update inventario_restaurantes
					set cantidadDisponible = p_nuevaCantidad
					where (idRestaurante = p_idRestaurante) and (idIngrediente = p_idIngrediente);
                    
				insert into bitacora_cambios(fechaHora, idUsuario, detalles)
					select now(), p_idAdmin, concat("El administrador ", p.nombre, " ", p.apellidos,
						" modificó el inventario del ingrediente ", i.nombre, " del restaurante ",
                        r.nombre, "a la cantidad ", p_nuevaCantidad)
						from usuarios u, restaurantes r, ingredientes i
							where (u.id = p_idAdmin) and (r.id = p_idRestaurante)
								and (i.id = p_idIngrediente);
			commit;
			
			select idRestaurante, idIngrediente, cantidadDisponible
				from inventario_restaurante
				where (idRestaurante = p_idRestaurante) and (idIngrediente = p_idIngrediente);
		end;
	end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_cambiarUsuarioCliente` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_cambiarUsuarioCliente`(in p_idUsuarioModificador int, in p_idCliente int, in p_nuevo_nombre nvarchar(50), 
		in p_nuevo_apellidos nvarchar(100), in p_nuevo_password nvarchar(20), 
		in p_nuevo_numeroTelefono decimal(8,0)
    )
    COMMENT 'Modifica la información de un usuario seleccionado. Los parámetros que no se desea modificar\n se pasan como NULL. El e-mail del usuario no se modifica, ya que lo identifica para iniciar sesión.'
BEGIN
	if (not exists (select 1
			from usuarios
            where id = p_idUsuarioModificador
		)) then
		signal	sqlstate '45000'
			set	message_text = 'El usuario registrado no existe o no tiene autorización para esta operación.',
				mysql_errno = 1644;
	
    /* Los clientes no pueden cambiar la información de otros clientes */
	elseif ((exists (select 1 from usuarios_clientes where idUsuario = p_idUsuarioModificador) and
		(p_idUsuarioModificador != p_idCliente)
        )) then
        signal	sqlstate '45000'
			set	message_text = 'El usuario ingresado no puede cambiar la información de otros usuarios.',
				mysql_errno = 1644;

	else
		begin			
			declare exit handler for sqlexception
				begin
					rollback;
					resignal;
				end;
			
            start transaction;
				update usuarios u
						inner join usuarios_clientes c
							on u.id = c.idUsuario
					set u.nombre = coalesce(p_nuevo_nombre, nombre), 
						u.apellidos = coalesce(p_nuevo_apellidos, apellidos),
                        u.pwd = coalesce(p_nuevo_password, pwd),
                        c.numeroTelefono = coalesce(p_nuevo_numeroTelefono, numeroTelefono)
					where u.id = p_idCliente;
					
				set @nombreCompletoModificador = (select concat(nombre, " ", apellido)
					from usuarios
                    where id = p_idUsuarioModificador);
				
                insert into bitacora_cambios(fechaHora, idUsuario, detalles)
					select now(), p_idUsuarioModificador, concat("El usuario ",
							@nombreCompletoModificador, 
							" ha modificado la información del usuario asociado al e-mail ",
							eMail, ".")
						from usuarios
                        where id = p_idCliente;
            commit;
		end;
	end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getBitacoraCambios` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_getBitacoraCambios`(in p_fechaInicio datetime(0) /* Opcional: Pasar NULL para omitir*/ , 
	in p_fechaFin datetime(0) /* Opcional: Pasar NULL para omitir*/ )
    COMMENT 'Muestra el contenido de la bitácora de cambios en un intervalo de tiempo opcional.'
BEGIN
	if ((p_fechaInicio is not null) and (p_fechaFin is not null) and
		(p_fechaInicio > p_fechaFin)) then
        signal	sqlstate '45000'
			set	message_text = 'La fecha de inicio ingresada no debe ser después de la fecha final.',
				mysql_errno = 1644;
	else
		select b.id, date_format(b.fechaHora, '%d/%m/%Y %r') as 'fechaRegistro', b.idUsuario, 
				u.nombre as 'nombreUsuario', b.idRestaurante, b.nombre as 'nombreRestaurante', 
				b.detalles
			from	bitacora_cambios b
				inner join	usuarios u
					on	u.id = b.idUsuario
				inner join	restaurantes r
					on	r.id = b.idRestaurante
			where	((p_fechaInicio is null) or  (b.fechaHora >= p_fechaInicio))
				and	((p_fechaFin is null) or  (b.fechaHora <= p_fechaFin));
    end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getCarritoComprasClienteRestaurante` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_getCarritoComprasClienteRestaurante`(in p_idRestaurante int, in p_idCliente int)
    COMMENT 'Muestra el contenido del carrito del cliente (orden temporal).'
BEGIN
	if (not exists (select 1
			from restaurantes
            where id = p_idRestaurante
		)) then
		signal	sqlstate '45000'
			set	message_text = 'El restaurante ingresado no se encuentra registrado.',
				mysql_errno = 1644;
	elseif (not exists (select 1
			from usuarios_clientes
            where idUsuario = p_idCliente
		)) then
        signal	sqlstate '45000'
			set	message_text = 'El cliente ingresado no se encuentra registrado.',
				mysql_errno = 1644;
	else
		select	idMenu, cantidad, nombrePlatillo, precioTarjetaDetalle, precioEfectivoDetalle
			from vt_carritos_compras_clientes
			where (idCliente = p_idCliente) and (idRestaurante = p_idRestaurante);
    end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getCategoriasAdmitidasRestaurante` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_getCategoriasAdmitidasRestaurante`(in p_idRestaurante int)
    COMMENT 'Obtiene la lista de categorías de ingredientes asociadas al restaurante.'
BEGIN
	if (not exists (select 1
		from restaurantes
        where id = p_idRestaurante
        )) then
			signal	sqlstate '45000'
				set	message_text = 'El restaurante ingresado no se encuentra registrado.',
					mysql_errno = 1644;
	else
		select	c.id as 'idCategoria', c.nombre as 'nombreCategoria'
			from categorias_ingredientes_restaurantes cr
				inner join categorias c
					on c.id = cir.idCategoria
			where cr.idRestaurante = p_idRestaurante;
    end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getCategoriasIngredientesDeRestaurante` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_getCategoriasIngredientesDeRestaurante`(in p_idRestaurante int)
    COMMENT 'Obtiene una lista con las categorías de alimentos registradas para un restaurante.'
BEGIN
	if (not exists (select 1 
		from restaurantes 
        where id = p_idRestaurante)) then
			signal	sqlstate '45000'
				set	message_text = 'El restaurante ingresado no se encuentra registrado.',
					mysql_errno = 1644;
	else
		select c.id, c.nombre
			from categorias_ingredientes_restaurantes i
				join restaurantes r
					on r.id = i.idRestaurante
				join categorias c
					on c.id = i.idCategoria
			where i.idRestaurante = p_idRestaurante;
    end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getDetallesOrdenCompra` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_getDetallesOrdenCompra`(in p_idOrdenCompra int)
    COMMENT 'Obtiene los detalles de platillos de una orden de compra realizada.'
BEGIN
	if (not exists (select 1 from ordenes_compra where id = p_idOrdenCompra)) then
		signal	sqlstate '45000'
			set	message_text = 'La orden ingresada no se encuentra registrada.',
				mysql_errno = 1644;
	else
		select poc.idPlatillo, p.nombre as 'nombrePlatillo', poc.cantidad, 
					poc.precioUnidad, poc.descuento, poc.totalDetalle
			from platillos_ordenes_compra poc
				inner join platillos p
					on p.id = poc.idPlatillo
			where poc.idOrden = p_idOrdenCompra;
    end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getGananciasRestauranteEnDia` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_getGananciasRestauranteEnDia`(in p_idFecha datetime(0))
BEGIN
	if (p_idFecha > (select current_date)) then
		signal	sqlstate '45000'
			set	message_text = 'La fecha ingresada no debe ser mayor a la actual.',
				mysql_errno = 1644;
	else
		select idRestaurante, NombreRestaurante, fechaConsultada, cantidadOrdenes,
				totalOrdenes, gananciasOrdenes
			from vt_reportes_diarios_ganancias
            where fechaConsultada = date_format(p_idFecha, '%d/%m/%Y');
	end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getInfoIngrediente` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_getInfoIngrediente`(in p_idIngrediente int)
    COMMENT 'Obtiene la información detallada de un ingrediente.'
BEGIN
	if (not exists (select 1 from ingredientes where id = p_idIngrediente)) then
		signal	sqlstate '45000'
			set	message_text = 'El ingrediente ingresado no se encuentra registrado.',
				mysql_errno = 1644;
	else
		select i.id as 'idIngrediente', c.id as 'idCategoria', i.nombre as 'nombreIngrediente',
			c.nombre as 'nombreCategoria', i.precioUnidad as 'precioPorUnidad',
			i.urlFoto as 'URLfoto'
			from ingredientes i
				inner join categorias_ingredientes ci
					on i.id = c.idIngrediente
				inner join categorias c
					on c.id = c.idCategoria
			where i.id = p_idIngrediente;
    end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getInfoOrdenCompra` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_getInfoOrdenCompra`(in p_idOrdenCompra int)
    COMMENT 'Obtiene la información básica de una orden de compra realizada.'
BEGIN
	if (not exists (select 1 from ordenes_compra where id = p_idOrdenCompra)) then
		signal	sqlstate '45000'
			set	message_text = 'La orden ingresada no se encuentra registrada.',
				mysql_errno = 1644;
	else
		select idCliente, idRestaurante, NombreCliente, NombreRestaurante, fechaFactura,
					subTotal, descuento, total
			from vt_costos_ordenes_compra
            where idOrden = p_idOrdenCompra;
    end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getInfoRestaurante` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_getInfoRestaurante`(in p_idRestaurante int)
    COMMENT 'Obtiene la información detallada de un restaurante.'
BEGIN
	if (not exists (select 1 from restauranres where id = p_idRestaurante)) then
		signal	sqlstate '45000'
			set	message_text = 'El restaurante ingresado no se encuentra registrado.',
				mysql_errno = 1644;
	else
		select id, idCategoria, nombre, direccion
			from restaurantes
            where (id = p_idRestaurante);
    end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getInfoUsuarioAdministrador` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_getInfoUsuarioAdministrador`(in p_idAdministrador int)
    COMMENT 'Obtiene la información de un administrador.'
BEGIN
	if (not exists (select 1 from usuarios 
			where id = p_idAdministrador
		)) then
		signal	sqlstate '45000'
			set	message_text = 'El usuario ingresado no se encuentra registrado.',
				mysql_errno = 1644;
	elseif (not exists (select 1 from usuarios_administradores 
				where idUsuario = p_idAdministrador
			)) then
		signal	sqlstate '45000'
			set	message_text = 'El usuario ingresado no es un cliente.',
				mysql_errno = 1644;
	else
		select u.id, r.id as 'idRestaurante', u.eMail as 'e-Mail', u.nombre, u.apellidos, r.nombre as 'RestauranteEmpleador'
			from usuarios u
				inner join usuarios_administradores a
					on u.id = a.idUsuario
				inner join restaurantes r
					on r.id = a.idRestaurante
			where u.id = p_idAdministrador;
    end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getInfoUsuarioCliente` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_getInfoUsuarioCliente`(in p_idCliente int)
    COMMENT 'Obtiene la información de un cliente.'
BEGIN
	if (not exists (select 1 from usuarios 
			where id = p_idCliente
		)) then
		signal	sqlstate '45000'
			set	message_text = 'El usuario ingresado no se encuentra registrado.',
				mysql_errno = 1644;
	elseif (not exists (select 1 from usuarios_clientes 
			where idUsuario = p_idCliente
		)) then
		signal	sqlstate '45000'
			set	message_text = 'El usuario ingresado no es un cliente.',
				mysql_errno = 1644;
	else
		select u.id, u.eMail as 'e-Mail', u.nombre, u.apellidos, c.numeroTelefono
			from usuarios u
				inner join usuarios_clientes c
					on u.id = c.idUsuario
			where u.id = p_idCliente;
	end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getIngredientesPlatillo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_getIngredientesPlatillo`(in p_idPlatillo int)
    COMMENT 'Obtiene una lista de todos los ingredientes utilizados en un platillo.'
BEGIN
	if (not exists (select 1
		from platillos
        where id = p_idPlatillo)
        ) then
			signal	sqlstate '45000'
				set	message_text = 'El platillo ingresado no se encuentra registrado.',
					mysql_errno = 1644;
	else
		select v.idIngrediente, v.NombreIngrediente, v.Cantidad, 
			i.precioUnidad, v.precioIngrediente
			from vt_costos_ingredientes_platillos v
				inner join ingredientes i
					on i.id = v.idIngrediente
			where v.idPlatillo = p_idPlatillo;
    end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getInventarioRestaurante` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_getInventarioRestaurante`(in p_idRestaurante int)
    COMMENT 'Obtiene una lista con el inventario de un restaurante.'
BEGIN
	if (not exists (select 1 
		from restaurantes 
        where id = p_idRestaurante)) then
			signal	sqlstate '45000'
				set	message_text = 'El restaurante ingresado no se encuentra registrado.',
					mysql_errno = 1644;
	else
		select ir.idIngrediente, i.nombre as 'NombreIngrediente',
			ir.cantidadDisponible
			from inventario_restaurantes ir
				join restaurantes r
					on r.id = ir.idRestaurante
				join ingredientes i
					on i.id = ir.idIngrediente
				where ir.idRestaurante = p_idRestaurante
			order by ir.cantidadDisponible desc, i.nombre asc;
    end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getListaCategoriasAlimentos` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_getListaCategoriasAlimentos`()
    COMMENT 'Obtiene una lista de las categorías de alimentos registradas.'
BEGIN
	select id, nombre
		from categorias;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getListaEmisoresTarjetas` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_getListaEmisoresTarjetas`()
    COMMENT 'Obtiene una lista con los emisores de tarjetas de crédito.'
BEGIN
	select id, nombre
		from emisores_tarjetas
        order by nombre asc;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getListaIngredientesAdmitidosDeRestaurante` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_getListaIngredientesAdmitidosDeRestaurante`(in p_idRestaurante int)
    COMMENT 'Obtiene una lista de los ingredientes que son admitidos para un restaurante.\n	Los ingredientes son admitidos si sus categorías están asociadas con el restaurante.'
BEGIN
	if (not exists (select 1
		from restaurantes
        where id = p_idRestaurante
        )) then
			signal	sqlstate '45000'
				set	message_text = 'El restaurante ingresado no se encuentra registrado.',
					mysql_errno = 1644;
	else
		/*	Considerar que puede retornar un conjunto vacío si el restaurante no tiene categorías
        asociadas, sin importar si existen ingredientes o categorías en el sistema.
        */ 
		select	i.id as 'idIngrediente', 
				c.id as 'idCategoria',
				i.nombre as 'NombreIngrediente',
                c.nombre as 'NombreCategoria'
            from restaurantes r
				join categorias_ingredientes_restaurantes cir
					on r.id = cir.idRestaurante
				join categorias_ingredientes ci
					on ci.idCategoria = cir.idCategoria
				join ingredientes i
					on i.id = ci.idIngrediente
				join categorias c
					on c.id = ci.idCategoria
			where r.id = p_idRestaurante
            order by c.nombre asc, i.nombre asc;
	end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getListaIngredientesEnCategoria` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_getListaIngredientesEnCategoria`(in p_idCategoria int)
    COMMENT 'Obtiene una lista de los ingredientes clasificados en una categoría.'
BEGIN
	if (not exists(select 1
		from categorias
        where id = p_idCategoria
        )) then
		signal	sqlstate '45000'
			set	message_text = 'La categoría ingresada no se encuentra registrada',
				mysql_errno = 1644;
	elseif (not exists (select 1
		from categorias_ingredientes
        where idCategoria = p_idCategoria
        )) then
        signal	sqlstate '45000'
			set	message_text = 'No hay ingredientes registrados en esta categoría.',
				mysql_errno = 1644;
	else
		/* Puede retornar un conjunto vacío si no hay ingredientes en la categoría */
		select	i.id, i.nombre
			from ingredientes i
				join categorias_ingredientes ci
					on i.id = c.idIngrediente
			where (ci.idCategoria = p_idCategoria)
			order by i.nombre;
    end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getListaRestaurantes` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_getListaRestaurantes`()
    COMMENT 'Obtiene una lista de los restaurantes registrados.'
BEGIN
	select id, nombre
		from restaurantes
        order by nombre asc;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getListaUsuariosAdministradores` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_getListaUsuariosAdministradores`()
    COMMENT 'Obtiene una lista sencilla de los clientes registrados.'
BEGIN
	select u.id, u.nombre
		from usuarios_administradores a
			inner join usuarios u
				on u.id = a.idUsuario
		order by u.nombre asc;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getListaUsuariosClientes` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_getListaUsuariosClientes`()
    COMMENT 'Obtiene una lista sencilla de los clientes registrados.'
BEGIN
	select u.id, u.nombre
		from usuarios_clientes c
			inner join usuarios u
				on u.id = c.idUsuario
		order by u.nombre asc;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getMenuRestaurante` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_getMenuRestaurante`(in p_idRestaurante int)
    COMMENT 'Obtiene el menú de un restaurante.'
BEGIN
	if (not exists(select 1
		from restaurantes
        where id = p_idRestaurante
        )) then
			signal	sqlstate '45000'
				set	message_text = 'El restaurante ingresado no se encuentra registrado.',
					mysql_errno = 1644;
	else
		select	m.id as 'idMenu',	cp.idPlatillo, 
				cp.nombrePlatillo,	cp.precioBase
			from restaurantes r
				inner join menu_restaurantes m
					on r.id = m.idRestaurante
				inner join vt_costos_platillos cp
					on m.idPlatillo = cp.idPlatillo
			where	r.id = p_idRestaurante;
    end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getOrdenesCompraCliente` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_getOrdenesCompraCliente`(in p_idCliente int)
    COMMENT 'Obtiene una lista con las órdenes de compra hechas por un cliente.'
BEGIN
	if (not	exists (select 1
		from clientes
        where id = p_idCliente
        )) then
        signal	sqlstate '45000'
			set	message_text = 'El cliente ingresado no se encuentra registrado.',
				mysql_errno = 1644;
	else
		select idOrden, idRestaurante, NombreRestaurante, FechaFactura, SubTotal, Descuento, Total 
			from vt_costos_ordenes_compra
            where idCliente = p_idCliente;
    end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getOrdenesCompraRestaurante` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_getOrdenesCompraRestaurante`(in p_idRestaurante int)
    COMMENT 'Obtiene una lista con todas las órdenes de compra realizadas por un restaurante.'
BEGIN
	if (not	exists (select 1
		from restaurantes
        where id = p_idRestaurante
        )) then
        signal	sqlstate '45000'
			set	message_text = 'El restaurante ingresado no se encuentra registrado.',
				mysql_errno = 1644;
	else
		select idOrden, idCliente, NombreCliente, FechaFactura, SubTotal, Descuento, Total 
			from vt_costos_ordenes_compra
            where idRestaurante = p_idRestaurante;
    end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getRestaurantesDeCategoria` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_getRestaurantesDeCategoria`(in p_idCategoria int)
    COMMENT 'Obtiene una lista de los restaurantes clasificados con una categoría de alimentos.'
BEGIN
	if (not exists (select 1
		from categorias
        where id = p_idCategoria
        )) then
        signal	sqlstate '45000'
			set	message_text = 'La categoría ingresada no se encuentra registrada.',
				mysql_errno = 1644;
	else
		/* Tomar en cuenta que puede retornar un conjunto vacío */
		select	idRestaurante, NombreRestaurante
			from	vt_info_restaurantes
			where idCategoria = p_idCategoria;
	end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getTotalesCarritoComprasClienteRestaurante` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_getTotalesCarritoComprasClienteRestaurante`(in p_idRestaurante int, in p_idCliente int)
    COMMENT 'Obtiene el total de la compra en el carrito de compras del cliente en el restaurante.'
BEGIN
	if (not exists (select 1
		from restaurantes
        where id = p_idRestaurante
        )) then
        signal	sqlstate '45000'
			set	message_text = 'El restaurante ingresado no se encuentra registrado.',
				mysql_errno = 1644;
	elseif (not exists (select 1
		from usuarios_clientes
        where idUsuario = p_idCliente
        )) then
        signal	sqlstate '45000'
			set message_text = 'El cliente ingresado no se encuentra registrado.',
				mysql_errno = 1644;
	else
		begin
			select idCliente as 'idCliente', idRestaurante as 'idRestaurante',
				sum(precioTarjetaDetalle) as 'totalFacturaTarjeta',
                sum(precioEfectivoDetalle) as 'totalFacturaEfectivo'
				from	vt_carritos_compras_clientes
                where	(idRestaurante = p_idRestaurante) and (idCliente = p_idCliente)
                group by idRestaurante, idCliente;
        end;
	end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getVentasConIngrediente` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_getVentasConIngrediente`(in p_idIngrediente int,
	 in p_idRestaurante int /* Opcionar: Pasar NULL para ignorar*/ ,
     in p_fechaInicio datetime(0) /* Opcionar: Pasar NULL para ignorar*/ ,
     in p_fechaFin datetime(0) /* Opcionar: Pasar NULL para ignorar*/
     )
    COMMENT 'Muestra las ventas realizadas usando un ingrediente en platillos.'
BEGIN
	if (not exists(select 1 from ingredientes 
			where id = p_idIngrediente
		)) then
        signal	sqlstate '45000'
			set	message_text = 'El ingrediente ingresado no se encuentra registrado.',
				mysql_errno = 1644;
	elseif ((p_idRestaurante is not null) and (not exists (select 1
			from restaurantes
            where id = p_idRestaurante)
            )) then
		signal	sqlstate '45000'
			set	message_text = 'El restaurante ingresado no se encuentra registrado.',
				mysql_errno = 1644;
	elseif ((p_fechaInicio is not null) 
			and (p_fechaFin is not null) 
			and (p_fechaInicio > p_fechaFin)
            ) then
		signal	sqlstate '45000'
			set	message_text = 'La fecha de inicio ingresada no puede ser después de la fecha de fin.',
				mysql_errno = 1644;
	else
		select vt.idOrden, vt.idRestaurante, vt.NombreRestaurante, 
					vt.fechaFactura, vt.total
			from vt_costos_ordenes_compras vt
				inner join platillos_ordenes_compra op
					on o.id = op.idOrden
				inner join platillos p
					on p.id = op.idOrden
				inner join ingredientes_platillos ip
					on p.id = ip.idPlatillo
				inner join ingredientes i
					on i.id = ip.idIngrediente
			where (i.id = p_idIngrediente)
				and ((p_idRestaurante is null) or (vt.idRestaurante = p_idRestaurante))
                and ((p_fechaInicio is null) or (p_fechaInicio <= vt.fechaFactura))
                and ((p_fechaFin is null) or (p_fechaFin >= vt.fechaFactura));
    end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getVentasGananciasDia` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_getVentasGananciasDia`(in p_fecha datetime(0))
    COMMENT 'Obtiene el reporte de ventas y ganancias de un día.'
BEGIN
	select	fechaConsultada, idRestaurante, NombreRestaurantes, cantidadOrdenes,
			totalOrdenes, gananciasOrdenes
		from vt_reportes_diarios_ganancias
		where	year(fechaConsultada) = year(p_fecha)
			and month(fechaConsultada) = month(p_fecha)
            and day(fechaConsultada) = day(p_fecha);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getVentasRestauranteConIngrediente` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_getVentasRestauranteConIngrediente`(in p_idIngrediente int,
	 in p_idRestaurante int /* Opcionar: Pasar NULL para ignorar*/ ,
     in p_fechaInicio datetime(0) /* Opcionar: Pasar NULL para ignorar*/ ,
     in p_fechaFin datetime(0) /* Opcionar: Pasar NULL para ignorar*/
     )
    COMMENT 'Muestra las ventas realizadas usando un ingrediente en platillos vendidos por los restaurantes.\n     Los parámetros opcionales permiten limitar los resultados a un rango de fechas o restaurante.'
BEGIN
	if (not exists(select 1 from ingredientes 
			where id = p_idIngrediente
		)) then
        signal	sqlstate '45000'
			set	message_text = 'El ingrediente ingresado no se encuentra registrado.',
				mysql_errno = 1644;
	elseif ((p_idRestaurante is not null) and (not exists (select 1
			from restaurantes
            where id = p_idRestaurante)
            )) then
		signal	sqlstate '45000'
			set	message_text = 'El restaurante ingresado no se encuentra registrado.',
				mysql_errno = 1644;
	elseif ((p_fechaInicio is not null) 
			and (p_fechaFin is not null) 
			and (p_fechaInicio > p_fechaFin)
            ) then
		signal	sqlstate '45000'
			set	message_text = 'La fecha de inicio ingresada no puede ser después de la fecha de fin.',
				mysql_errno = 1644;
	else
		select vt.idOrden, vt.idRestaurante, vt.NombreRestaurante, 
					vt.fechaFactura, vt.total
			from vt_costos_ordenes_compras vt
				inner join platillos_ordenes_compra op
					on o.id = op.idOrden
				inner join platillos p
					on p.id = op.idOrden
				inner join ingredientes_platillos ip
					on p.id = ip.idPlatillo
				inner join ingredientes i
					on i.id = ip.idIngrediente
			where (i.id = p_idIngrediente)
				and ((p_idRestaurante is null) or (vt.idRestaurante = p_idRestaurante))
                and ((p_fechaInicio is null) or (p_fechaInicio <= vt.fechaFactura))
                and ((p_fechaFin is null) or (p_fechaFin >= vt.fechaFactura));
    end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getVentasTotalesRestaurantes` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_getVentasTotalesRestaurantes`(in p_fechaInicio datetime(0) /* Opcionar: Dejar NULL para omitir */ ,
     in p_fechaFin datetime(0) /* Opcional: Dejar NULL para omitir */
     )
    COMMENT 'Consulta las ventas totales de los restaurantes en un intervalo específico.'
BEGIN
	if ((p_fechaInicio is not null) 
			and (p_fechaFin is not null) 
			and (p_fechaInicio > p_fechaFin)
            ) then
		signal	sqlstate '45000'
			set	message_text = 'La fecha de inicio ingresada no puede ser después de la fecha de fin.',
				mysql_errno = 1644;
	else
		select	idRestaurante, NombreRestaurante, 
				ifnull(count(idOrden),0) as 'cantidadOrdenes', 
				ifnull(sum(total), 0) as 'totalVentas'
			from vt_costos_ordenes_compra vt
			where	((p_fechaInicio is null) or (p_fechaInicio <= vt.fechaFactura))
				and ((p_fechaFin is null) or (p_fechaFin >= vt.fechaFactura))
			group by vt.idRestaurante;
    end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_loginUsuario` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_loginUsuario`(in p_eMail nvarchar(50), in p_password nvarchar(20))
    COMMENT 'Procedimiento que permite al usuario iniciar sesión.'
BEGIN
	if (not exists (select 1 from usuarios where (eMail = p_eMail))) then
		signal	sqlstate '45000'
			set	message_text = 'El correo electrónico ingresado no se encuentra registrado.',
				mysql_errno = 1644;
            
	elseif (not exists (select 1 from usuarios 
			where ((eMail = p_eMail) and (pwd = p_password))
            )) then
		signal	 sqlstate '45000'
			set	message_text = 'La contraseña ingresada no es válida.',
				mysql_errno = 1644;
	else
		begin
			declare idObtenido int;
            set idObtenido = (select id from usuarios where (eMail = p_eMail));
            
            /* Si el idRestaurante retornado es 0, el admin debe ser asignado a un restaurante
				Use sp_asignarAdminARestaurante
            */
            if (exists (select 1 from usuarios_administradores 
					where idUsuario = idObtenido)) then
				select 'admin' as estado, idUsuario as 'idAdministrador', ifnull(idRestaurante, 0) as 'idRestaurante', 
						'Ha iniciado sesión como administador.' as msg
					from usuarios_administradores
                    where idUsuario = idObtenido;

			elseif (exists (select 1 from usuarios_clientes
					where idUsuario = idObtenido)) then
				select 'cliente' as estado, idUsuario as 'idCliente', 'Ha iniciado sesión como cliente.' as msg
					from usuarios_clientes
                    where idUsuario = idObtenido;
			else
				signal	sqlstate '45000'
					set	message_text = 'El usuario ingresado no está asignado a una categoría de usuario.',
						mysql_errno = 1644;
			end if;
        end;
	end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_pagarOrdenConEfectivo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_pagarOrdenConEfectivo`(in p_idRestaurante int, in p_idCliente int, in p_montoRecibido decimal(20,2))
    COMMENT 'Realiza el pago de la orden de compra del cliente en un restaurante.'
BEGIN
    if (not exists(select 1 from carritos_compras 
			where (idCliente = p_idCliente) and (idRestaurante = p_idRestaurante)
		)) then
        signal	sqlstate '45000'
			set	message_text = 'No se han ingresado platillos a la orden de compra.',
				mysql_errno = 1644;
	/*	No se permitirá agregar la orden si contiene cantidades de comidas que no pueden ser
		producidas en el restaurante por falta de ingredientes. 
	*/
    elseif (exists (select 1
			from vt_carritos_compras_clientes c
				inner join ingredientes_platillos ip
					on c.idPlatillo = ip.idPlatillo
				inner join inventario_restaurantes inv
					on (c.idRestaurante = inv.idRestaurante) and (c.idPlatillo = inv.idPlatillo)
			where (c.idRestaurante = p_idRestaurante) and (c.idCliente = p_idCliente)
				and ((c.cantidad * ip.cantidadIngrediente) < inv.cantidadDisponible)
		)) then
        signal	sqlstate '45000'
			set	message_text = 'La orden de compra no puede concretarse por falta de ingredientes.',
				mysql_errno = 1644;
	
    -- Se ingresa menos efectivo de lo necesario.
	elseif (p_montoRecibido < (select sum(precioEfectivoDetalle)
			from vt_carritos_compras_clientes
			where (idRestaurante = p_idRestaurante) and (idCliente = p_idCliente)
			group by idCliente
		)) then
		signal	sqlstate '45000'
			set	message_text = 'Se ha ingresado un monto de efectivo menor al necesario.',
				mysql_errno = 1644;
	else
		begin
			declare idNuevaOrden int;
            
            declare exit handler for sqlexception
				begin
					rollback;
                    resignal;
                end;
                
			start transaction;
				/* Actualizar inventario primero */
                update inventario_restaurantes inv
						inner join vt_carritos_compras_clientes vc
							on inv.idRestaurante = vc.idRestaurante
						inner join ingredientes_platillos ip
							on vc.idPlatillo = ip.idPlatillo
					set	inv.cantidadDisponible = inv.cantidadDisponible -
						(vc.cantidad * ip.cantidadIngrediente)
					where (vc.idCliente = p_idCliente) and (vc.idRestaurante = p_idRestaurante);
                    
				/* Crear orden de compra*/
				insert into ordenes_compras(idCliente, idRestaurante, fechaFactura)
					values (p_idCliente, p_idRestaurante, now());
				set idNuevaOrden = (select last_insert_id());
                    
				/* Mover contenido de carrito de compras a orden de compras */
                insert into platillos_ordenes_compra(idOrden, idPlatillo, cantidad, precioUnidad, 
								descuento, totalDetalle)
					select idNuevaOrden, cantidad, precioUnidadEfectivo, 
								descuentoEfectivoDetalle, precioEfectivoDetalle
						from vt_carritos_compras_clientes
						where (idCliente = p_idCliente) and (idRestaurante = p_idRestaurante);
				
                delete from carritos_compras
					where (idRestaurante = p_idRestaurante) and (idCliente = p_idCliente);

				/* Registrar pago efectivo */
				insert into compras_efectivo_clientes(idOrden, montoRecibido, cambio)
					select idNuevaOrden, p_montoRecibido, (p_montoRecibido - total)
						from vt_costos_ordenes_compra
						where idOrden = idNuevaOrden;

            commit;
                select idOrden, NombreCliente, NombreRestaurante, fechaFactura, 
						subTotal, descuento, total
					from vt_costos_ordenes_compra
                    where idOrden = idNuevaOrden;
						
        end;
    end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_pagarOrdenConTarjeta` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_pagarOrdenConTarjeta`(in p_idRestaurante int, in p_idCliente int, in p_idEmisorTarjeta int, 
		in p_numeroAuth decimal(16,0))
    COMMENT 'Paga la orden de compra del cliente en un restaurante con tarjeta de crédito.'
BEGIN
    if (not exists(select 1 from carritos_compras 
			where (idCliente = p_idCliente) and (idRestaurante = p_idRestaurante)
		)) then
        signal	sqlstate '45000'
			set	message_text = 'No se han ingresado platillos a la orden de compra.',
				mysql_errno = 1644;
	/*	No se permitirá agregar la orden si contiene cantidades de comidas que no pueden ser
		producidas en el restaurante por falta de ingredientes. 
	*/
    elseif (exists (select 1
			from vt_carritos_compras_clientes c
				inner join ingredientes_platillos ip
					on c.idPlatillo = ip.idPlatillo
				inner join inventario_restaurantes inv
					on (c.idRestaurante = inv.idRestaurante) and (c.idPlatillo = inv.idPlatillo)
			where (c.idRestaurante = p_idRestaurante) and (c.idCliente = p_idCliente)
				and ((c.cantidad * ip.cantidadIngrediente) < inv.cantidadDisponible)
		)) then
        signal	sqlstate '45000'
			set	message_text = 'La orden de compra no puede concretarse por falta de ingredientes.',
				mysql_errno = 1644;
	else
		begin
			declare idNuevaOrden int;
            
            declare exit handler for sqlexception
				begin
					rollback;
                    resignal;
                end;
                
			start transaction;
				/* Actualizar inventario primero */
                update inventario_restaurantes inv
						inner join vt_carritos_compras_clientes vc
							on inv.idRestaurante = vc.idRestaurante
						inner join ingredientes_platillos ip
							on vc.idPlatillo = ip.idPlatillo
					set	inv.cantidadDisponible = inv.cantidadDisponible -
						(vc.cantidad * ip.cantidadIngrediente)
					where (vc.idCliente = p_idCliente) and (vc.idRestaurante = p_idRestaurante);
                    
				/* Crear orden de compra*/
				insert into ordenes_compras(idCliente, idRestaurante, fechaFactura)
					values (p_idCliente, p_idRestaurante, now());
				set idNuevaOrden = (select last_insert_id());
                    
				/* Mover contenido de carrito de compras a orden de compras */
                insert into platillos_ordenes_compra(idOrden, idPlatillo, cantidad, precioUnidad, 
								descuento, totalDetalle)
					select idNuevaOrden, cantidad, precioUnidadTarjeta, 0, precioTarjetaDetalle
						from vt_carritos_compras_clientes
						where (idCliente = p_idCliente) and (idRestaurante = p_idRestaurante);
				
                delete from carritos_compras
					where (idRestaurante = p_idRestaurante) and (idCliente = p_idCliente);

				/* Registrar pago tarjeta crédito */
				insert into compras_tarjeta_clientes(idOrden, idEmisorTarjeta, numeroAutorizacion)
					values (idNuevaOrden, p_idEmisorTarjeta, p_numeroAuth);
            commit;
            
			select idOrden, NombreCliente, NombreRestaurante, fechaFactura, 
					subTotal, descuento, total
				from vt_costos_ordenes_compra
				where idOrden = idNuevaOrden;
        end;
    end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `vt_carritos_compras_clientes`
--

/*!50001 DROP VIEW IF EXISTS `vt_carritos_compras_clientes`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=CURRENT_USER SQL SECURITY DEFINER */
/*!50001 VIEW `vt_carritos_compras_clientes` AS select `cc`.`idCliente` AS `idCliente`,`mr`.`idRestaurante` AS `idRestaurante`,`mr`.`idPlatillo` AS `idPlatillo`,`mr`.`id` AS `idMenu`,`cc`.`cantidad` AS `cantidad`,`cp`.`nombrePlatillo` AS `nombrePlatillo`,`cp`.`precioTarjeta` AS `precioUnidadTarjeta`,`cp`.`precioEfectivo` AS `precioUnidadEfectivo`,(`cc`.`cantidad` * `cp`.`precioTarjeta`) AS `precioTarjetaDetalle`,(case when (`cd`.`IdCliente` is not null) then ((`cc`.`cantidad` * `cp`.`precioEfectivo`) * 0.65) else (`cc`.`cantidad` * `cp`.`precioEfectivo`) end) AS `precioEfectivoDetalle`,(case when (`cd`.`IdCliente` is not null) then ((`cc`.`cantidad` * `cp`.`precioEfectivo`) * 0.35) else 0 end) AS `descuentoEfectivoDetalle` from (((`carritos_compras` `cc` join `menu_restaurantes` `mr` on((`mr`.`id` = `cc`.`idMenu`))) join `vt_costos_platillos` `cp` on((`mr`.`idPlatillo` = `cp`.`idPlatillo`))) left join `vt_clientes_con_descuentos` `cd` on(((`cc`.`idCliente` = `cd`.`IdCliente`) and (`mr`.`idRestaurante` = `cd`.`IdRestaurante`)))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vt_clientes_con_descuentos`
--

/*!50001 DROP VIEW IF EXISTS `vt_clientes_con_descuentos`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=CURRENT_USER SQL SECURITY DEFINER */
/*!50001 VIEW `vt_clientes_con_descuentos` AS select `o`.`idCliente` AS `IdCliente`,`o`.`idRestaurante` AS `IdRestaurante`,sum(`p`.`totalDetalle`) AS `AcumuladoCompras` from (`ordenes_compra` `o` join `platillos_ordenes_compra` `p` on((`o`.`id` = `p`.`idOrden`))) where ((year(`o`.`fechaFactura`) = year((curdate() - interval 1 month))) and (month(`o`.`fechaFactura`) = month((curdate() - interval 1 month)))) group by `o`.`idRestaurante`,`o`.`idCliente` having (sum(`p`.`totalDetalle`) >= 20000) order by `o`.`idRestaurante`,`o`.`idCliente` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vt_costos_ingredientes_platillos`
--

/*!50001 DROP VIEW IF EXISTS `vt_costos_ingredientes_platillos`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=CURRENT_USER SQL SECURITY DEFINER */
/*!50001 VIEW `vt_costos_ingredientes_platillos` AS select `p`.`id` AS `idPlatillo`,`i`.`id` AS `idIngrediente`,`p`.`nombre` AS `NombrePlatillo`,`i`.`nombre` AS `NombreIngrediente`,`ip`.`cantidadIngrediente` AS `Cantidad`,cast((`ip`.`cantidadIngrediente` * `i`.`precioUnidad`) as decimal(20,2)) AS `precioIngrediente` from ((`ingredientes_platillos` `ip` join `ingredientes` `i` on((`i`.`id` = `ip`.`idIngrediente`))) join `platillos` `p` on((`p`.`id` = `ip`.`idPlatillo`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vt_costos_ordenes_compra`
--

/*!50001 DROP VIEW IF EXISTS `vt_costos_ordenes_compra`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=CURRENT_USER SQL SECURITY DEFINER */
/*!50001 VIEW `vt_costos_ordenes_compra` AS select `o`.`id` AS `idOrden`,`c`.`idUsuario` AS `idCliente`,`r`.`id` AS `idRestaurante`,`u`.`nombre` AS `NombreCliente`,`r`.`nombre` AS `NombreRestaurante`,date_format(`o`.`fechaFactura`,'%d/%m/%Y %r') AS `fechaFactura`,cast(sum((`p`.`cantidad` * `p`.`precioUnidad`)) as decimal(20,2)) AS `subTotal`,cast(sum(`p`.`descuento`) as decimal(20,2)) AS `descuento`,cast(sum(`p`.`totalDetalle`) as decimal(20,2)) AS `total`,cast((sum(`p`.`totalDetalle`) - sum((`p`.`cantidad` * `p`.`precioUnidad`))) as decimal(20,2)) AS `ganancias` from ((((`usuarios_clientes` `c` join `usuarios` `u` on((`u`.`id` = `c`.`idUsuario`))) join `ordenes_compra` `o` on((`c`.`idUsuario` = `o`.`idCliente`))) join `restaurantes` `r` on((`r`.`id` = `o`.`idRestaurante`))) join `platillos_ordenes_compra` `p` on((`o`.`id` = `p`.`idOrden`))) group by `o`.`id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vt_costos_platillos`
--

/*!50001 DROP VIEW IF EXISTS `vt_costos_platillos`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=CURRENT_USER SQL SECURITY DEFINER */
/*!50001 VIEW `vt_costos_platillos` AS select `p`.`id` AS `idPlatillo`,`p`.`nombre` AS `nombrePlatillo`,cast(sum(`vt`.`precioIngrediente`) as decimal(32,2)) AS `precioBase`,cast(sum((`vt`.`precioIngrediente` * 0.10)) as decimal(32,2)) AS `gananciaTarjeta`,cast(sum((`vt`.`precioIngrediente` * 0.15)) as decimal(32,2)) AS `gananciaEfectivo`,cast(sum((`vt`.`precioIngrediente` * 1.10)) as decimal(32,2)) AS `precioTarjeta`,cast(sum((`vt`.`precioIngrediente` * 1.15)) as decimal(32,2)) AS `precioEfectivo` from (`vt_costos_ingredientes_platillos` `vt` join `platillos` `p` on((`vt`.`idPlatillo` = `p`.`id`))) group by `vt`.`idPlatillo` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vt_info_restaurantes`
--

/*!50001 DROP VIEW IF EXISTS `vt_info_restaurantes`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=CURRENT_USER SQL SECURITY DEFINER */
/*!50001 VIEW `vt_info_restaurantes` AS select `r`.`id` AS `idRestaurante`,`c`.`id` AS `idCategoria`,`r`.`nombre` AS `NombreRestaurante` from (`restaurantes` `r` join `categorias` `c` on((`c`.`id` = `r`.`idCategoria`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vt_reportes_diarios_ganancias`
--

/*!50001 DROP VIEW IF EXISTS `vt_reportes_diarios_ganancias`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=CURRENT_USER SQL SECURITY DEFINER */
/*!50001 VIEW `vt_reportes_diarios_ganancias` AS select `vt_costos_ordenes_compra`.`idRestaurante` AS `idRestaurante`,`vt_costos_ordenes_compra`.`NombreRestaurante` AS `NombreRestaurante`,date_format(`vt_costos_ordenes_compra`.`fechaFactura`,'%d/%m/%Y') AS `fechaConsultada`,count(`vt_costos_ordenes_compra`.`idOrden`) AS `cantidadOrdenes`,sum(`vt_costos_ordenes_compra`.`total`) AS `totalOrdenes`,sum(`vt_costos_ordenes_compra`.`ganancias`) AS `gananciasOrdenes` from `vt_costos_ordenes_compra` group by `vt_costos_ordenes_compra`.`idRestaurante`,date_format(`vt_costos_ordenes_compra`.`fechaFactura`,'%d/%m/%Y') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-11-15  3:06:26
