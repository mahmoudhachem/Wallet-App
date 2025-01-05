<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET");
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


if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    try {
        // Get the database connection
        $db = getDB();

        // Prepare the SQL query to get user data (You can modify this query based on your needs)
        $query = "SELECT firstname, lastname, balance FROM accounts LIMIT 1"; // Assuming you want the first user, you can adjust this
        $stmt = $db->prepare($query);

        // Execute the query
        $stmt->execute();

        // Fetch the user data
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
