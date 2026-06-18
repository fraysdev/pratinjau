import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Button {
    id: control

    property string source: ""
    property int size: 16
    property color color: "#FFFFFF"

    background: Rectangle {
        color: "transparent"
    }

    contentItem: RowLayout {
        spacing: 2

        SvgIcon {
            // visible: control.source
            source: control.source
            color: control.color
            size: control.size
        }

        CText {
            id: _text
            // visible: control.text
            color: control.color
            text: control.text
            font: control.font
        }
    }
}
