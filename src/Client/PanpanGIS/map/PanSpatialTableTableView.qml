import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import cn.pc.gis.map
import cn.pc.gis.control

TableView{
    id: tableView
    clip: true


    model: PanTableModel{
        columns:[{
                label:"name", display:"字段名"
            },{
                label:"type", display:"类型"
            },{
                label: "length", display: "长度"
            }]
        rows:[
            { name: "id", type: "integer" },
            { name: "_geo", type: "Point" },
            { name: "name", type: "varchar", length: 32 }
        ]
    }

    columnWidthProvider: function(column) {
        let w = explicitColumnWidth(column)
        if (w >= 0)
            return w;
        return implicitColumnWidth(column)
    }

    delegate: Rectangle{
        required property int row
        required property int column
        required property bool selected

        // border.width: selected ? 0 : 1
        // border.color: "black"

        implicitHeight: PanStyles.button_implicit_height
        implicitWidth: 100


        PanLabel {
            id: label
            anchors.fill: parent
            text: display
            // color: selected ? PanStyles.color_white : PanStyles.color_primary
        }

        TableView.editDelegate: PanTextField {
            anchors.fill: parent
            // x: label.x
            // y: label.y
            // width: label.width
            // height: label.height
            text: display
            TableView.onCommit: {
                display = text
            }
        }
        TapHandler {
            id: tapHandler
            gesturePolicy: TapHandler.ReleaseWithinBounds
            onTapped: {
                tableView.selectionModel.clearSelection();
                // tableView.selectionModel.select(tableView.model.index(row, column),ItemSelectionModel.Select);
                tableView.edit(tableView.model.index(row, column))
            }
        }
        // MouseArea {
        //     anchors.fill: parent
        //     onClicked: {
        //         tableView.selectionModel.clearSelection();
        //         tableView.selectionModel.select(tableView.model.index(row, column),ItemSelectionModel.Select);

        //     }
        //     onDoubleClicked: {
        //         tableView.edit(tableView.model.index(row, column))
        //     }
        // }
    }


    selectionModel: ItemSelectionModel{}

    editTriggers: TableView.SelectedTapped
}
