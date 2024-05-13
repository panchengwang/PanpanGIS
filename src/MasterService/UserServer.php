<?php

include './DBConf.php';
include './Server.php';

/**
 * Description of UserServer
 *
 * @author pcwang
 */
class UserServer extends Server {

    #[\Override]
    public function __construct() {
        parent::__construct();
        $this->_response = array(
            "success" => false,
            "message" => "用户服务"
        );
    }

    #[\Override]
    protected function process() {
        
    }
}
