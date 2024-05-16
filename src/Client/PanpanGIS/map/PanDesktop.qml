import QtQuick
import QtQuick.Controls
import cn.pc.gis.control
import QtQuick.Layouts

ApplicationWindow {
    id: app
    property PanDesktop desktop: app

    property string token: ''
    property string username: ''
    property string nickname: '请登录'
    property string masterUrl: ''           // 管理服务url
    property string nodeUrl: ''             // 节点服务url


    Image{
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        source: "./images/wallpaper.webp"
    }




    PanWindow{
        id: dialog

        modal:true
        x: 100
        y: 100
        Component.onCompleted: {
            dialog.open()
        }
    }


}
