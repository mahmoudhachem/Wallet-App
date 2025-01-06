<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

define('DB_SERVER', 'localhost');  
define('DB_USERNAME', 'root');     
define('DB_PASSWORD', '');        
define('DB_DATABASE', 'user_db'); 

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
        
        $db = getDB();

        
        $query = "DELETE FROM accounts"; 
        $stmt = $db->prepare($query);

        
        $stmt->execute();

        
        echo json_encode(["message" => "All records have been deleted from the Users table"]);
    } catch (PDOException $e) {
        echo json_encode(["message" => "Error: " . $e->getMessage()]);
    }
} else {
    echo json_encode(["message" => "Invalid request method"]);
}
?>
