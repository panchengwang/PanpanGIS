import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import cn.pc.gis.control

PanWindow {
    id: window
    caption: "提示信息"


    standardButtonsVisible: false
    closeButtonVisible: true
    minimizeButtonVisible: false
    maximizeButtonVisible: false

    property ListModel logModel : ListModel{}
    property int maxLogCount: 20

    ListView{
        id: listView
        anchors.fill: parent
        anchors.margins: PanStyles.default_margin
        clip: true
        model: logModel

        spacing: PanStyles.default_spacing
        delegate: Rectangle{
            radius: PanStyles.default_radius
            width: listView.width
            implicitHeight: PanStyles.button_implicit_height // + 2 * PanStyles.default_margin
            border.width: 1
            border.color: PanStyles.color_button_border

            RowLayout{
                anchors.fill: parent
                anchors.margins: PanStyles.default_margin
                spacing: PanStyles.default_spacing
                PanLabel{
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    text: level === "warning" ? PanAwesomeIcons.fa_exclamation_triangle : (
                                                    level === "information" ? PanAwesomeIcons.fa_info_circle : (
                                                                                  level === "fatal" ? PanAwesomeIcons.fa_skull_crossbones : PanAwesomeIcons.fa_info_circle
                                                                                  )
                                                    )
                    font.family: PanFonts.awesomeSolid.name
                }

                PanLabel{
                    text: log
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                }
            }
        }
    }

    // ScrollView{
    //     id: flick
    //     anchors.fill: parent
    //     contentHeight: textArea.contentHeight
    //     anchors.margins: PanStyles.default_margin
    //     clip: true
    //     TextEdit{
    //         id: textArea
    //         width: flick.width
    //         wrapMode: TextEdit.WordWrap
    //         font.family: PanFonts.notoSansSimpleChineseRegular.name
    //         font.pixelSize: PanStyles.default_font_size
    //         text: ""
    //     }

    // }

    function appendLog(log, level){
        if(logModel.count >= maxLogCount){
            logModel.remove( 0,1)
        }

        logModel.append({
                            log: log,
                            level: level
                            })
        listView.positionViewAtEnd();
    }


}
