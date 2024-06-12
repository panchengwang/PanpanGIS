<?php

//include_once './DBConf.php';

define("HOST", "127.0.0.1");
define("PORT", 5432);
define("DBNAME", "pan_master_db");
define("USER", "pcwang");
define("PASSWORD", "");

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");

if (!isset($_REQUEST["request"])) {
    echo json_encode(array(
        "success" => false,
        "message" => "need request parameter"
    ));

    exit(0);
}

$request = $_REQUEST["request"];


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