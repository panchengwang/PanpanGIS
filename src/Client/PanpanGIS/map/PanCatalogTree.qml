import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import cn.pc.gis.control

TreeView {
    id: treeView
    clip: true
    columnWidthProvider: function(column) {
        return Math.max(explicitColumnWidth(column), implicitColumnWidth(column), treeView.width)
    }

    delegate:   Item {
        implicitWidth: padding + label.x + label.implicitWidth + padding
        implicitHeight: PanStyles.button_implicit_height * 1.25

        readonly property real indentation: 20
        readonly property real padding: 5

        // Assigned to by TreeView:
        required property TreeView treeView
        required property bool isTreeNode
        required property bool expanded
        required property int hasChildren
        required property int depth
        required property int row
        required property int column
        required property bool current

        Rectangle{
            id: background
            anchors.fill: parent
            color: bkMouseArea.hovered ? PanStyles.color_primary : (row % 2 === 0 ? PanStyles.color_white : "#EEEEEE")

            MouseArea{
                id: bkMouseArea
                property bool hovered: false
                anchors.fill: parent
                hoverEnabled: true
                preventStealing: true
                onEntered:  {
                               hovered = true

                           }
                onExited: {
                              hovered = false

                          }
            }
        }

        PanLabel {
            id: indicator
            x: padding + (depth * indentation)
            width: 16
            horizontalAlignment: Text.AlignHCenter
            anchors.verticalCenter: parent.verticalCenter
            visible: isTreeNode && hasChildren
            font.family: PanFonts.awesomeSolid.name

            text: model.data.dataset_type === "folder" ? (!expanded ? PanAwesomeIcons.fa_angle_right : PanAwesomeIcons.fa_angle_down )
                                                       : ""

            MouseArea{
                anchors.fill: parent
                onClicked: (event) => {
                               if(expanded){
                                   treeView.collapse(row)
                               }else{
                                   treeView.expand(row)
                               }
                           }
            }
        }

        PanLabel {
            id: iconLabel
            x: indicator.x + indicator.width
            width: 24
            horizontalAlignment: Text.AlignHCenter
            anchors.verticalCenter: parent.verticalCenter
            visible: isTreeNode && hasChildren
            font.family: PanFonts.awesomeSolid.name
            text: !expanded ? PanAwesomeIcons.fa_folder : PanAwesomeIcons.fa_folder_open

            MouseArea{
                anchors.fill: parent
                onClicked: (event) => {
                               if(expanded){
                                   treeView.collapse(row)
                               }else{
                                   treeView.expand(row)
                               }
                           }
            }
        }

        PanLabel {
            id: label
            x: iconLabel.x + iconLabel.width // padding + (isTreeNode ? (depth + 1) * indentation : 0)
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width - padding - x
            clip: true
            text: model.data.name
        }
    }

    function getIcon(type, expanded){
        if ( type === "folder"){
            return expaned ? PanAwesomeIcons.fa_angle_down : PanAwesomeIcons.fa_angle_right;
        }else{
            return "";
        }
    }
}
