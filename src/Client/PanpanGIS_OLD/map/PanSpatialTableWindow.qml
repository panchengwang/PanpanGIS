import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import cn.pc.gis.control
import cn.pc.gis.map
import "PanConnector.js" as PanConnector

PanFormWindow{
    id: window
    caption: qsTr("表结构定义")
    standardButtonsVisible: true
    cancelButtonVisible: false
    windowButtonsVisible: true
    minimizeButtonVisible: false
    maximizeButtonVisible: false
    movable: true
    width: 400
    height: 330


    RowLayout{
        PanLabel{
            text: qsTr("数据表名")
        }
        PanTextField{
            Layout.fillWidth: true
        }
    }

    RowLayout{


        PanButton{
            icon:PanAwesomeIcons.fa_plus
            text:"添加字段"
        }

        PanButton{
            icon:PanAwesomeIcons.fa_plus
            text:"删除字段"
        }

        Item{
            Layout.fillWidth: true
        }

        PanCheckBox{
            text: qsTr("是否为空间数据表")
        }

    }

    PanTableView{
        Layout.fillWidth: true
        // horizontalHeaderDelegate:  Rectangle{
        //     color: "red"
        //     anchors.fill: parent
        //     implicitHeight: PanStyles.button_implicit_height
        //     PanLabel{
        //         anchors.fill: parent
        //         verticalAlignment: Qt.AlignVCenter
        //         text: display + "  " +  column
        //     }

        // }
    }

    // Rectangle{
    //     id: rectTable
    //     Layout.fillHeight: true
    //     Layout.fillWidth: true
    //     implicitHeight: 150
    //     border.width: 1
    //     border.color: "black"
    //     clip: true

    //     HorizontalHeaderView {
    //         id: horizontalHeader
    //         anchors.top: parent.top
    //         anchors.topMargin: PanStyles.default_padding
    //         anchors.right: tableView.right
    //         x:  PanStyles.default_padding
    //         syncView: tableView
    //         clip: true
    //         delegate: PanButton{
    //             text: display
    //             icon: ''
    //             radius: 0
    //         }
    //     }

    //     PanSpatialTableTableView{
    //         id: tableView
    //         anchors.top:horizontalHeader.bottom
    //         x: PanStyles.default_padding
    //         y: PanStyles.default_padding
    //         width: parent.width - 2* PanStyles.default_padding
    //         height: parent.height - 2 * PanStyles.default_padding
    //     }



    // }






}
