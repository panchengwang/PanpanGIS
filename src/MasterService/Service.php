<?php

include_once './UserServer.php';

if (!isset($_REQUEST["request"])) {
    echo json_encode(array(
        "success" => false,
        "message" => "need request parameter"
    ));

    exit(0);
}

$request = json_decode($_REQUEST["request"]);

if (!$request || !$request->type) {
    echo json_encode(array(
        "success" => false,
        "message" => "Invalid request parameter"
    ));

    exit(0);
}

$sv = null;
$req_group = explode("_", $request->type)[0];

if ($req_group === "USER") {
    $sv = new UserServer();
}

if ($sv) {
    $sv->setRequest($request);
    $sv->run();
}

echo json_encode($sv->getResponse());
