pragma Singleton

import QtQuick
import QtQuick.Controls

//全局变量，保存整个应用的运行配置和状态

QtObject {
    // UI相关
    property PanDesktop desktop: null                                                           // 指向GIS桌面UI
    property Rectangle windowContainer: null                                                    // 所有窗体均的父窗体，window将被限制在此ui
    property PanLogWindow logWindow: null                                                       // 日志窗口
    property PanBusyIndicator busyIndicator: null
    property PanNotify notify: null

    property PanCatalogWindow catalogWindow: null                                               // 空间数据管理
    property PanMapEditorWindow mapEditorWindow: null                                           // 地图编辑窗口

    property int zIndexOfTopWin: 100                                                            // 最上层window的z index

    property string token: ''                                                                   // 登陆后产生的token
    property string username: ''                                                                // 用户名
    property string nickname: '请登录'                                                           // 用户昵称
    property string masterUrl: 'https://127.0.0.1/service/PanMasterService.php'                 // 管理服务url
    property string nodeUrl: ''                                                                 // 节点服务url



}
