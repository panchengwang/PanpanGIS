import QtQuick
import cn.pc.gis.control

Rectangle {

    property string position: "right"

    MouseArea{
        anchors.fill: parent
        cursorShape:  position === "top" || position === "bottom" ?
                          Qt.SizeVerCursor :
                          (position === "right" || position === "left" ?
                               Qt.SizeHorCursor : Qt.ArrowCursor)
    }


}
