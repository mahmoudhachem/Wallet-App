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
    die("Connection failed: " . $conn->connect_error);
}


$sql = "DELETE FROM expenses";


if ($conn->query($sql) === TRUE) {
    
    echo json_encode([
        "status" => "success",
        "message" => "All expenses have been cleared."
    ]);
} else {
    
    echo json_encode([
        "status" => "error",
        "message" => "Error clearing expenses: " . $conn->error
    ]);
}


$conn->close();
?>

