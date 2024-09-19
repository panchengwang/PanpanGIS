import QtQuick
import cn.pc.gis.control

Rectangle {
    id: border
    opacity: 0

    signal sizeChanged(int x,int y, int w,int h)

    property string position: "right"
    property int borderWidth: 6
    property int minParentSize: 30
    property QtObject target: null
    // color: "red"

    anchors.horizontalCenter: position === "top" || position === "bottom" ?
                                  parent.horizontalCenter :
                                  position.indexOf("left") >= 0 ?
                                      parent.left :
                                      position.indexOf("right") >= 0 ?
                                          parent.right : parent.horizontalCenter
    anchors.verticalCenter:  position === "left" || position === "right" ?
                                 parent.verticalCenter :
                                 position.indexOf("top") >= 0 ?
                                     parent.top :
                                     position.indexOf("bottom") >= 0 ?
                                         parent.bottom : parent.verticalCenter
     height: position === "top" || position === "bottom" ? borderWidth :
                                                          position === "left" || position === "right" ? parent.height - 2* borderWidth :
                                                                                                        2* borderWidth
    width:  position === "left" || position === "right" ? borderWidth :
                                                          position === "top" || position === "bottom" ? parent.width - 2 * borderWidth :
                                                                                                        2 * borderWidth
    radius: position === "left" || position == "right" || position === "top" || position === "bottom" ? 0 : borderWidth

    MouseArea{
        id: mouseArea
        anchors.fill: parent
        cursorShape:  position === "top" || position === "bottom" ? Qt.SizeVerCursor :
                                                                    position === "right" || position === "left" ? Qt.SizeHorCursor :
                                                                                                                  position === "left_top" || position === "right_bottom" ? Qt.SizeFDiagCursor : Qt.SizeBDiagCursor
        drag{
            target: parent
            axis: position === "left" || position === "right" ? Drag.XAxis :
                                                                position === "top" || position === "bottom" ? Drag.YAxis : Drag.XandYAxis
            smoothed: true
        }

        onPositionChanged: resizeParentOfBorder()
    }

    function resizeParentOfBorder(){
        if(!target){
            return;
        }

        if(mouseArea.drag.active){
            let x = target.x
            let y = target.y

            let minwidth = target._minWidth ? target._minWidth : minParentSize;
            let minheight = target._minHeight ? target._minHeight : minParentSize;
            let w = minwidth
            let h = minheight
            if(position.indexOf("left")>=0){
                x = target.x + mouseArea.mouseX
                w = target.width - mouseArea.mouseX
                if(x <=0 || w <= minwidth) return
                target.x = x
                target.width = w

            }
            if(position.indexOf("right")>=0){
                // 不要删除下面这行代码！
                target.x = x                         // 很怪异，需要用上这句代码才能使得拖动右边框时，窗口x坐标才不会变动，否则会左右两边同时改变大小。
                w = target.width + mouseArea.mouseX
                if(w<=minwidth || x + w >= target.parent.width) return
                target.width = w

            }
            if(position.indexOf("top")>=0){
                y = target.y + mouseArea.mouseY
                h = target.height - mouseArea.mouseY
                if(y<=0 || h <= minheight) return
                target.y = y
                target.height = h
            }
            if(position.indexOf("bottom")>=0){
                // 不要删除下面这行代码！
                target.y = y

                h = target.height + mouseArea.mouseY
                if(h<=minheight || y + h >= target.parent.height) return
                target.height = h
            }

            border.sizeChanged(target.x,target.y,target.width,target.height)
        }

    }
}
