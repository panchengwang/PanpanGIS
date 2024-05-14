import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import cn.pc.gis.control
// import QtQuick.Effects

// Frame{
//     id: loginPanel
//     clip: true
//     background:Rectangle{
//         anchors.fill: parent
//         color: "red" //PanStyles.color_panel_background
//         radius: PanStyles.default_radius
//     }

//     Rectangle{
//         id: panel
//         // anchors.fill: parent
//         anchors.margins: PanStyles.default_margin
//         radius: PanStyles.default_radius

//         ColumnLayout{
//             spacing: PanStyles.default_spacing
//             // anchors.fill: parent
//             anchors.margins:  PanStyles.default_margin
//             PanLabel{
//                 text: "欢迎来到PanpanGIS世界"
//                 horizontalAlignment:  Text.AlignHCenter
//                 Layout.fillWidth: true
//                 font.pointSize: PanStyles.header_text_font_size
//             }

//             Rectangle{
//                 Layout.fillWidth: true
//                 height: 1
//                 color: PanStyles.color_light_grey
//             }

//             PanLabel{
//                 anchors.topMargin: 10
//                 text: "邮箱地址"
//                 horizontalAlignment:  Text.AlignLeft
//                 Layout.fillWidth: true
//             }
//             PanTextField{
//                 id: username
//                 type: "email"
//                 Layout.fillWidth: true
//                 placeholderText: "请输入电子信箱地址"
//             }
//             PanLabel{
//                 anchors.topMargin: 10
//                 text: "密码"
//                 horizontalAlignment:  Text.AlignLeft
//                 Layout.fillWidth: true
//             }
//             PanTextField{
//                 id: password
//                 type: "password"
//                 Layout.fillWidth: true
//                 placeholderText: "请输入密码"
//             }

//             PanLabel{
//                 text: "验证码"
//             }
//             PanIdentifyCode{
//                 Layout.fillWidth: true
//             }

//             Rectangle{
//                 Layout.fillWidth: true
//                 height: 1
//                 color: PanStyles.color_light_grey
//             }

//             PanButton{
//                 Layout.fillWidth: true
//                 text:"登  录"
//             }

//             RowLayout{
//                 Item{
//                     Layout.fillWidth: true
//                 }

//                 PanLabel{
//                     text:"没有账户？"
//                 }
//                 PanLabel{
//                     text: "请单击此处创建"
//                     color: mouse.containsMouse ?  PanStyles.color_primary : PanStyles.color_text
//                     MouseArea{
//                         id: mouse
//                         anchors.fill: parent
//                         hoverEnabled: true
//                         onPressed: {
//                             createAccount();
//                         }
//                     }
//                 }
//             }

//             Item{
//                 Layout.fillHeight: true
//             }
//         }
//     }
//     function createAccount(){
//         const createAccountPanel = Qt.createQmlObject(`
//             import QtQuick
//             import cn.pc.gis.control
//             import cn.pc.gis.map
//             PanAccountCreatePanel{
//                 anchors.horizontalCenter: parent.horizontalCenter
//                 y: Math.max(50 , (parent.height - height)*0.5-50)
//                 width: Math.max(400,parent.width*0.67)
//             }
//             `,
//             appWin,
//             "createAccountPanel"
//         );
//         loginPanel.visible = false
//     }

// }

Rectangle {
    id: loginPanel

    width: 400
    height: panel.height + 2*PanStyles.default_margin

    color: PanStyles.color_panel_background
    radius: PanStyles.default_radius

    Rectangle{
        id: panel

        anchors.margins: PanStyles.default_margin
        anchors.centerIn: parent
        width: parent.width - 2 * PanStyles.default_margin
        radius: PanStyles.default_radius
        height: column.implicitHeight + 2* PanStyles.default_margin

        ColumnLayout{
            id: column
            spacing: PanStyles.default_spacing
            anchors.fill: parent
            anchors.margins:  PanStyles.default_margin
            PanLabel{
                text: "欢迎来到PanpanGIS世界"
                horizontalAlignment:  Text.AlignHCenter
                Layout.fillWidth: true
                font.pointSize: PanStyles.header_text_font_size
            }

            Rectangle{
                Layout.fillWidth: true
                height: 1
                color: PanStyles.color_light_grey
            }

            PanLabel{
                anchors.topMargin: 10
                text: "邮箱地址"
                horizontalAlignment:  Text.AlignLeft
                Layout.fillWidth: true
            }
            PanTextField{
                id: username
                type: "email"
                Layout.fillWidth: true
                placeholderText: "请输入电子信箱地址"
            }
            PanLabel{
                anchors.topMargin: 10
                text: "密码"
                horizontalAlignment:  Text.AlignLeft
                Layout.fillWidth: true
            }
            PanTextField{
                id: password
                type: "password"
                Layout.fillWidth: true
                placeholderText: "请输入密码"
            }

            PanLabel{
                text: "验证码"
            }
            PanIdentifyCode{
                Layout.fillWidth: true
            }

            Rectangle{
                Layout.fillWidth: true
                height: 1
                color: PanStyles.color_light_grey
            }

            PanButton{
                Layout.fillWidth: true
                text:"登  录"
            }

            RowLayout{
                Item{
                    Layout.fillWidth: true
                }

                PanLabel{
                    text:"没有账户？"
                }
                PanLabel{
                    text: "请单击此处创建"
                    color: mouse.containsMouse ?  PanStyles.color_primary : PanStyles.color_text
                    MouseArea{
                        id: mouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onPressed: {
                            createAccount();
                        }
                    }
                }
            }

            Item{
                Layout.fillHeight: true
            }
        }

    }


    function createAccount(){
        const createAccountPanel = Qt.createQmlObject(`
            import QtQuick
            import cn.pc.gis.control
            import cn.pc.gis.map
            PanAccountCreatePanel{
                anchors.horizontalCenter: parent.horizontalCenter
                y: Math.max(50 , (parent.height - height)*0.5-50)
                width: Math.max(400,parent.width*0.5)
            }
            `,
            appWin,
            "createAccountPanel"
        );
        loginPanel.visible = false
        createAccountPanel.cancel.connect(()=>{
                                              createAccountPanel.destroy()
                                              loginPanel.visible = true
                                          })

    }

    // MultiEffect{
    //     source: panel
    //     anchors.fill: panel
    //     shadowEnabled: true
    //     paddingRect: Qt.rect(0,0,40,50)
    // }
}
