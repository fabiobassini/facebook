<?php
// required headers
header("Access-Control-Allow-Origin: http://localhost:8888/Facebook/");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

 

// STEP 1: Reciving Data
if (empty($_REQUEST['email']) || empty($_REQUEST['firstname']) || empty($_REQUEST['lastname']) || empty($_REQUEST['password']) || empty($_REQUEST['birthday']) || empty($_REQUEST['gender'])) {
    $return['status'] = '400';
    $return['message'] = 'Missing user Info';
    echo json_encode($return);
    return;
}

// secure php data
$email_secure = htmlspecialchars($_REQUEST['email'], ENT_QUOTES, 'UTF-8');
$firstname_secure = htmlspecialchars($_REQUEST['firstname'], ENT_QUOTES, 'UTF-8');
$lastname_secure = htmlspecialchars($_REQUEST['lastname'], ENT_QUOTES, 'UTF-8');
$pwd_secure = htmlspecialchars($_REQUEST['password'], ENT_QUOTES, 'UTF-8');
$bithday_secure = htmlspecialchars($_REQUEST['birthday'],  ENT_QUOTES, 'UTF-8');
$gender_secure = htmlspecialchars($_REQUEST['gender'], ENT_QUOTES, 'UTF-8');

$cover = "COVER_DEFAULT";
$cover_secure = htmlspecialchars($cover, ENT_QUOTES, 'UTF-8');

$user = "USER_DEFAULT";
$user_secure = htmlspecialchars($user, ENT_QUOTES, 'UTF-8');

$bio = "BIO_DEFAULT";
$bio_secure = htmlspecialchars($bio, ENT_QUOTES, 'UTF-8');

// $return['cover'] = $user['cover'];
// $return['ava'] = $user['ava'];

// generating 20 chars pseudo
$salt = openssl_random_pseudo_bytes(200);
$encrypted_password = sha1($pwd_secure . $salt);
// echo($encrypted_password);

// STEP 2: establish connection to DB
// require('secure/access.php');
require('secure/access.php');
$access = new Access;
$access->connect();


// STEP 3: Check avaibility of the user/ login information

$user = $access->selectUser($email_secure);

if (!empty($user)) {
    $return['status'] = '400';
    $return['message'] = 'The email is alredy registered';

} else {

    $result = $access->insertUser($email_secure, $firstname_secure, $lastname_secure, $encrypted_password, $salt ,$bithday_secure, $gender_secure, $cover_secure, $user_secure, $bio_secure);
    $user = $access->selectUser($email_secure);

    if ($result >= 1) {
        $return['status'] = '200';
        $return['message'] = 'User registered successfull';
        $return['email'] = $email_secure;
        $return['firstname'] = $firstname_secure;
        $return['lastname'] = $lastname_secure;
        $return['password'] = $encrypted_password;
        $return['birthday'] = $bithday_secure;
        $return['gender'] = $gender_secure;
        $return['cover'] = $cover_secure;
        $return['user'] = $user_secure;
        $return['bio'] = $bio_secure;
        $return['id'] = $user['id'];

    } else {
        $return['status'] = '400';
        $return['message'] = 'Could not insert information';

    }
}

$access->close();
echo json_encode($return);


?>