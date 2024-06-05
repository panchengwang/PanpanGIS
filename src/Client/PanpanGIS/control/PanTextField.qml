import QtQuick
import QtQuick.Controls.Basic
import cn.pc.gis.control

TextField {
    id: control

    property string type: "text"

    echoMode: type === "password" ? TextInput.Password:TextInput.Normal
    passwordCharacter: "*"
    placeholderText: qsTr("输入文字")
    font.pixelSize:  PanStyles.default_font_size
    font.family: PanFonts.notoSansSimpleChineseRegular.name

    validator: Qt.platform.os === "wasm" ? null : (type === "email" ? emailRegExp : null)

    padding: PanStyles.default_padding


    RegularExpressionValidator {
        id: emailRegExp
        regularExpression: /\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/
    }

    background: Rectangle {
        color: control.enabled ? "transparent" : "#ccc"
        border.color: control.focus ? PanStyles.color_primary : PanStyles.color_light_grey
        border.width: 1
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
            inputManager.setStyle("font-size", "" + control.font.pixelSize + "px")
            inputManager.setStyle("border-color", PanStyles.color_primary)
            inputManager.setStyle("border-width", "1pt" )
            inputManager.setStyle("border-style", "solid" )
            inputManager.setStyle("border-radius", control.background.radius + "pt")
            inputManager.setStyle("-webkit-text-security","disc !important")
            inputManager.setStyle("outline","none")
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
        onBackToInput:{
        }
    }


}

