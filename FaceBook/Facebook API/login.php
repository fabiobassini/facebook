<?php
// required headers
header("Access-Control-Allow-Origin: http://localhost:8888/Facebook/");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

 


// process login info / data to the DB and receiving the status / response from the server

// STEP 1: Reciving Data

if (empty($_REQUEST['email']) || empty($_REQUEST['password'])) {

    $return['status'] = '400';
    $return['message'] = 'Missing Required Information';
    echo json_encode($return);
    return;
}
$email_secure = htmlspecialchars($_REQUEST['email'], ENT_QUOTES, 'UTF-8');
$pwd_secure = htmlspecialchars($_REQUEST['password'], ENT_QUOTES, 'UTF-8');

// STEP 2: establish connection to DB
// require('secure/access.php');
require('secure/access.php');
$access = new Access;
$access->connect();


// STEP 3: Check the existance of the user by email address

$user = $access->selectUser($email_secure);

if ($user) {

    // STEP 3.1: get encrypted pwd and salt
    $encryptedPassword = $user['password'];
    $salt = $user['salt'];

    // STEP 3.2: compare entered password with the one stored in DB
    if ($encryptedPassword === sha1($pwd_secure . $salt)) {
        $return['status'] = '200';
        $return['message'] = 'Logged in successfully';
        $return['email'] = $user['email'];
        $return['firstname'] = $user['firstName'];
        $return['lastname'] = $user['lastName'];
        $return['password'] = $user['password'];
        $return['birthday'] = $user['birthday'];
        $return['gender'] = $user['gender'];
        $return['id'] = $user['id'];
        $return['bio'] = $user['bio'];
        $return['cover'] = $user['cover'];
        $return['user'] = $user['user'];

    } else {
        $return['status'] = '201';
        $return['message'] = 'Password do not match';

    }
} else {
    $return['status'] = '401';
    $return['message'] = 'Email does not exist';

}

$access->close();

echo json_encode($return);

?>