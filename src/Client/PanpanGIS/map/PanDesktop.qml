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

PanWindow{
    x: 0
    y: 0
    width: 800
    height: 600
    visible: true
}
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
                Image{
                    Layout.alignment: Qt.AlignVCenter
                    source: "/cn/pc/gis/control/icons/panpangis.svg"
                    sourceSize{
                        width:24
                        height: 24
                    }

                    width: 24
                    height:24
                    fillMode: Image.PreserveAspectFit
                }

                PanButton{
                    Layout.alignment: Qt.AlignVCenter
                    imageIcon: true
                    iconSize: 24
                    icon: "/cn/pc/gis/control/icons/panpangis.svg"
                    flat: true
                }

                PanButton{
                    Layout.alignment: Qt.AlignVCenter
                    icon: PanAwesomeIcons.fa_windows
                    iconFontName: PanFonts.awesomeBrands.name
                    iconSize: 24
                    flat : true
                }
                PanButton{
                    Layout.alignment: Qt.AlignVCenter
                    icon: PanAwesomeIcons.fa_database
                    iconSize: 24
                    iconFontName: PanFonts.awesomeSolid.name
                    flat : true
                }
                // PanButton{
                //     Layout.alignment: Qt.AlignVCenter
                //     icon: PanMaterialIcons.md_map
                //     iconSize: dockBar.height - 8
                //     flat : true
                // }
            }
        }
    }


}
