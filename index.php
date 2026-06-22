<?php
$response = file_get_contents('http://nombre-microservicio:3000/nombre');
$data = json_decode($response, true);
$nombre = $data['nombre'];
echo "<h1>Hola " . htmlspecialchars($nombre) . "</h1>";
?>
