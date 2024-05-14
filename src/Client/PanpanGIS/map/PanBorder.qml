import QtQuick
import cn.pc.gis.control

Rectangle {

    opacity: 0.5

    property string position: "right"
    property int borderWidth: 4
color: "red"
    x: position === "left" ? 0:
                             position === "right" ? parent.width - borderWidth :
                                                    position === "top" || position === "bottom" ? borderWidth :
                                                                                                  position === "left_top" || position === "left_bottom"  ? 0 :
                                                                                                                                                           parent.width - 2 * borderWidth


    y: position === "top" ? 0 :
                            position === "bottom" ? parent.height - borderWidth :
                                                    position === "left" || position === "right" ? borderWidth :
                                                                                                  position === "left_top" || position === "right_top" ? 0 :
                                                                                                                                                        parent.height - 2 * borderWidth
    height: position === "top" || position === "bottom" ? borderWidth :
                                                          position === "left" || position === "right" ? parent.height - 2* borderWidth :
                                                                                                        2* borderWidth
    width:  position === "left" || position === "right" ? borderWidth :
                                                          position === "top" || position === "bottom" ? parent.width - 2 * borderWidth :
                                                                                                        2 * borderWidth
    radius: position === "left" || position == "right" || position === "top" || position === "bottom" ? 0 : borderWidth

    MouseArea{
        anchors.fill: parent
        cursorShape:  position === "top" || position === "bottom" ? Qt.SizeVerCursor :
                                                                    position === "right" || position === "left" ? Qt.SizeHorCursor :
                                                                                                                  position === "left_top" || position === "right_bottom" ? Qt.SizeFDiagCursor : Qt.SizeBDiagCursor
        drag{
            target: parent
            axis: position === "left" || position === "right" ? Drag.XAxis :
                                                                position === "top" || position === "bottom" ? Drag.YAxis : Drag.XandYAxis
        }
    }


}
