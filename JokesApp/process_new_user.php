<?php

include "db_connect.php";


$new_username = $_GET['username'];
$new_password1 = $_GET['password1'];
$new_password2 = $_GET['password2'];


echo "<h2> Trying to add a new user " . $new_username . " pw = " . $new_password1 . " and " . $new_password2 . "</h2>";


if($new_password1 != $new_password2)
{
    echo "The passwords do not match. Please try again";
    exit;
}

//check to see if the user already has registered

$sql = "SELECT * FROM users where username = '$new_username'";

$result = $mysqli->query($sql) or die (mysqli_error($mysqli));

if($result->num_rows > 0)
{
    echo "The username " . $new_username . " already exists";
    exit;
}



$sql = "INSERT INTO users(id,username,password) VALUES (null, '$new_username', '$new_password1')";

$result = $mysqli->query($sql) or die (mysli_error($mysqli));

if($result)
{
    echo "Registration success";
}
else
{
    echo "Error with registration";
}


echo "<a href= 'index.php'>Return to main page </a>";


?>