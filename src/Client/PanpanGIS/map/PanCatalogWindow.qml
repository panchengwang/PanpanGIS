import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import cn.pc.gis.control

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
                data: JSON.parse(`{

                                 }`)
            }
            PanButton{
                x: 50
                y: 50
                text: "刷新"
                onClicked: {
                    catalogModel.data = JSON.parse(`{
                                                       "id": "1",
                                                       "dataset_type": 0,
                                                       "name": "abc",
                                                       "parent_id": "0",
                                                       "children":[{
                                                           "id": 2,
                                                           "dataset_type": 1,
                                                           "name": "layer${Math.random()}",
                                                           "parent_id": "1"
                                                        },{
                                                           "id": 3,
                                                           "dataset_type": 0,
                                                           "name": "layer3",
                                                           "parent_id": "1",
                                                           "children":[{
                                                               "id": 4,
                                                               "dataset_type": 1,
                                                               "name": "layer${Math.random()}",
                                                               "parent_id": 3
                                                           }]
                                                       }]
                                                   }`)
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
                    catalogModel.displayRole = "id"
                }
            }
        }
    }
}
