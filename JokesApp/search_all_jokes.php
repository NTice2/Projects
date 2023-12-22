<?php



//if there are any values in the table display one at a time
if($mysqli->connect_errno)
{
    echo "Failed to connect to MySQL" . $mysqli->connect_error;
}

echo $mysqli->host_info . "<br>";

$sql = "SELECT JokeID, Joke_question, Joke_answer,users_id FROM jokes_table";
$result = $mysqli->query($sql);

if ($result->num_rows > 0) {
  // output data of each row
  while($row = $result->fetch_assoc()) {
    echo "id: " . $row["JokeID"]. " - Joke Question: " . $row["Joke_question"]. " " . $row["Joke_answer"] . " submitted by " . $row["users_id"] . "<br>";
    
  }
} else {
  echo "0 results";
}

?>