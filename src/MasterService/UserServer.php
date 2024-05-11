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
    protected function process() {
        $this->_response = array(
            "success" => false,
            "message" => "用户服务"
        );
    }
}
