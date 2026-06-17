import QtQuick
import QtQuick.Layouts

Item {
    id: root
    implicitWidth: layout.implicitWidth
    implicitHeight: layout.implicitHeight

    property string source: ""
    property int size: 16

    property color color: "#FFFFFF"
    property string text: ""
    property alias font: _text.font

    RowLayout {
        id: layout
        spacing: 2

        SvgIcon {
            visible: root.source
            source: root.source
            color: root.color
            size: root.size
        }

        CText {
            id: _text
            visible: root.text
            color: root.color
            text: root.text
        }
    }
}
