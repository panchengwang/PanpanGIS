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

    property ListModel openWindows : ListModel{}
    property Container windowContainer: container
    Image{
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        source: "./images/wallpaper.webp"
    }






    ColumnLayout{
        anchors.fill: parent
        spacing: 0
        Container{
            id: container
            Layout.fillWidth: true
            Layout.fillHeight: true
            opacity: 0
//             PanWindow{
//                 visible: true
// caption: "asdfsdfdsfsdf"
// showButtons: true
//             }
        }

        Rectangle{
            height: 1
            border.width: 1
            border.color: PanStyles.color_button_border
            Layout.fillWidth: true
        }

        Rectangle{
            id: dockBar
            color: PanStyles.color_window_caption_background
            Layout.fillWidth: true
            height: PanStyles.header_implicit_height * 1.5
            RowLayout{
                anchors.centerIn: parent
                // height: parent.height
                PanButton{
                    Layout.alignment: Qt.AlignVCenter
                    text: ""
                    icon: PanMaterialIcons.md_apps
                    iconSize: dockBar.height - 4
                    flat : true
                }
            }
        }
    }


}
