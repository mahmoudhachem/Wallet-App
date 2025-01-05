<?php

header("Access-Control-Allow-Origin: *"); // Allow all origins (use a specific origin for better security)
header("Access-Control-Allow-Methods: GET, POST, OPTIONS"); // Specify allowed HTTP methods
header("Access-Control-Allow-Headers: Content-Type, Authorization"); // Specify allowed headers

header('Content-Type: application/json');
// Database connection settings
$host = 'localhost'; // Database host
$dbname = 'user_db'; // Database name
$username = 'root'; // Database username
$password = ''; // Database password

// Create connection
$conn = new mysqli($host, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Get data from the POST request
$data = json_decode(file_get_contents("php://input"), true);

// Check if all necessary data is present
if (isset($data['amount']) && isset($data['category']) && isset($data['date'])) {
    $amount = $data['amount'];
    $category = $data['category'];
    $date = $data['date'];

    // Prepare the SQL query to insert the data into the database
    $stmt = $conn->prepare("INSERT INTO expenses (amount, category, date) VALUES (?, ?, ?)");
    $stmt->bind_param("dss", $amount, $category, $date);

    // Execute the query and check if it was successful
    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Expense added successfully"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Failed to add expense"]);
    }

    $stmt->close();
} else {
    echo json_encode(["status" => "error", "message" => "Invalid data"]);
}

// Close the connection
$conn->close();
?>
