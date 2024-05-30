pragma Singleton

import QtQuick

//全局变量，保存整个应用的运行配置和状态

QtObject {
    property PanDesktop desktop: null                                                           // 指向GIS桌面UI
    property Rectangle windowContainer: null                                                    // 所有窗体均的父窗体，window将被限制在此ui
    property PanLogWindow logWindow: null                                                       // 日志窗口

    property string token: ''                                                                   // 登陆后产生的token
    property string username: ''                                                                // 用户名
    property string nickname: '请登录'                                                           // 用户昵称
    property string masterUrl: 'http://127.0.0.1/MasterService/service.php'                     // 管理服务url
    property string nodeUrl: ''                                                                 // 节点服务url
}
