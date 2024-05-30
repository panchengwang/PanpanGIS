import QtQuick
import QtQuick.Controls
import cn.pc.gis.control
import QtQuick.Layouts

ApplicationWindow {
    id: desktop

    property ListModel openWindows : ListModel{}
    property Rectangle windowContainer: container


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

            PanLogWindow{
                id: logWindow
                z: 1000
                x: parent.width - width - PanStyles.default_margin
                y: parent.height-height - PanStyles.default_margin
                // visible: true
                movable: false
                modal: false
                resizebar: "tl"
                closePolicy: Popup.NoAutoClose
                stickButtonVisible: true
                Component.onCompleted: {
                    PanApplication.logWindow = logWindow
                }
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
                anchors.fill: parent
                // height: parent.height
                // PanButton{
                //     Layout.alignment: Qt.AlignVCenter
                //     icon: PanAwesomeIcons.fa_city
                //     iconFontName: PanFonts.awesomeSolid.name
                //     iconSize: 24
                //     flat : true
                // }

                Item{
                    Layout.fillWidth: true
                }
                PanButton{
                    Layout.alignment: Qt.AlignVCenter

                    imageIcon: true
                    iconSize: 26
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

                Item{
                    Layout.fillWidth:  true
                }

                PanButton{
                    Layout.alignment: Qt.AlignVCenter
                    icon: PanAwesomeIcons.fa_comment_dots
                    iconFontName: PanFonts.awesomeSolid.name
                    iconSize: 24
                    flat : true
                    implicitWidth: 40
                    implicitHeight: 40
                    ToolTip.visible: hovered
                    ToolTip.delay: 300
                    ToolTip.text: "系统消息"
                    Layout.rightMargin: PanStyles.default_margin
                    onClicked: {
                        if(logWindow.opened){
                            logWindow.close()
                        }else{
                            logWindow.open()
                        }
                    }
                }

            }
        }
    }

    Component.onCompleted: {

        PanApplication.desktop = desktop
        PanApplication.windowContainer = container

        createLoginWindow()
    }

    function createLoginWindow(){
        const loginWin = Qt.createQmlObject(`
                                            PanLoginWindow{
                                            x: (parent.width-width)*0.5
                                            y: Math.max(100 , (parent.height - height)*0.5-100)
                                            width: Math.max(400,parent.width*0.25)
                                            visible: true
                                            }
                                            `,
                                            PanApplication.windowContainer,
                                            "loginWin"
                                            );
        loginWin.cancel.connect(()=>{
                                    loginWin.destroy()
                                })

    }



}
