<?php
$context = stream_context_create(array('http' => array('ignore_errors' => true)));
$response = file_get_contents('http://nombre-microservicio:3000/nombre?codigo=001', false, $context);
$data = json_decode($response, true);

if (isset($data['nombre'])) {
    echo "<h1>Hola " . htmlspecialchars($data['nombre']) . "</h1>";
} else {
    $msg = isset($data['error']) ? $data['error'] : 'Error desconocido';
    echo "<h1>Error: " . htmlspecialchars($msg) . "</h1>";
}
?>
