<?php
include("conexion.php");
	$con = mysqli_connect($host,$user,$pw,$db) or die("problemas al conectar");
	$query = "CALL sp_loginUsuario('$_POST[user]', '$_POST[pw]')";

	echo $query;
	echo "<br>";

	$registro = mysqli_query($con,$query) or die("problemas en consulta:".mysqli_error());

	$row = mysqli_fetch_row($registro);

	if(mysqli_more_results($con))
	while(mysqli_next_result($con)){echo "*"."<br>";};

	if(!strcmp($row[0], 'admin')){
		$query = "CALL SP_getInfoUsuarioAdministrador('".$row['idAdministrador']."')";
		$registro = mysqli_query($con,$query) or die("problemas en consulta:".mysqli_error());
		$row = mysqli_fetch_row($registro);

		echo $row[0];
		echo $row[1];
	}else{
      // Clientes 
		$query = "CALL SP_getInfoUsuarioCliente('".$row[1]."')";
		$registro = mysqli_query($con,$query)or die("Error en: $query".mysqli_error());
		$rawdata= array(); // creamos array
		//guardamos en un array multidimensional todos los datos de la consulta
		    $i=0;
		 
		 while($rows = mysqli_fetch_array($registro))
		    {
		        $rawdata[$i] = $rows;
		        $i++;
		    }

		echo json_encode($rawdata);
		
	}

?>