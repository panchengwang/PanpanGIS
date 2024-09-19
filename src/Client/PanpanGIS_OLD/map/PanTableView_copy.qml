import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import cn.pc.gis.control
import cn.pc.gis.map

Control {
    id: control
    implicitWidth: 400
    implicitHeight: 300

    background: Rectangle{
        border.width: 1
        border.color: PanStyles.color_grey
    }

    contentItem: Rectangle{
        anchors.fill: parent
        anchors.margins: 1
        clip: true
        radius: PanStyles.default_radius

        Rectangle{
            x: 0
            y: 0
            width: parent.width
            height: horizontalHeader.height
            color: PanStyles.color_light_grey
        }

        ColumnLayout{

            anchors.fill: parent
            spacing: 0
            HorizontalHeaderView {
                id: horizontalHeader
                syncView: tableView


                delegate:  PanButton{
                    required property int column
                    text: display
                    icon: ''

                    radius: 0
                }
                Layout.fillWidth: true
            }

            TableView{
                id: tableView
                Layout.fillWidth: true
                Layout.fillHeight: true
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
                columnWidthProvider: function(column) {

                    let w = explicitColumnWidth(column);
                    if (w < 0){
                        w = implicitColumnWidth(column);
                    }
                    // 最后一列占据所有的列空间
                    if (column === model.columns.length-1){
                        let mywidth = 0;
                        for(let i=0; i<model.columns.length-1; i++){
                            let w2 = explicitColumnWidth(column);
                            if (w2 < 0){
                                w2 = implicitColumnWidth(column);
                            }
                            mywidth += w2;
                        }

                        w = Math.max(implicitColumnWidth(column),tableView.width - (verticalScrollBar.visible ? verticalScrollBar.width : 0)  - mywidth)
                    }

                    return w;
                }
                delegate: Rectangle{
                    required property int row
                    required property int column
                    required property bool selected

                    implicitHeight: PanStyles.button_implicit_height + PanStyles.default_padding
                    implicitWidth: 100


                    PanLabel {
                        id: label
                        anchors.left: parent.left
                        anchors.top: parent.top
                        // anchors.margins: PanStyles.default_margin
                        verticalAlignment: Qt.AlignVCenter
                        height: parent.height - 1
                        width: parent.width -1
                        text: display
                        z: 0
                    }
                    Rectangle{
                        anchors.left: label.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: 1
                        color: PanStyles.color_grey
                    }
                    Rectangle{
                        anchors.left: parent.left
                        anchors.top: label.bottom

                        anchors.right: parent.right
                        height: 1
                        color: PanStyles.color_grey
                    }


                    Component{
                        id: fieldNameEdit

                        PanTextField {
                            anchors.fill: parent
                            anchors.margins: 1
                            anchors.rightMargin: 2
                            anchors.bottomMargin: 2



                            text: display
                            TableView.onCommit: {
                                // display = text
                            }
                            Component.onCompleted: {
                                focus = true
                            }
                        }
                    }

                    Component{
                        id: fieldTypeEdit

                        PanTextField {
                            anchors.fill: parent
                            text: row
                            TableView.onCommit: {
                                // display = text
                            }
                            Component.onCompleted: {
                                console.log("field type edit complete")
                            }
                        }
                    }

                    TableView.editDelegate: Loader{
                        anchors.fill: parent
                        sourceComponent:{
                            if(tableView.model.columns[column].label === 'type'){
                                return fieldTypeEdit;
                            }

                            return fieldNameEdit
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

                }


                selectionModel: ItemSelectionModel{}

                editTriggers: TableView.SelectedTapped

            }




            PanTableModel{
                id: model
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
        }

    }
}
