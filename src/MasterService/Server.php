<?php

include_once './DBConf.php';

/**
 * Description of Server
 *
 * @author pcwang
 */
class Server {

    // 空间数据库连接
    protected $_connection = null;
    // 请求参数, json对象
    protected $_request = null;
    // 返回结果, json对象
    protected $_response = null;

    public function __construct() {
        $this->_response = array(
            "success" => false,
            "message" => "Unknown error"
        );
    }

    // 执行
    public function run() {
        $this->openDB();
        $this->process();
        $this->closeDB();
    }

    protected function openDB() {
        $connstr = "host=".HOST." port=".PORT." dbname=".DBNAME." user=".USER." password=".PASSWORD;
        $this->_connection = pg_connect($connstr);
        if(!$this->_connection){
            $this->_response = array(
                "success" => false,
                "message" => "Can not connect to database"
            );
            exit(0);
        }
    }
    
    protected function closeDB() {
        pg_close($this->_connection);
    }

    // 实际的服务处理函数，从Server继承的类应该重新实现此函数
    protected function process() {
        $this->_request = array(
            "success" => false,
            "message" => "need be implimented"
        );
    }

    // 返回执行结果
    public function getResponse() {
        return $this->_response;
    }

    public function setRequest($request) {
        $this->_request = $request;
    }
}
