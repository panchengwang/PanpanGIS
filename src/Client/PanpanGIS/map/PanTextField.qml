import QtQuick
import QtQuick.Controls.Basic
import cn.pc.gis.control

TextField {
    id: control

    property string type: "text"

    echoMode: type === "password" ? TextInput.Password:TextInput.Normal
    passwordCharacter: "*"
    placeholderText: qsTr("输入文字")
    font.pixelSize: PanStyles.default_font_size
    font.family: PanFonts.notoSansSimpleChineseRegular.name

    validator: Qt.platform.os === "wasm" ? null : (type === "email" ? emailRegExp : null)

    RegularExpressionValidator {
        id: emailRegExp
        regularExpression: /\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/
    }

    background: Rectangle {
        implicitWidth: 200
        implicitHeight: 24
        color: control.enabled ? "transparent" : "#ccc"
        border.color: control.focus ? PanStyles.color_primary : PanStyles.color_light_grey
        radius: PanStyles.default_radius
    }

    onFocusChanged: {
        if(Qt.platform.os !== "wasm")
            return;
        if(focus){
            var pos = control.mapToItem(appWin.window,0,0);
            inputManager.acivate()
            inputManager.setPosition(pos.x,pos.y, control.width, control.height,
                                     control.leftPadding, control.rightPadding,
                                     control.topPadding, control.bottomPadding);
            inputManager.setDefaultText(text)
            console.log("point size: ",control.font.pointSize, "pixel size", control.font.pixelSize)
            inputManager.setStyle("font-size", "" + control.font.pixelSize + "px")
            inputManager.setStyle("border-width", "0px" )
            inputManager.setStyle("border-radius", control.background.radius + "px")
            inputManager.setStyle("-webkit-text-security","disc !important")
            inputManager.setAttribute("type",type)
            focus = false
        }
    }


    onEchoModeChanged: (echoMode) => {
                           if(echoMode === TextInput.Password){
                               type = "password"
                           }
                       }

    PanInputManager{
        id: inputManager
        onInputTextChanged: {
            text = inputManager.inputText
        }
        onTab:{


        }
    }
}

