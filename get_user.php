<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET");
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


if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    try {
        
        $db = getDB();


        $query = "SELECT firstname, lastname, balance FROM accounts LIMIT 1";
        $stmt = $db->prepare($query);

        
        $stmt->execute();

        
        $user = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($user) {
            echo json_encode([
                "firstname" => $user['firstname'],
                "lastname" => $user['lastname'],
                "balance" => $user['balance']
            ]);
        } else {
            echo json_encode(["message" => "User not found"]);
        }
    } catch (PDOException $e) {
        echo json_encode(["message" => "Error: " . $e->getMessage()]);
    }
} else {
    echo json_encode(["message" => "Invalid request method"]);
}
?>
