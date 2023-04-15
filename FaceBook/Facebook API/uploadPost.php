<?php

if (empty($_REQUEST['user_id']) || empty($_REQUEST['text'])) {

    $return['status'] = '400';
    $return['message'] = 'Missing Required Information';
    echo json_encode($return);
    return;
}

$secure_user_id = htmlspecialchars($_REQUEST['user_id'], ENT_QUOTES, 'UTF-8');
$secure_text = htmlspecialchars($_REQUEST['text'], ENT_QUOTES, 'UTF-8');
$picture = '';


// STEP 2: establish connection to DB
// require('secure/access.php');
require('secure/access.php');
$access = new Access;
$access->connect();

if (isset($_FILES['file']) && $_FILES['file']['size'] > 1) {

    $folder = '/Applications/MAMP/htdocs/Facebook/posts/' . $secure_user_id;

    if (!file_exists($folder)) {
        mkdir($folder, 0777, true);
    }

    $filePath = $folder . '/' . basename($_FILES['file']['name']);

    if (move_uploaded_file($_FILES['file']['tmp_name'], $filePath)) {

        $picture = 'http://localhost:8888/Facebook/posts/' . $secure_user_id . '/' . $_FILES['file']['name'];


        $result = $access->uploadPost($secure_user_id, $secure_text, $picture);
        $user = $access->selectUserID($secure_user_id);

        if ($result >= 1) {
            $return['status'] = '200';
            $return['message'] = 'Post is uploaded successfully!';

            $return['picture'] = $picture;
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
            $return['message'] = 'Could not upload Post';
        }
    } else {
        $return['status'] = '401';
        $result['message'] = 'Post does not exists';
    }
}


$access->close();
echo json_encode($return);



?>