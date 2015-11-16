<?php
// Realizar log-in con el e-mail y contraseña del usuario.
include("conexion.php");

// Realizar solicitud a BD
$con = mysqli_connect($host, $user, $pw, $db) or die("No se pudo realizar la conexión");
$query = "CALL sp_loginUsuario('$_POST[user]', '$_POST[pw]')";
$resultado = mysqli_query($con, $query) or die("Hubo un error en la consulta de la BD:" . mysqli_error($con));

// Crea array para guardar resultados
$jsonArray = array();

// Obtiene cada fila del conjunto resultado.
while ($row = mysqli_fetch_row($resultado)) {
    $jsonArray[] = $row;
}

// Crea objeto JSON para guardar conjunto resultado
$jsonData = json_encode($jsonArray);

echo $jsonData;
?>