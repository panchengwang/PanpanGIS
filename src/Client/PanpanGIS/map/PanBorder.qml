import QtQuick
import cn.pc.gis.control

Rectangle {
    id: border
    opacity: 0

    property string position: "right"
    property int borderWidth: 4
    property int minParentSize: 30
    property QtObject target: null

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

        // onMouseXChanged: resizeParentOfBorder()
        // onMouseYChanged: resizeParentOfBorder()
        onPositionChanged: resizeParentOfBorder()
    }

    function resizeParentOfBorder(){
        if(!target){
            return;
        }

        if(mouseArea.drag.active){
            if(position.indexOf("left")>=0){
                if(target.x + mouseArea.mouseX <= 0){
                    return;
                }

                target.width = target.width - mouseArea.mouseX
                target.x = target.x + mouseArea.mouseX
            }
            if(position.indexOf("right")>=0){
                target.width = target.width + mouseArea.mouseX

            }
            if(position.indexOf("top")>=0){
                if(target.y + mouseArea.mouseY <= 0){
                    return;
                }

                target.height = target.height - mouseArea.mouseY
                target.y = target.y + mouseArea.mouseY
            }
            if(position.indexOf("bottom")>=0){
                target.height = target.height + mouseArea.mouseY
            }
        }
        target.x = Math.max(0,target.x);
        target.y = Math.max(0,target.y);

        let minwidth = target._minWidth ? target._minWidth : minParentSize;
        let minheight = target._minHeight ? target._minHeight : minParentSize;

        target.width = Math.max(minwidth,Math.min(target.width, target.parent.width - target.x));
        target.height = Math.max(minheight,Math.min(target.height, target.parent.height - target.y));

        // let pos = mapToItem(dialog.parent,0,0)
        // dialog.x =Math.min(dialog.parent.width-dialog.width,  Math.max(0,pos.x))
        // dialog.y =Math.min(dialog.parent.height-dialog.height, Math.max(0,pos.y))
        // dialog.contentItem.x = 0
        // dialog.contentItem.y = 0
    }
}
