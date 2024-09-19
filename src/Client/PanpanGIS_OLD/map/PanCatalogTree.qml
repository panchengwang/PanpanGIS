import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import cn.pc.gis.control
import cn.pc.gis.map

TreeView {
    id: treeView
    clip: true

    property var currentIndex: treeView.rootIndex

    model: PanJsonModel{
        id: catalogModel

        Component.onCompleted: {
            treeView.refresh()
        }

    }

    columnWidthProvider: function(column) {
        return Math.max(explicitColumnWidth(column), implicitColumnWidth(column), treeView.width)
    }

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
                acceptedButtons:  Qt.RightButton  //| Qt.LeftButton
                onClicked: (mouse)=>{
                               let index = treeView.index(row,column);
                               treeView.currentIndex = index;

                               if(mouse.button !== Qt.RightButton){
                                   return;
                               }

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
        Action{
            text: qsTr("刷新")
            onTriggered: {
                treeView.refresh(menuFolder.index);
            }
        }

        MenuSeparator{}

        Action {
            text: qsTr("新建子目录");
            onTriggered: {
                treeView.createFolder(menuFolder.index);
            }
        }
        Action{
            text: qsTr("新建数据表");
            onTriggered: {
                treeView.createTable(menuFolder.index);
            }
        }

        Action {
            text: qsTr("删除");
            onTriggered: {

                treeView.removeFolder(menuFolder.index);
            }
        }

        MenuSeparator{}

        Action {
            text: qsTr("属性");
            onTriggered: {
                console.log(JSON.stringify(treeView.model.attributes(menuFolder.index)))
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



    function refresh(index){
        let id = '0';
        if(index){
            let attributes = treeView.model.attributes(index);
            id = attributes.id;
        }

        PanConnector.post(PanApplication.nodeUrl,
                          {
                              "type": "CATALOG_GET_DATASET_TREE",
                              "data": {
                                  "token": PanApplication.token,
                                  "id": id
                              }
                          },window,true,
                          (data)=>{
                              if(id=='0'){
                                  treeView.model.data = data.catalog;
                                  return;
                              }
                              if(data.catalog.children && data.catalog.children.length >0){
                                  treeView.model.setChildren(data.catalog.children, index);
                                  treeView. expandRecursively(treeView.rowAtIndex(index));
                              }

                          },(data)=>{});
    }

    function createFolder(index){
        if(!index){
            index = rootIndex;
        }

        let inputwin = Qt.createQmlObject(`
                                          PanInputWindow{
                                          modal: true
                                          }
                                          `,
                                          PanApplication.windowContainer,"inputwin")
        inputwin.show()
        inputwin.toCenter()
        inputwin.accepted.connect((data)=>{

                                      PanConnector.post(PanApplication.nodeUrl,
                                                        {
                                                            type: "CATALOG_CREATE_FOLDER",
                                                            data:{
                                                                token: PanApplication.token,
                                                                folder: data.trim(),
                                                                parent_id: index === treeView.rootIndex ? "0": treeView.model.attributes(index).id
                                                            }
                                                        },
                                                        window,
                                                        true,
                                                        (res)=>{
                                                            treeView.model.insertChild(index,res,0);
                                                            treeView.expand(treeView.rowAtIndex(index));
                                                            inputwin.destroy()
                                                        })
                                  })
        inputwin.cancel.connect(()=>{
                                    inputwin.destroy()
                                })
    }

    function removeFolder(index){
        let attributes = treeView.model.attributes(index);
        PanConnector.post(PanApplication.nodeUrl,
                          {
                              type: "CATALOG_REMOVE",
                              data:{
                                  token: PanApplication.token,
                                  id: attributes.id
                              }
                          },
                          PanApplication.windowContainer,
                          true,
                          (res)=>{
                              treeView.currentIndex = index.parent;
                              treeView.model.removeRow(index.row,index.parent);
                          },()=>{
                              treeView.currentIndex = treeView.rootIndex;
                          });
    }

    function createTable(index){
        if(!index){
            index = rootIndex;
        }

        let tablewin = Qt.createQmlObject(`
                                          PanTableWindow{
                                          modal: true
                                          }
                                          `,
                                          PanApplication.windowContainer,"tablewin")
        tablewin.show()
        tablewin.toCenter()

        // let attributes = treeView.model.attributes(index);
    }
}
