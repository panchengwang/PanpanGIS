import QtQuick
import QtQuick.Controls
import Qt.labs.qmlmodels

TreeView {
    delegate:   TextInput {
                  text: model.display
                  padding: 12
                  selectByMouse: true
              }
}
