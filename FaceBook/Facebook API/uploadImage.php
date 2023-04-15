<?php
// required headers
header("Access-Control-Allow-Origin: http://localhost:8888/Facebook/");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

 

if (empty($_REQUEST['id']) || empty($_REQUEST['type'])) {
    $return['status'] = '400';
    $return['message'] = 'Missing user Info';
    echo json_encode($return);
    return;
}

// secure php data
$id_secure = htmlspecialchars($_REQUEST['id'], ENT_QUOTES, 'UTF-8');
$type_secure = htmlspecialchars($_REQUEST['type'], ENT_QUOTES, 'UTF-8');


// STEP 2: establish connection to DB
// require('secure/access.php');
require('secure/access.php');
$access = new Access;
$access->connect();

if (isset($_FILES['file']) && $_FILES['file']['size'] > 1) {

    $folder = '/Applications/MAMP/htdocs/Facebook/' . $type_secure . '/' . $id_secure;

    if (!file_exists($folder)) {
        mkdir($folder, 0777, true);
    }

    $filePath = $folder . '/' . basename($_FILES['file']['name']);

    if (move_uploaded_file($_FILES['file']['tmp_name'], $filePath)) {
        $fileURL = 'http://localhost:8888/Facebook/' . $type_secure . '/' . $id_secure . '/' . $_FILES['file']['name'];

        $access->updateImagePath($type_secure, $fileURL, $id_secure);

        $return['status'] = '200';
        $return['message'] = 'File ' . $type_secure . ' has been successfully uploaded';
        $return['' . $type_secure . ''] = $fileURL;


        $user = $access->selectUserID($id_secure);

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
        $return['message'] = 'Could not upload file';
    }

}

$access->close();
echo json_encode($return);

?>
