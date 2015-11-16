-- phpMyAdmin SQL Dump
-- version 4.5.0.2
-- http://www.phpmyadmin.net
--
-- Servidor: 127.0.0.1
-- Tiempo de generaci√≥n: 16-11-2015 a las 01:23:18
-- Versi√≥n del servidor: 10.0.17-MariaDB
-- Versi√≥n de PHP: 5.6.14

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `sistemarestaurantes`
--

DELIMITER $$
--
-- Procedimientos
--

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_getRestauranteAvenidas` (IN `id` INT)  BEGIN
	SELECT a.nombre AS Avenida FROM
	restaurantes INNER JOIN cuadras_restaurantes
	ON restaurantes.id = cuadras_restaurantes.idRestaurante
	INNER JOIN cuadra
	ON cuadras_restaurantes.idCuadra = cuadra.id,
	avenida a
	WHERE ST_Crosses(cuadra.figura,a.figura)  AND restaurantes.id = id$$
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_getRestauranteCalles` (IN `id` INT)  BEGIN
	SELECT c.nombre AS Calle FROM
	restaurantes INNER JOIN cuadras_restaurantes
	ON restaurantes.id = cuadras_restaurantes.idRestaurante
	INNER JOIN cuadra
	ON cuadras_restaurantes.idCuadra = cuadra.id,
	calle c
	WHERE ST_Crosses(cuadra.figura,c.figura)  AND restaurantes.id = id$$
END$$


CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_getUbicacionRestaurante` (IN `id` INT)  BEGIN
	SELECT ST_X(ST_Centroid(cuadra.figura)) AS X, ST_Y(ST_Centroid(cuadra.figura)) AS Y FROM
	restaurantes INNER JOIN cuadras_restaurantes
	ON restaurantes.id = cuadras_restaurantes.idRestaurante
	INNER JOIN cuadra
	ON cuadras_restaurantes.idCuadra = cuadra.id
	WHERE restaurantes.id = id$$
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_getDistaciaRestaurantes` (IN `p_idR1` INT, N `p_idR2`` INT)  BEGIN
	SELECT ST_distance(c1.figura,c2.figura) FROM 
	restaurantes r1 INNER JOIN cuadras_restaurantes cr1
	ON r1.id = cr1.idRestaurante
	INNER JOIN cuadra c1
	ON cr1.idCuadra = c1.id,
	restaurantes r2 INNER JOIN cuadras_restaurantes cr2
	ON r2.id = cr2.idRestaurante
	INNER JOIN cuadra c2
	ON cr2.idCuadra = c2.id
	WHERE r1.id = p_idR1 AND r2.id = p_idR2
END$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `avenida`
--

CREATE TABLE `avenida` (
  `id` int(11) NOT NULL,
  `nombre` varchar(20) NOT NULL,
  `figura` linestring NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `avenida`
--

INSERT INTO `avenida` (`id`, `nombre`, `figura`) VALUES
(1, 'Avenida1', '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0@\0\0\0\0\0\0\0\0'),
(2, 'Avenida2', '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0?\0\0\0\0\0\0@\0\0\0\0\0\0?'),
(3, 'Avenida3', '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0\0@'),
(4, 'Avenida4', '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0@'),
(5, 'Avenida5', '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0@'),
(6, 'Avenida6', '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0@');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `calle`
--

CREATE TABLE `calle` (
  `id` int(11) NOT NULL,
  `nombre` varchar(20) NOT NULL,
  `figura` linestring NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `calle`
--

INSERT INTO `calle` (`id`, `nombre`, `figura`) VALUES
(1, 'Calle1', '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0@'),
(2, 'Calle2', '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0?\0\0\0\0\0\0\0\0\0\0\0\0\0\0?\0\0\0\0\0\0@'),
(3, 'Calle3', '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0@\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0@\0\0\0\0\0\0@'),
(4, 'Calle4', '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0@\0\0\0\0\0\0\0\0\0\0\0\0\0\0@\0\0\0\0\0\0@'),
(5, 'Calle5', '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0@\0\0\0\0\0\0\0\0\0\0\0\0\0\0@\0\0\0\0\0\0@'),
(9, 'Calle6', '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0@\0\0\0\0\0\0\0\0\0\0\0\0\0\0@\0\0\0\0\0\0@');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cuadra`
--

CREATE TABLE `cuadra` (
  `id` int(11) NOT NULL,
  `nombre` varchar(20) NOT NULL,
  `figura` polygon NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `cuadra`
--

INSERT INTO `cuadra` (`id`, `nombre`, `figura`) VALUES
(1, 'Cuadra1', '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0?\0\0\0\0\0\0?\0\0\0\0\0\0?\0\0\0\0\0\0?\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0'),
(2, 'Cuadra2', '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0?\0\0\0\0\0\0\0\0\0\0\0\0\0\0?\0\0\0\0\0\0?\0\0\0\0\0\0\0@\0\0\0\0\0\0?\0\0\0\0\0\0\0@\0\0\0\0\0\0\0\0\0\0\0\0\0\0?\0\0\0\0\0\0\0\0'),
(3, 'Cuadra3', '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0@\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0@\0\0\0\0\0\0?\0\0\0\0\0\0@\0\0\0\0\0\0?\0\0\0\0\0\0@\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0@\0\0\0\0\0\0\0\0'),
(4, 'Cuadra4', '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0@\0\0\0\0\0\0\0\0\0\0\0\0\0\0@\0\0\0\0\0\0?\0\0\0\0\0\0@\0\0\0\0\0\0?\0\0\0\0\0\0@\0\0\0\0\0\0\0\0\0\0\0\0\0\0@\0\0\0\0\0\0\0\0'),
(5, 'Cuadra5', '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0@\0\0\0\0\0\0\0\0\0\0\0\0\0\0@\0\0\0\0\0\0?\0\0\0\0\0\0@\0\0\0\0\0\0?\0\0\0\0\0\0@\0\0\0\0\0\0\0\0\0\0\0\0\0\0@\0\0\0\0\0\0\0\0'),
(6, 'Cuadra6', '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0?\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0@\0\0\0\0\0\0?\0\0\0\0\0\0\0@\0\0\0\0\0\0?\0\0\0\0\0\0?\0\0\0\0\0\0\0\0\0\0\0\0\0\0?'),
(7, 'Cuadra7', '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0?\0\0\0\0\0\0?\0\0\0\0\0\0?\0\0\0\0\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0?\0\0\0\0\0\0?\0\0\0\0\0\0?'),
(8, 'Cuadra8', '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0@\0\0\0\0\0\0?\0\0\0\0\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0?\0\0\0\0\0\0\0@\0\0\0\0\0\0?'),
(9, 'Cuadra9', '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0@\0\0\0\0\0\0?\0\0\0\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0?\0\0\0\0\0\0@\0\0\0\0\0\0?'),
(10, 'Cuadra10', '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0@\0\0\0\0\0\0?\0\0\0\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0?\0\0\0\0\0\0@\0\0\0\0\0\0?'),
(11, 'Cuadra11', '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0@\0\0\0\0\0\0\0\0\0\0\0\0\0\0@\0\0\0\0\0\0?\0\0\0\0\0\0@\0\0\0\0\0\0?\0\0\0\0\0\0\0@\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0@'),
(12, 'Cuadra12', '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0?\0\0\0\0\0\0\0@\0\0\0\0\0\0?\0\0\0\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0?\0\0\0\0\0\0\0@'),
(13, 'Cuadra13', '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0@'),
(14, 'Cuadra14', '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0\0@'),
(15, 'Cuadra15', '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0\0@'),
(16, 'Cuadra16', '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0@\0\0\0\0\0\0\0\0\0\0\0\0\0\0@\0\0\0\0\0\0?\0\0\0\0\0\0@\0\0\0\0\0\0?\0\0\0\0\0\0@\0\0\0\0\0\0\0\0\0\0\0\0\0\0@'),
(17, 'Cuadra17', '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0?\0\0\0\0\0\0@\0\0\0\0\0\0?\0\0\0\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0?\0\0\0\0\0\0@'),
(18, 'Cuadra18', '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0@'),
(19, 'Cuadra19', '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0@'),
(20, 'Cuadra20', '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0@'),
(21, 'Cuadra21', '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0@\0\0\0\0\0\0\0\0\0\0\0\0\0\0@\0\0\0\0\0\0?\0\0\0\0\0\0@\0\0\0\0\0\0?\0\0\0\0\0\0@\0\0\0\0\0\0\0\0\0\0\0\0\0\0@'),
(22, 'Cuadra22', '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0?\0\0\0\0\0\0@\0\0\0\0\0\0?\0\0\0\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0?\0\0\0\0\0\0@'),
(23, 'Cuadra23', '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0@'),
(24, 'Cuadra24', '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0@'),
(25, 'Cuadra25', '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0@\0\0\0\0\0\0@');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cuadras_restaurantes`
--

CREATE TABLE `cuadras_restaurantes` (
  `idCuadra` int(11) NOT NULL,
  `idRestaurante` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `cuadras_restaurantes`
--

INSERT INTO `cuadras_restaurantes` (`idCuadra`, `idRestaurante`) VALUES
(13, 1),
(11, 2),
(15, 3);

--
-- √çndices para tablas volcadas
--

--
-- Indices de la tabla `avenida`
--
ALTER TABLE `avenida`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `calle`
--
ALTER TABLE `calle`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `cuadra`
--
ALTER TABLE `cuadra`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `cuadras_restaurantes`
--
ALTER TABLE `cuadras_restaurantes`
  ADD KEY `idCuadra` (`idCuadra`),
  ADD KEY `idRestaurante` (`idRestaurante`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `avenida`
--
ALTER TABLE `avenida`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
--
-- AUTO_INCREMENT de la tabla `calle`
--
ALTER TABLE `calle`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;
--
-- AUTO_INCREMENT de la tabla `cuadra`
--
ALTER TABLE `cuadra`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;
--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `cuadras_restaurantes`
--
ALTER TABLE `cuadras_restaurantes`
  ADD CONSTRAINT `cuadras_restaurantes_ibfk_1` FOREIGN KEY (`idCuadra`) REFERENCES `cuadra` (`id`),
  ADD CONSTRAINT `cuadras_restaurantes_ibfk_2` FOREIGN KEY (`idRestaurante`) REFERENCES `restaurantes` (`id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
