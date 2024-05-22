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
    // property Container windowContainer: container







    ColumnLayout{
        anchors.fill: parent
        spacing: 0
        Rectangle{
            id: container
            Layout.fillWidth: true
            Layout.fillHeight: true
            Image{
                anchors.fill: parent
                fillMode: Image.PreserveAspectCrop
                source: "./images/wallpaper.webp"
            }

            RowLayout{
                anchors.centerIn: parent
                spacing: 100
                Repeater{
                    model: 3
                    Image{
                        source:"/cn/pc/gis/control/icons/panpangis.svg"
                        sourceSize{
                            width: container.width * 0.67 * 0.2
                            height: width
                        }
                        opacity: 0.3
                    }
                }
            }

            // PanWindow{
            //     x: 0
            //     y: 0
            //     width: 800
            //     height: 600
            //     visible: true
            // }
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
                // PanButton{
                //     Layout.alignment: Qt.AlignVCenter
                //     icon: PanAwesomeIcons.fa_city
                //     iconFontName: PanFonts.awesomeSolid.name
                //     iconSize: 24
                //     flat : true
                // }


                PanButton{
                    Layout.alignment: Qt.AlignVCenter

                    imageIcon: true
                    iconSize: 24
                    icon: "/cn/pc/gis/control/icons/panpangis.svg"
                    flat: true
                    implicitWidth: 40
                    implicitHeight: 40
                }

                PanButton{
                    Layout.alignment: Qt.AlignVCenter
                    icon: PanAwesomeIcons.fa_database
                    iconSize: 24
                    iconFontName: PanFonts.awesomeSolid.name
                    flat : true
                    implicitWidth: 40
                    implicitHeight: 40
                    ToolTip.visible: hovered
                    ToolTip.delay: 300
                    ToolTip.text: "空间数据管理"
                }

                PanButton{
                    Layout.alignment: Qt.AlignVCenter
                    icon: PanAwesomeIcons.fa_globe_asia
                    iconFontName: PanFonts.awesomeSolid.name
                    iconSize: 24
                    flat : true
                    implicitWidth: 40
                    implicitHeight: 40
                    ToolTip.visible: hovered
                    ToolTip.delay: 300
                    ToolTip.text: "打开新的地图窗口"
                }

            }
        }
    }


}
