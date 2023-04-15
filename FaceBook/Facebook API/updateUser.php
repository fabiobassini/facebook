<?php

if (empty($_REQUEST['id']) || empty($_REQUEST['email']) || empty($_REQUEST['firstname']) || empty($_REQUEST['lastname']) || empty($_REQUEST['birthday']) || empty($_REQUEST['gender'])) {
    $return['status'] = '400';
    $return['message'] = 'Missing required Information';
    echo json_encode($return);
    return;
}


// secure php data
$id_secure = htmlspecialchars($_REQUEST['id'], ENT_QUOTES, 'UTF-8');
$email_secure = htmlspecialchars($_REQUEST['email'], ENT_QUOTES, 'UTF-8');
$firstname_secure = htmlspecialchars($_REQUEST['firstname'], ENT_QUOTES, 'UTF-8');
$lastname_secure = htmlspecialchars($_REQUEST['lastname'], ENT_QUOTES, 'UTF-8');
$bithday_secure = htmlspecialchars($_REQUEST['birthday'],  ENT_QUOTES, 'UTF-8');
$gender_secure = htmlspecialchars($_REQUEST['gender'], ENT_QUOTES, 'UTF-8');


// STEP 2: establish connection to DB
// require('secure/access.php');
require('secure/access.php');
$access = new Access;
$access->connect();

$result = $access->updateUser($email_secure, $firstname_secure, $lastname_secure, $bithday_secure, $gender_secure, $id_secure);

if ($result >= 1) {

    $return['status'] = '200';
    $return['message'] = 'User updated Successfully';

    if ($_REQUEST['newPassword'] == TRUE) {
        $pwd_secure = htmlspecialchars($_REQUEST['password'], ENT_QUOTES, 'UTF-8');
        // generating 20 chars pseudo
        $salt = openssl_random_pseudo_bytes(200);
        $encrypted_password = sha1($pwd_secure . $salt);

        $passwordChanged = $access->updatePassword($id_secure, $encrypted_password, $salt);

        if ($passwordChanged) {
            $return['message'] = 'Password is changed successfully';
        } else {
            $return['message'] = 'Password is could not be changed';
        }
    }

    $user = $access->selectUserID($id_secure);

    if ($user) {
        $return['email'] = $user['email'];
        $return['firstname'] = $user['firstName'];
        $return['lastname'] = $user['lastName'];
        $return['password'] = $user['password'];
        $return['birthday'] = $user['birthday'];
        $return['gender'] = $user['gender'];
        $return['id'] = $user['id'];
        $return['cover'] = $user['cover'];
        $return['user'] = $user['user'];
        $return['bio'] = $user['bio'];
    } else {
        $return['status'] = '400';
        $return['message'] = 'Could Not complete the process';
    }

} else {
    $return['status'] = '400';
    $return['message'] = 'Could Not update user';
}

$access->close();

echo json_encode($return);

?>