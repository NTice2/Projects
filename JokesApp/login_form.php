<html>
<head>


<!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">

<!-- jQuery library -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>

<!-- Latest compiled JavaScript -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>

</head>



<body> 
<h1>Login for Jokes App </h1>

<?php


include "db_connect.php";

//include "search_all_jokes.php";

?>  
<a href=<"login_form.php"> Click here to login<a>
<a href=<"logout.php"> Click here to log out<a>
<a href="register_new_user.php"> Click here to register <a><br>

<hr>

<form class="form-horizontal"  action ="process_login_unsecure.php">
<fieldset>

<!-- Form Name -->
<legend>Please login </legend>

<!-- Search input-->
<div class="form-group">
  <label class="col-md-4 control-label" for="username">Username</label>
  <div class="col-md-5">
    <input id="username" name="username" type="text" placeholder="your name" class="form-control input-md">
    <p class="help-block">Enter your username</p>
  </div>
</div>

<!-- Search input-->
<div class="form-group">
  <label class="col-md-4 control-label" for="password">Password</label>
  <div class="col-md-5">
    <input id="password" name="password" type="password" placeholder="password" class="form-control input-md">
    <p class="help-block">Enter your password</p>
  </div>
</div>

<!-- Button -->
<div class="form-group">
  <label class="col-md-4 control-label" for="submit"></label>
  <div class="col-md-4">
    <button id="submit" name="submit" class="btn btn-primary">Log in</button>
  </div>
</div>

</fieldset>
</form>







<?php
//include "search_keyword.php";




$mysqli->close();

//echo "<a href= 'index.php'>Return to main page </a>";
?>



</body>
</html>