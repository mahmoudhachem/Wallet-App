<?php

header("Access-Control-Allow-Origin: *"); // Allow all origins (use a specific origin for better security)
header("Access-Control-Allow-Methods: GET, POST, OPTIONS"); // Specify allowed HTTP methods
header("Access-Control-Allow-Headers: Content-Type, Authorization"); // Specify allowed headers

header('Content-Type: application/json');

$host = 'localhost'; 
$dbname = 'user_db'; 
$username = 'root'; 
$password = ''; 


$conn = new mysqli($host, $username, $password, $dbname);


if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}


$data = json_decode(file_get_contents("php://input"), true);


if (isset($data['amount']) && isset($data['category']) && isset($data['date'])) {
    $amount = $data['amount'];
    $category = $data['category'];
    $date = $data['date'];

    
    $stmt = $conn->prepare("INSERT INTO expenses (amount, category, date) VALUES (?, ?, ?)");
    $stmt->bind_param("dss", $amount, $category, $date);

    
    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Expense added successfully"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Failed to add expense"]);
    }

    $stmt->close();
} else {
    echo json_encode(["status" => "error", "message" => "Invalid data"]);
}


$conn->close();
?>
