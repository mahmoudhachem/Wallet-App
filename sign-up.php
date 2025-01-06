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
    
    $data = json_decode(file_get_contents("php://input"));


    if (isset($data->firstname) && isset($data->lastname) && isset($data->balance)) {
        $firstname = $data->firstname;
        $lastname = $data->lastname;
        $balance = $data->balance;

        try {

            $db = getDB();

            
            $query = "INSERT INTO accounts (firstname, lastname, balance) VALUES (:firstname, :lastname, :balance)";
            $stmt = $db->prepare($query);

            
            $stmt->bindParam(':firstname', $firstname);
            $stmt->bindParam(':lastname', $lastname);
            $stmt->bindParam(':balance', $balance);

            
            if ($stmt->execute()) {
                echo json_encode(["message" => "User successfully inserted"]);
            } else {
                echo json_encode(["message" => "Failed to insert user"]);
            }
        } catch (PDOException $e) {
            echo json_encode(["message" => "Error: " . $e->getMessage()]);
        }
    } else {
        echo json_encode(["message" => "Invalid input data"]);
    }
} else {
    echo json_encode(["message" => "Invalid request method"]);
}
?>
