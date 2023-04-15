<?php
// required headers
header("Access-Control-Allow-Origin: http://localhost:8888/Facebook/");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

 

if (empty($_REQUEST['id'])) {

    $return['status'] = '400';
    $return['message'] = 'Missing required information';
    echo json_encode($return);
    return;
}

// $id = $_REQUEST['id'];
$id_secure = htmlspecialchars($_REQUEST['id'], ENT_QUOTES, 'UTF-8');

// $bio = $_REQUEST['bio'];
$bio_secure = htmlspecialchars($_REQUEST['bio'], ENT_QUOTES, 'UTF-8');


// STEP 2: establish connection to DB
// require('secure/access.php');
require('secure/access.php');
$access = new Access;
$access->connect();

$result = $access->updateBio($id_secure, $bio_secure);

if ($result >= 1) {

    $user = $access->selectUserID($id_secure);


    if ($user) {
        $return['status'] = '200';
        $return['message'] = 'Bio has been updated';
    
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
        $return['status'] = '400';
        $return['message'] = 'Could Not Complete The Process';
    }

} else {
    $return['status'] = '400';
    $return['message'] = 'Unable to update Bio';
}

$access->close();

echo json_encode($return);

?>