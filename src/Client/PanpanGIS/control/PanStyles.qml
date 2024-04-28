pragma Singleton

import QtQuick

QtObject {
    property string color_primary: "#1976d2"
    property string color_light_primary: "#5798d9"
    property string color_secondary: "#26a69a"
    property string color_accent: "#9c27b0"
    property string color_dark: "#1d1d1d"
    property string color_dark_page: "#121212"
    property string color_positive: "#21ba45"
    property string color_negative: "#c10015"
    property string color_info: "#31ccec"
    property string color_warning: "#f2c037"
    property string color_grey: "#888888"
    property string color_white: "#ffffff"
    property string color_light_grey: "#c2c2c2"

    property string color_text: "#3f3f3f"
    property string color_button_text: "#ffffff"
    property string color_background: "#1976d2"

    property real default_radius: 4
    property real default_margin: 8
    property real default_padding: 4

    property real default_font_size: Qt.platform.os === "wasm" ? 11 : 15
    property real default_icon_size: Qt.platform.os === "wasm" ? 13 : 16

    property string textfield_focus_border_color: ""
    property real textfield_implicit_height: 32
    property real textfield_left_padding: 5
    property real textfield_right_padding: 5

    property real button_implicit_width: 24
    property real button_implicit_height: 24

    property real header_implicit_height: 40
    property real header_text_font_size: Qt.platform.os === "wasm" ? 15 : 18
}
