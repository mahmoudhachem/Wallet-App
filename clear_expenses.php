<?php
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

error_reporting(E_ALL);
ini_set('display_errors', 1);


// Database connection
$servername = "localhost";
$username = "root"; // your database username
$password = ""; // your database password
$dbname = "user_db"; // your database name

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// SQL query to delete all records from the 'expenses' table
$sql = "DELETE FROM expenses";

// Execute the query
if ($conn->query($sql) === TRUE) {
    // Return a success response
    echo json_encode([
        "status" => "success",
        "message" => "All expenses have been cleared."
    ]);
} else {
    // Return an error response
    echo json_encode([
        "status" => "error",
        "message" => "Error clearing expenses: " . $conn->error
    ]);
}

// Close the connection
$conn->close();
?>

