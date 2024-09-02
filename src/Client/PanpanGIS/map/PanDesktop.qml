import QtQuick
import QtQuick.Controls
import cn.pc.gis.control
import QtQuick.Layouts

ApplicationWindow {
    id: desktop

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
                    model: 1
                    Image{
                        source:"/cn/pc/gis/control/icons/logo.svg"
                        sourceSize{
                            width: height
                            height: container.height * 0.6
                        }
                        opacity: 0.8
                    }
                }
            }
// PanSpatialTableWindow{

//     visible: true
//     Component.onCompleted: {
//         toCenter();
//     }
// }
            // TableView{
            //     model: PanTableModel{
            //         columns:[{
            //                 label:"id"
            //             },{
            //                 label:"name"
            //             }]
            //         rows:[
            //             { id: "1", name: "name 1" },
            //             { id: "2", name: "name 2" },
            //             { id: "3", name: "name 3" }
            //         ]
            //     }
            //     delegate: Rectangle {
            //         implicitWidth: 100
            //         implicitHeight: 50
            //         required property int row
            //         required property int column
            //         Text {
            //             text: display
            //         }
            //         Component.onCompleted: {
            //             console.log("row: ", row, "   col: " , column)
            //         }
            //     }
            //     anchors.fill: parent
            // }

            PanLogWindow{
                id: logWindow
                x: parent.width - width - PanStyles.default_margin
                y: parent.height-height - PanStyles.default_margin
                // visible: true
                movable: false
                modal: false
                resizebar: "tl"
                closePolicy: Popup.CloseOnPressOutside
                stickButtonVisible: true
                Component.onCompleted: {
                    PanApplication.logWindow = logWindow
                }
            }

            PanBusyIndicator{
                id: busyIndicator
                x: (parent.width - width)*0.5
                y: Math.max((parent.height-height)*0.5-50, 100)
                Component.onCompleted: {
                    PanApplication.busyIndicator = this
                }
            }

            PanNotify{
                id: notify
                caption: "提示信息"
                x: (parent.width - width)*0.5
                y: Math.max((parent.height-height)*0.5-50, 100)
                Component.onCompleted: {
                    PanApplication.notify = notify
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
                    backgroundVisible: false
                    isImageIcon: true
                    iconSize: 26
                    icon: "/cn/pc/gis/control/icons/logo.svg"
                    // flat: true
                    implicitWidth: 40
                    implicitHeight: 40
                }

                PanButton{
                    Layout.alignment: Qt.AlignVCenter
                    icon: PanAwesomeIcons.fa_database
                    iconSize: 24
                    iconFontName: PanFonts.awesomeSolid.name
                    iconColor: PanStyles.color_primary
                    backgroundVisible: false
                    implicitWidth: 40
                    implicitHeight: 40
                    ToolTip.visible: hovered
                    ToolTip.delay: 300
                    ToolTip.text: "空间数据管理"
                    onClicked: {
                        createCatalogWindow();
                    }
                }

                PanButton{
                    Layout.alignment: Qt.AlignVCenter
                    icon: PanAwesomeIcons.fa_globe_asia
                    iconFontName: PanFonts.awesomeSolid.name
                    iconColor: PanStyles.color_primary
                    iconSize: 24
                    backgroundVisible: false
                    implicitWidth: 40
                    implicitHeight: 40
                    ToolTip.visible: hovered
                    ToolTip.delay: 300
                    ToolTip.text: "地图编辑"

                    onClicked: {
                        createMapEditorWindow();
                    }
                }

                PanButton{
                    Layout.alignment: Qt.AlignVCenter
                    icon: PanAwesomeIcons.fa_star_half_alt
                    iconFontName: PanFonts.awesomeSolid.name
                    iconColor: PanStyles.color_primary
                    iconSize: 24
                    backgroundVisible: false
                    implicitWidth: 40
                    implicitHeight: 40
                    ToolTip.visible: hovered
                    ToolTip.delay: 300
                    ToolTip.text: "符号编辑"

                    onClicked: {
                        createSymbolEditorWindow();
                    }
                }

                PanButton{
                    Layout.alignment: Qt.AlignVCenter
                    icon: PanAwesomeIcons.fa_desktop
                    iconFontName: PanFonts.awesomeSolid.name
                    iconColor: PanStyles.color_primary
                    iconSize: 24
                    backgroundVisible: false
                    implicitWidth: 40
                    implicitHeight: 40
                    ToolTip.visible: hovered
                    ToolTip.delay: 300
                    ToolTip.text: "隐藏桌面"

                    onClicked: {
                        if(PanApplication.catalogWindow)    PanApplication.catalogWindow.visible = false
                        if(PanApplication.mapEditorWindow)  PanApplication.mapEditorWindow.visible = false
                        if(PanApplication.symbolEditorWindow) PanApplication.symbolEditorWindow.visible = false
                    }
                }


                Item{
                    Layout.fillWidth: true
                }


                PanButton{
                    Layout.alignment: Qt.AlignVCenter
                    icon: PanAwesomeIcons.fa_comment_dots
                    iconFontName: PanFonts.awesomeSolid.name
                    iconColor: "red" // PanStyles.color_primary
                    iconSize: 24
                    backgroundVisible: false
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
                            logWindow.moveToTopLevel()
                        }
                    }
                }

            }
        }



    }

    Component.onCompleted: {

        // PanApplication.desktop = desktop
        PanApplication.windowContainer = container

        createLoginWindow()
    }

    function createLoginWindow(){
        const loginWin = Qt.createQmlObject(`
                                            PanLoginWindow{
                                            x: (parent.width-width)*0.5
                                            y: Math.max(100 , (parent.height - height)*0.5-100)
                                            width: Math.max(400,parent.width*0.25)
                                            modal: true
                                            }
                                            `,
                                            PanApplication.windowContainer,
                                            "loginWin"
                                            );

        loginWin.open();
        loginWin.cancel.connect(()=>{
                                    loginWin.destroy()
                                })

    }

    function createCatalogWindow(){

        if(PanApplication.catalogWindow === null){
            const catalogWindow = Qt.createQmlObject(`
                                                     PanCatalogWindow{
                                                     x: Math.random() * (parent.width-width)
                                                     y: Math.random() * (parent.height-height)  //Math.max(100 , (parent.height - height)*0.5-100)
                                                     width: Math.max(400,parent.width*0.8)
                                                     height: Math.max(400,parent.height*0.8)
                                                     }
                                                     `,
                                                     PanApplication.windowContainer,
                                                     "catalogWindow"
                                                     );
            PanApplication.catalogWindow = catalogWindow;
        }
        PanApplication.catalogWindow.moveToTopLevel()
    }


    function createMapEditorWindow(){
        if(PanApplication.mapEditorWindow === null){
            const mapEditorWindow = Qt.createQmlObject(`
                                                       PanMapEditorWindow{
                                                       x: Math.random() * (parent.width-width)
                                                       y: Math.random() * (parent.height-height)  //Math.max(100 , (parent.height - height)*0.5-100)
                                                       width: Math.max(400,parent.width*0.8)
                                                       height: Math.max(400,parent.height*0.8)
                                                       }
                                                       `,
                                                       PanApplication.windowContainer,
                                                       "mapEditorWindow"
                                                       );

            PanApplication.mapEditorWindow = mapEditorWindow;
        }
        PanApplication.mapEditorWindow.moveToTopLevel()
    }

    function createSymbolEditorWindow(){
        if(PanApplication.symbolEditorWindow === null){
            const symbolEditorWindow = Qt.createQmlObject(`
                                                          PanSymbolEditorWindow{
                                                          x: Math.random() * (parent.width-width)
                                                          y: Math.random() * (parent.height-height)  //Math.max(100 , (parent.height - height)*0.5-100)
                                                          width: Math.max(400,parent.width*0.8)
                                                          height: Math.max(400,parent.height*0.8)
                                                          }
                                                          `,
                                                          PanApplication.windowContainer,
                                                          "symbolEditorWindow"
                                                          );

            PanApplication.symbolEditorWindow = symbolEditorWindow;
        }
        PanApplication.symbolEditorWindow.moveToTopLevel()
    }
}
