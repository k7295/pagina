<?php
include("conexion.php");
	$con = mysqli_connect($host,$user,$pw,$db) or die("problemas al conectar");
	$query = "CALL sp_getListaIngredientes()";

	echo $query;
	echo "<br>";

	$registro = mysqli_query($con,$query) or die("problemas en consulta:".mysqli_error());

	while($row = mysqli_fetch_row($registro)){
		echo $row[0]."<br>";
		echo $row[1]."<br>";
		echo '<img src="data:image/jpeg;base64,'.base64_encode( $row[2] ).'"/>',"<br>";
	}
?>