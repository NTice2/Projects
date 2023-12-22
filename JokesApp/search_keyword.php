<head>



<link rel="stylesheet" href="//code.jquery.com/ui/1.13.0/themes/base/jquery-ui.css">
  <link rel="stylesheet" href="/resources/demos/style.css">
  <script src="https://code.jquery.com/jquery-3.6.0.js"></script>
  <script src="https://code.jquery.com/ui/1.13.0/jquery-ui.js"></script>
  <script>
  $( function() {
    $( "#accordion" ).accordion();
  } );
  </script>



<style>
{
    font-family:Arial, Helvetica, sans-serrif;
}

</style>

</head>





<?php

include "db_connect.php";


$keywordfromform = $_GET["keyword"];


echo $mysqli->host_info . "<br>";

echo "<h2> Show all jokes with the word $keywordfromform  </h2>";

//search the database for word

$sql = "SELECT JokeID, Joke_question, Joke_answer, users_id,username
FROM jokes_table 
JOIN users ON users.id = jokes_table.users_id
WHERE Joke_question LIKE '%$keywordfromform%'";

echo "SQL Statement = ". $sql . "<br>";




$result = $mysqli->query($sql);

if ($result->num_rows > 0) {
  // output data of each row
  
  
  ?>
    
  <div id="accordion">

  <?php
  
  while($row = $result->fetch_assoc()) {
    
    //echo "id: " . $row["JokeID"]. " - Joke Question: " . $row["Joke_question"]. " " . $row["Joke_answer"]. "<br>";  
    echo "<h3> $row[Joke_question] </h3>";
    
    echo "<div><p>" . $row["Joke_answer"] . "--- submitted by user " . $row["username"] .  "</p></div>";    
    
  }
} else {
  echo "0 results";
}


?>

</div>