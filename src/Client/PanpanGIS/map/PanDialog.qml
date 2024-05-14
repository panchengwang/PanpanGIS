import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import cn.pc.gis.control

Popup {
    id: dialog
    implicitWidth: 400
    implicitHeight: 300
    modal: true
    focus: true

    padding: 0
    closePolicy: Popup.CloseOnEscape

    background: Rectangle{
        anchors.fill: parent
        radius: PanStyles.default_radius
        color: "#FFFFFE"
    }



    ColumnLayout{
        anchors.fill: parent
        spacing: 0
        Rectangle{
            implicitHeight: PanStyles.header_implicit_height
            Layout.fillWidth: true
            color:  PanStyles.color_dialog_caption_background_activate
            radius: 2
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    dialog.focus = true
                }
            }
        }

        Rectangle{
            Layout.fillWidth: true
            Layout.fillHeight: true
            // border.color: "#E6E2F2"
            // border.width: 1
            Flickable{
                anchors.fill: parent

            }

        }


        Rectangle{
            implicitHeight: PanStyles.header_implicit_height
            Layout.fillWidth: true
            color: "#E6E2F2"
            radius: 2
            RowLayout{
                anchors.fill: parent

                Item{
                    Layout.fillWidth: true
                }
                PanButton{
                    implicitWidth: 80
                    text: "取消"
                }


                PanButton{
                    implicitWidth: 80
                    text: "确定"
                    Layout.rightMargin: 5
                }


            }
        }
    }

    PanBorder{
        position: "left"
    }
    PanBorder{
        position: "right"
    }
    PanBorder{
        position: "top"
    }
    PanBorder{
        position: "bottom"
    }
    PanBorder{
        position: "left_top"
    }
    PanBorder{
        position: "right_top"
    }
    PanBorder{
        position: "left_bottom"
    }
    PanBorder{
        position: "right_bottom"
    }
}
