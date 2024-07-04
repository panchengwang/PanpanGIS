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
    property string color_light_grey: "#dfdfdf"


    property string color_text: "#3f3f3f"
    property string color_button_text_activate: "#ffffff"
    property string color_button_text: "#3F3F3F"
    property string color_button_activate: "#2A9EF6"
    property string color_button: "#F1F1F1"
    property string color_button_border: "#B9B9B9"

    property string color_window_caption_background : "#E8E3F1";
    property string color_window_caption_background_activate : "#D5D3D9";

    property string color_default_background: "#FFFFFE"
    property string color_panel_background: "#f0f0f0"

    property real default_radius: 4
    property real default_margin: 8
    property real default_padding: 4
    property real default_spacing: 8

    property real default_font_size: 14 // Qt.platform.os === "wasm" ? 12 : 14
    property real default_icon_size: 16 // Qt.platform.os === "wasm" ? 13 : 15

    property string textfield_focus_border_color: ""
    // property real textfield_height: Qt.platform.os === "wasm" ? 20 : 68
    property real textfield_left_padding: 5
    property real textfield_right_padding: 5

    property real button_implicit_width: 24
    property real button_implicit_height: 24

    property real window_header_footer_height: 34

    property real header_implicit_height: 32
    property real header_text_font_size: Qt.platform.os === "wasm" ? 13 : 16
}
