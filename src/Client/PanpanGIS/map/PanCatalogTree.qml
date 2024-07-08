import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import cn.pc.gis.control

TreeView {
    id: treeView
    clip: true

    property var currentIndex: null

    columnWidthProvider: function(column) {
        return Math.max(explicitColumnWidth(column), implicitColumnWidth(column), treeView.width)
    }

    // MouseArea{
    //     anchors.fill: parent
    //     acceptedButtons:  Qt.RightButton
    //     onClicked: (mouse)=>{
    //                    menu.popup()
    //                }

    // }

    delegate:   Control {
        id: control
        implicitWidth: padding + label.x + label.implicitWidth + padding
        implicitHeight: PanStyles.button_implicit_height * 1.25
        padding: PanStyles.default_padding
        readonly property real indentation: 20
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
            color: control.hovered ? "#8831ccec" : (row % 2 === 0 ? PanStyles.color_white : "#EEEEEE")
            MouseArea{
                anchors.fill: parent
                acceptedButtons:  Qt.RightButton
                onClicked: (mouse)=>{
                               let index = treeView.index(row,column);
                               let attributes = treeView.model.attributes(index)
                               let menu = null;
                               switch(attributes.dataset_type){
                                   case "folder":
                                   menu = menuFolder;
                                   break;
                                   case "point":
                                   menu = menuPointLayer;
                                   break;
                               }

                               if(!menu){
                                   return;
                               }

                               menu.index =  index;
                               menu.popup()

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
            color:  PanStyles.color_dark
            text: model.data.dataset_type === "folder" ? (!expanded ? PanAwesomeIcons.fa_angle_right : PanAwesomeIcons.fa_angle_down )
                                                       : ""

            MouseArea{
                anchors.fill: parent
                onClicked: {
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
            color: PanStyles.color_primary
            anchors.verticalCenter: parent.verticalCenter
            text: {
                let myicon = PanGisIcons.fg_layer_alt;
                switch (model.data.dataset_type) {
                case "folder":
                    myicon = !expanded ? PanAwesomeIcons.fa_folder : PanAwesomeIcons.fa_folder_open;
                    break;
                case "point":
                    myicon = PanGisIcons.fg_point;
                    break;
                case "linestring":
                    myicon = PanGisIcons.fg_polyline_pt;
                    break;
                case "polygon":
                    myicon = PanGisIcons.fg_polygon_hole_pt;
                    break;
                }
                return myicon;
            }

            font.family:   {
                let fontname = PanFonts.gis.name;
                switch (model.data.dataset_type) {
                case "folder":
                    fontname = PanFonts.awesomeRegular.name;
                    break;
                case "point":
                case "linestring":
                case "polygon":
                    fontname = PanFonts.gis.name;
                    break;
                }
                return fontname;
            }
        }


        PanLabel {
            id: label
            x: iconLabel.x + iconLabel.width // padding + (isTreeNode ? (depth + 1) * indentation : 0)
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width - padding - x
            clip: true
            text: model.display // model.data.name + "  " + model.data.parent_id
            color:  PanStyles.color_dark
        }



    }


    PanCatalogTreeMenu{
        id: menuFolder
        Action {
            text: qsTr("新建文件夹");
            onTriggered: {
                let attributes = treeView.model.attributes(menuFolder.index);
                treeView.model.insertChild(
                            menuFolder.index,
                            {
                                "dataset_type": "point",
                                "name": "new layer",
                                "parent_id": attributes.id,
                                "id": 8
                            },
                            0)
            }
        }
    }

    PanCatalogTreeMenu{
        id: menuPointLayer
        Action {
            text: qsTr("属性");
            onTriggered: {
                let attributes = treeView.model.attributes(menuPointLayer.index);
                console.log(JSON.stringify(attributes))
            }
        }
    }

    // Menu {
    //     id: menuFolder

    //     property var index: null

    //     padding: PanStyles.default_padding
    //     clip: true

    //     Action {
    //         text: qsTr("新建文件夹");
    //         enabled:{
    //             let index = treeView.index(menu.row, menu.col);
    //             let attributes = treeView.model.attributes(index);
    //             return attributes.dataset_type === "folder";
    //         }
    //         onTriggered: {
    //             let index = treeView.index(menu.row, menu.col);
    //             let attributes = treeView.model.attributes(index);
    //             treeView.model.insertChild(
    //                         index,
    //                         {
    //                             "dataset_type": "point",
    //                             "name": "new layer",
    //                             "parent_id": attributes.id,
    //                             "id": 8
    //                         },
    //                         0)
    //         }
    //     }


    //     delegate: MenuItem{
    //         id: menuItem
    //         implicitHeight: PanStyles.button_implicit_height + topPadding
    //         contentItem: Text {
    //             leftPadding: menuItem.indicator.width
    //             rightPadding: menuItem.arrow.width
    //             text: menuItem.text
    //             font.family: PanFonts.notoSansSimpleChineseRegular.name
    //             font.pixelSize: PanStyles.default_font_size
    //             opacity: enabled ? 1.0 : 0.3
    //             color: menuItem.highlighted ? PanStyles.color_white : PanStyles.color_dark
    //             horizontalAlignment: Text.AlignLeft
    //             verticalAlignment: Text.AlignVCenter
    //             elide: Text.ElideRight
    //         }
    //         background: Rectangle {
    //             anchors.fill: parent
    //             opacity: enabled ? 1 : 0.3
    //             color: menuItem.highlighted ? PanStyles.color_primary : "#EFEFEF"
    //         }
    //     }
    //     background: Rectangle {
    //         implicitWidth: 200
    //         implicitHeight: PanStyles.button_implicit_height
    //         color: "#ffffffff"
    //         border.color: PanStyles.color_grey
    //         radius: PanStyles.default_radius
    //     }
    // }



}
