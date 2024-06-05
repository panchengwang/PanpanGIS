<?php

include_once './DBConf.php';

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");

if (!isset($_REQUEST["request"])) {
    echo json_encode(array(
        "success" => false,
        "message" => "need request parameter"
    ));

    exit(0);
}
sleep(2);
$request = $_REQUEST["request"];
//
//if (!$request || !$request->type) {
//    echo json_encode(array(
//        "success" => false,
//        "message" => "Invalid request parameter"
//    ));
//
//    exit(0);
//}


$connstr = "host=" . HOST . " port=" . PORT . " dbname=" . DBNAME . " user=" . USER . " password=" . PASSWORD;
$connection = pg_connect($connstr);
if (!$connection) {
    echo json_encode(array(
        "success" => false,
        "message" => "Can not connect to database"
    ));
    exit(0);
}


$result = pg_query_params($connection,"select pan_service($1::jsonb)",array(
    $request
));
$row = pg_fetch_row($result);
echo $row[0];

pg_free_result($result);
pg_close($connection);