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
    // Get the raw POST data (JSON)
    $data = json_decode(file_get_contents("php://input"));

    // Check if all required fields are present
    if (isset($data->firstname) && isset($data->lastname) && isset($data->balance)) {
        $firstname = $data->firstname;
        $lastname = $data->lastname;
        $balance = $data->balance;

        try {
            // Get the database connection
            $db = getDB();

            // Prepare the SQL query to insert data into the table
            $query = "INSERT INTO accounts (firstname, lastname, balance) VALUES (:firstname, :lastname, :balance)";
            $stmt = $db->prepare($query);

            // Bind the values to the query
            $stmt->bindParam(':firstname', $firstname);
            $stmt->bindParam(':lastname', $lastname);
            $stmt->bindParam(':balance', $balance);

            // Execute the query
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
