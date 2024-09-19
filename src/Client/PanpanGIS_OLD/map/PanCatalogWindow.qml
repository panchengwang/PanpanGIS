import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import cn.pc.gis.control
import cn.pc.gis.map
import "PanConnector.js" as PanConnector

PanWindow {
    id: window

    standardButtonsVisible: false
    caption: "空间数据管理"

    SplitView{
        id: split
        anchors.fill: parent

        ColumnLayout{
            height: parent.height
            SplitView.preferredWidth: Math.max(200,split.width * 0.3)
            spacing: 0
            Rectangle{
                implicitHeight: row.height + PanStyles.default_padding
                implicitWidth: parent.width
                color:  PanStyles.color_light_grey
                RowLayout{
                    id: row
                    width: parent.width - 2 * PanStyles.default_margin
                    anchors.centerIn: parent

                    PanLabel{
                        text:""
                        Layout.fillWidth: true
                    }
                    PanButton{
                        icon:  PanAwesomeIcons.fa_folder_plus
                        iconSize: 18
                        dense: true
                        backgroundVisible: false
                        onClicked: {
                            catalogTree.createFolder()
                        }
                    }
                    PanButton{
                        icon: PanGisIcons.fg_layer_2_add_o
                        iconSize: 18
                        iconFontName: PanFonts.gis.name
                        backgroundVisible: false
                    }
                    PanButton{
                        icon: PanGisIcons.fg_layer_upload
                        iconSize: 18
                        iconFontName: PanFonts.gis.name
                        backgroundVisible: false
                    }
                }
            }
            PanCatalogTree{
                id: catalogTree
                Layout.fillHeight: true
                Layout.fillWidth: true
            }

        }



        Rectangle{

            PanButton{
                x: 50
                y: 50
                text: "刷新"
                onClicked: {
                    catalogTree.refresh()
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
                }
            }
        }
    }
}
