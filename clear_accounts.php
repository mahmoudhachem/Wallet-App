<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

define('DB_SERVER', 'localhost');  // Your database server
define('DB_USERNAME', 'root');     // Your database username
define('DB_PASSWORD', '');         // Your database password
define('DB_DATABASE', 'user_db'); // Your database name

function getDB() {
    $dbConnection = null;
    try {
        $dbConnection = new PDO("mysql:host=" . DB_SERVER . ";dbname=" . DB_DATABASE, DB_USERNAME, DB_PASSWORD);
        $dbConnection->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    } catch (PDOException $e) {
        echo "Connection error: " . $e->getMessage();
    }
    return $dbConnection;
}


if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    try {
        // Get the database connection
        $db = getDB();

        // SQL query to delete all records from the Users table
        $query = "DELETE FROM accounts"; // Adjust the table name if necessary
        $stmt = $db->prepare($query);

        // Execute the query
        $stmt->execute();

        // Return a success message
        echo json_encode(["message" => "All records have been deleted from the Users table"]);
    } catch (PDOException $e) {
        echo json_encode(["message" => "Error: " . $e->getMessage()]);
    }
} else {
    echo json_encode(["message" => "Invalid request method"]);
}
?>
