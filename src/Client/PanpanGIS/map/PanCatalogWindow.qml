import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import cn.pc.gis.control
import cn.pc.gis.map
import "PanConnector.js" as PanConnector

PanWindow {
    id: window

    caption: "空间数据管理"
    standardButtonsVisible: false


    SplitView{
        id: split
        anchors.fill: parent
        PanCatalogTree{
            id: catalogTree
            SplitView.preferredWidth: Math.max(200,split.width * 0.3)
            model: catalogModel
        }

        Rectangle{
            PanJsonModel{
                id: catalogModel

                Component.onCompleted: {
                    refresh()
                }
                function refresh(){
                    PanConnector.post(PanApplication.nodeUrl,
                                     {
                                         "type": "CATALOG_GET_DATASET_TREE",
                                         "data": {
                                             "token": PanApplication.token
                                         }
                                     },window,true,
                                     (data)=>{
                                          console.log(JSON.stringify(data))
                                        catalogModel.data = data.catalog;

                                     },(data)=>{});
                }
            }
            PanButton{
                x: 50
                y: 50
                text: "刷新"
                onClicked: {
                    catalogModel.refresh()
                }
            }
            PanButton{
                x: 150
                y: 50
                text: "展开"
                onClicked: {
                    catalogTree.expandRecursively();
                }
            }
            PanButton{
                x: 250
                y: 50
                text: "切换display key"
                onClicked: {
                    catalogModel.displayRole = "[name]<[id]>"
                }
            }
        }
    }
}
