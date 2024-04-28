import QtQuick
import QtQuick.Controls
import cn.pc.gis.control
import QtQuick.Layouts

ApplicationWindow {
    id: app
    property ApplicationWindow appWin: app
    color: PanStyles.color_white
    header: Rectangle{
        width: parent.width
        height: PanStyles.header_implicit_height
        color: PanStyles.color_primary

        RowLayout{
            anchors.fill: parent


            Rectangle{
                Layout.fillHeight: true
                Layout.margins: PanStyles.default_margin *0.5
                Layout.leftMargin: PanStyles.default_margin
                radius: PanStyles.default_radius
                width: 60
                color: PanStyles.color_white
                Image{
                    anchors.fill: parent
                    source : "../control/icons/panpangis.svg"
                    fillMode: Image.PreserveAspectFit
                }
            }



            PanLabel{
                text: "麓山老将"
                Layout.fillHeight: true
                Layout.leftMargin: PanStyles.default_margin
                color: PanStyles.color_white
                font.pointSize:  PanStyles.header_text_font_size
            }

            PanLabel{
                text: "支离东北风尘际，漂泊西南天地间。三峡楼台淹日月，五溪衣服共云山。羯胡事主终无赖，词客哀时且未还。庾信平生最萧瑟，暮年诗赋动江关。 --杜甫(唐)"
                font.pointSize: 10
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                Layout.leftMargin: PanStyles.default_margin * 3
                color: PanStyles.color_white
                elide: Text.ElideRight

            }

            PanButton{
                text: "用户信息"
                icon.name: PanMaterialIcons.md_account_circle
                // font.family: PanFonts.material.name
                Layout.rightMargin: PanStyles.default_margin
            }




        }
    }
}
