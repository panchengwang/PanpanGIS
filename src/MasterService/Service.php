<?php

include './Server.php';

if(!isset($_REQUEST["request"])){
    echo json_encode(array(
        "success" => false,
        "message" => "need request parameter"
    ));

    exit(0);
}

$request = json_decode($_REQUEST["request"]);
if(!$request){
    echo json_encode(array(
        "success" => false,
        "message" => "Invalid request parameter"
    ));
    

    exit(0);
}

$sv = new Server();

echo json_encode($sv->getResponse());