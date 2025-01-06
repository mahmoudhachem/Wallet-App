<?php
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

error_reporting(E_ALL);
ini_set('display_errors', 1);


$servername = "localhost";
$username = "root";
$password = "";
$dbname = "user_db";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die(json_encode(['status' => 'error', 'message' => 'Connection failed: ' . $conn->connect_error]));
}

if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    $sql = "SELECT * FROM expenses";  
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        $expenses = [];
        while($row = $result->fetch_assoc()) {
            $expenses[] = $row;
        }
        echo json_encode(['status' => 'success', 'data' => $expenses]);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'No expenses found']);
    }
}

$conn->close();
?>
