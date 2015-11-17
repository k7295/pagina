<?php
include("conexion.php");
	$con = mysql_connect($host,$user,$pw) or die("problemas al conectar");
	mysql_select_db($db,$con) or die("problemas al conectar la bd");
	$query = "CALL SP_agregarIngrediente(
		$_POST[idAministrador],
		'$_POST[nombre]',
		'$_POST[precio]',
		'$_POST[foto]',
		'$_POST[idCategoria]')";
	mysql_query($query,$con);
	echo $query;
?>