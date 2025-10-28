<?php
$host = 'data';        
$user = 'app_user';    // NOUVEAU USER
$password = 'app_password'; // NOUVEAU MOT DE PASSE
$db = 'my_app_db';     

$conn = new mysqli($host, $user, $password, $db);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$update_sql = "UPDATE counters SET count = count + 1 WHERE id = 1";
$conn->query($update_sql);
echo "Count updated<br>";

$read_sql = "SELECT count FROM counters WHERE id = 1";
$result = $conn->query($read_sql);
$row = $result->fetch_assoc();
$current_count = $row['count'];

echo "Count : " . $current_count;

$conn->close();
?>