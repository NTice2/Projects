<?php

  $db_host = 'localhost';
  $db_user = 'root';
  $db_password = 'root';
  $db_db = 'test';
  //$db_port = 3306;

  $mysqli = new mysqli(
    $db_host,
    $db_user,
    $db_password,
    $db_db
  );
	
    /*
    $host = "localhost";
    $username ="root";
    $user_pass ="root"
    $database_in_use = "test";

    $mysqli= new mysqli($host, $username, $user_pass, $database_in_use);
    */
  if ($mysqli->connect_error) {
    echo 'Errno: '.$mysqli->connect_errno;
    echo '<br>';
    echo 'Error: '.$mysqli->connect_error;
    exit();
  }
  

  //echo 'Success: A proper connection to MySQL was made.';
  //echo '<br>';
  //echo 'Host information: '.$mysqli->host_info;
  //echo '<br>';
  //echo 'Protocol version: '.$mysqli->protocol_version;

  //$mysqli->close();
?>