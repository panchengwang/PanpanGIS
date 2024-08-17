import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import cn.pc.gis.control
import cn.pc.gis.map

Rectangle{
    id: control
    implicitHeight: 250
    implicitWidth: 400
    clip: true
    border.width: 1
    border.color: PanStyles.color_grey


    property bool horizontalHeaderVisible: true

    property Component horizontalHeaderDelegate: Rectangle{
        implicitHeight: PanStyles.button_implicit_height + PanStyles.default_padding*2.0
        color: PanStyles.color_light_grey
        RowLayout{
            anchors.fill: parent
            spacing:  0
            PanButton{
                // required property int column
                text: display
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.leftMargin: 2
                Layout.rightMargin: 2
                radius: 0
                icon: ''
            }

            Rectangle{
                border.color: PanStyles.color_grey
                Layout.fillHeight: true
                width: 1
                border.width: 1
            }
        }

        Component.onCompleted: {
            console.log("height: ", height)
        }
    }


    property Component defaultCellDelegate: Rectangle{
        required property int row
        required property int column
        required property bool selected

        implicitHeight: PanStyles.button_implicit_height + PanStyles.default_padding*2.0
        implicitWidth: 100

        Item{
            anchors.fill: parent
            anchors.margins: PanStyles.default_margin*0.5
            clip: true
            // anchors.left: parent.left
            // anchors.top: parent.top
            // height: parent.height - 1
            // width: parent.width -1
            PanLabel {
                id: label
                verticalAlignment: Qt.AlignVCenter
                text: display
            }
        }
        Rectangle{
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: 1
            color: PanStyles.color_grey
        }
        Rectangle{
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            height: 1
            color: PanStyles.color_grey
        }
    }



    Rectangle{
        id: horizontalHeader
        anchors.top: parent.top
        anchors.left: parent.left
        height: control.horizontalHeaderVisible ?  PanStyles.button_implicit_height + PanStyles.default_padding * 2: 0
        anchors.right: parent.right
        anchors.margins: 1
        color: PanStyles.color_light_grey
        clip: true

        HorizontalHeaderView {
            syncView: tableView
            visible: control.horizontalHeaderVisible
            delegate: control.horizontalHeaderDelegate
        }
    }



    TableView{
        id: tableView
        anchors.top: horizontalHeader.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 1
        clip: true
        ScrollBar.horizontal: ScrollBar {
            id: horizontalScrollBar
            policy: ScrollBar.AsNeeded

        }
        ScrollBar.vertical:  ScrollBar {
            id: verticalScrollBar
            policy: ScrollBar.AsNeeded
        }
        model: model
        // columnWidthProvider: function(column) {

        //     let w = explicitColumnWidth(column);
        //     if (w < 0){
        //         w = implicitColumnWidth(column);
        //     }
        //     // // 最后一列占据所有的列空间
        //     // if (column === model.columns.length-1){
        //     //     let mywidth = 0;
        //     //     for(let i=0; i<model.columns.length-1; i++){
        //     //         let w2 = explicitColumnWidth(column);
        //     //         if (w2 < 0){
        //     //             w2 = implicitColumnWidth(column);
        //     //         }
        //     //         mywidth += w2;
        //     //     }

        //     //     w = Math.max(implicitColumnWidth(column),tableView.width - (verticalScrollBar.visible ? verticalScrollBar.width : 0)  - mywidth)
        //     // }

        //     return w;
        // }
        delegate: defaultCellDelegate


        selectionModel: ItemSelectionModel{}

        editTriggers: TableView.SelectedTapped

    }




    PanTableModel{
        id: model
        columns:[{
                id:"name", label:"字段名"
            },{
                id:"type", label:"类型"
            },{
                id: "length", label: "长度"
            }]
        rows:[
            { name: "id", type: "integer" },
            { name: "_geo", type: "Point" },
            { name: "name", type: "varchar", length: 32 }
            ,
            { name: "_geo", type: "Point" },
            { name: "name", type: "varchar", length: 32 }
            ,
            { name: "_geo", type: "Point" },
            { name: "name", type: "varchar", length: 32 }
            ,
            { name: "_geo", type: "Point" },
            { name: "name", type: "varchar", length: 32 }
            ,
            { name: "_geo", type: "Point" },
            { name: "name", type: "varchar", length: 32 }
            ,
            { name: "_geo", type: "Point" },
            { name: "name", type: "varchar", length: 32 }
            ,
            { name: "_geo", type: "Point" },
            { name: "name", type: "varchar", length: 32 }
        ]
    }
}

