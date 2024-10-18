import QtQuick
import QtQuick.Controls

ApplicationWindow {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    Image{
        anchors.fill: parent
        source: "https://www.csu.edu.cn/images/logo.png"
        fillMode: Image.PreserveAspectFit
    }
}
