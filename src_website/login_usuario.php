<?php
// Realizar log-in con el e-mail y contraseña del usuario.
include("conexion.php");
$con = mysqli_connect($host, $user, $pw, $db) or die("No se pudo realizar la conexión");
$query = "CALL sp_loginUsuario('$_POST[user]', '$_POST[pw]')";

echo $query;
echo "<br>";

$registro = mysqli_query($con, $query) or die("Hubo un error en la consulta de la BD:" . mysqli_error($con));


$row = mysqli_fetch_row($registro);     // $row = [id, idUsuario, msg]

if (mysqli_more_results($con))
    while (mysqli_next_result($con)) {
        echo "*" . "<br>";
    };

if (!strcmp($row[0], 'admin')) {
    $query = "CALL SP_getInfoUsuarioAdministrador('" . $row[1] . "')";
    $registroAdmin = mysqli_query($con, $query) or die("problemas en consulta:" . mysqli_error($con));

    $rowAdmin = mysqli_fetch_row($registroAdmin);
    echo json_encode($rowAdmin);


} else {
    // Clientes
    $query = "CALL SP_getInfoUsuarioCliente('" . $row[1] . "')";
    $registroCliente = mysqli_query($con, $query) or die("Error en: $query" . mysqli_error($con));

    $rowCliente = mysqli_fetch_row($registroCliente);
    echo json_encode($rowAdmin);

}
?>