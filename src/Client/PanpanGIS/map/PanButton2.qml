import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import cn.pc.gis.control

Control {
    id: control


    property string text: qsTr("")

    property string direction: "horizontal"
    property bool isImageIcon: false
    property string icon: PanAwesomeIcons.fa_check
    property string iconFontName: PanFonts.awesomeSolid.name
    property real iconSize: PanStyles.default_font_size
    property bool outlined: false
    property bool dense: false
    property bool backgroundVisible: true

    property string backgroundColor: control.hovered ? PanStyles.color_primary : PanStyles.color_light_grey
    property string iconColor: control.hovered ? PanStyles.color_white : PanStyles.color_text
    property string textColor: control.hovered ? PanStyles.color_white : PanStyles.color_text

    property string _backgroundColor: ""
    property string _iconColor: ""
    property string _textColor: ""
    property int alignment: ( Qt.AlignHCenter | Qt.AlignVCenter )

    signal clicked()

    implicitWidth: dense ?  grid.width + 2 * control.padding + 2 : Math.max(PanStyles.button_implicit_width, grid.width + 2 * control.padding + 2)
    implicitHeight: dense ?  grid.height + 2 * control.padding + 2 : Math.max(PanStyles.button_implicit_height, grid.height + 2 * control.padding + 2)
    padding: PanStyles.default_padding
    clip: true

    onHoveredChanged:{
        if(hovered){
            _iconColor = control.iconColor
            _textColor = control.textColor
            control.iconColor = PanStyles.color_white
            control.textColor = PanStyles.color_white
        }else{
            control.iconColor = _iconColor
            control.textColor = _textColor
        }
    }

    background: Rectangle {
        anchors.fill: parent
        border.color: control.outlined ? PanStyles.color_grey : control.backgroundColor
        radius: PanStyles.default_radius
        color: control.backgroundColor
        opacity: control.hovered ? 0.8 : (! control.backgroundVisible ? 0 : 1)
    }

    GridLayout{
        id: grid
        anchors.centerIn: parent
        anchors.horizontalCenterOffset:{
            if((control.alignment & Qt.AlignHCenter) == Qt.AlignHCenter){
                return 0;
            }else if((control.alignment & Qt.AlignLeft) == Qt.AlignLeft){
                return - ( (parent.width - grid.width) * 0.5 - padding);
            }else if((control.alignment & Qt.AlignRight) == Qt.AlignRight){
                return  (parent.width - grid.width) * 0.5 - padding;
            }
            return 0
        }
        columns: direction === "horizontal" ? 999 : 1
        rows: direction === "horizontal" ? 1 : 999

        PanLabel{
            id: fontIcon
            visible: !isImageIcon && icon.trim() !== ""
            font.pixelSize: iconSize
            text: icon
            font.family: iconFontName
            color: iconColor
        }

        Image{
            id: imageIcon
            source: isImageIcon ? icon : ""
            visible: isImageIcon && icon.trim() !== ""
            sourceSize{
                width: iconSize
                height: iconSize
            }
            fillMode: Image.PreserveAspectFit
            horizontalAlignment: Text.AlignHCenter
        }

        PanLabel{
            id: label
            text: control.text
            color: textColor
            visible: control.text.trim() !== ""
        }
    }

    MouseArea{
        anchors.fill: parent
        onClicked: {
            control.clicked()
        }
    }

}
