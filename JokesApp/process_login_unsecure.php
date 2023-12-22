<head>
<?php

session_start();

error_reporting(E_ALL);
ini_set('display_errors',1);

include "db_connect.php";

$username = $_GET['username'];
$password = $_GET['password'];

echo "You attempted to login with " . $username . " and " . $password . "<br>";

//echo $mysqli->host_info . "<br>";

//search the database for word

$sql = "SELECT id, username, password FROM users WHERE username = '$username' AND password = '$password'";
echo "SQL = ". $sql. "<br>";
$result = $mysqli->query($sql);

echo "<pre>";
print_r($result);
echo "</pre>";


if ($result->num_rows > 0) {
  // output data of each row
      
      $row = $result->fetch_assoc();
      $userid = $row['id'];
      echo "Login successful! <br>";
      $_SESSION['username'] = $username;
      $_SESSION['userid'] = $userid;
      echo "<br><a href='index.php'> return to main page </a>";
 }
 else {
  echo "0 results. Incorrect username and password";
  $_SESSION = [];
  session_destroy();
  echo "<br><a href='index.php'> return to main page </a>";
}

echo "SESSION = <br>";

echo "<pre>";
print_r($_SESSION);
echo "</pre>";


?>

</div>