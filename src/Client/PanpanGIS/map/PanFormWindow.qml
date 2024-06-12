import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import cn.pc.gis.control

PanWindow {

    default property  alias form:  grid.children


    content: Flickable{
        anchors.fill: parent
        contentHeight: contentItem.childrenRect.height
        clip: true
        leftMargin: PanStyles.default_margin
        rightMargin: PanStyles.default_margin
        topMargin: PanStyles.default_margin
        bottomMargin: PanStyles.default_margin

        GridLayout {
            id: grid
            columns: 1
            width: parent.width
        }
    }


}
