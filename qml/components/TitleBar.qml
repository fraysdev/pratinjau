import QtQuick
import QtQuick.Layouts

import "../commons"

Rectangle {
    id: titleBar

    MouseArea {
        id: draggingHandler
        anchors.fill: parent
        onDoubleClicked: toggleMaximize()
        onPressed: root.startSystemMove()
    }

    Text {
        anchors.centerIn: parent
        text: window.title
        color: "#ffffff"
        font.pointSize: 10
        font.bold: true
    }

    // 3. Window Controls (Minimize, Maximize/Restore, Close)
    RowLayout {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.rightMargin: 6
        anchors.leftMargin: 6
        spacing: 6

        Rectangle {
            id: minimizeButton
            width: 24
            height: this.width
            radius: 4
            color: "transparent"

            SvgIcon {
                anchors.centerIn: parent
                source: "window/minimize.svg"
                color: "#ffffff"
                size: 16
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: parent.color = "#777777c7"
                onExited: parent.color = "transparent"
                onClicked: window.showMinimized()
            }
        }

        Rectangle {
            id: maximizeButton
            width: 24
            height: this.width
            radius: 4
            color: "transparent"

            SvgIcon {
                anchors.centerIn: parent
                source: "window/maximize.svg"
                color: "#ffffff"
                size: 16
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: parent.color = "#7777c777"
                onExited: parent.color = "transparent"
                onClicked: toggleMaximize()
            }
        }

        Rectangle {
            id: closeButton
            width: 24
            height: this.width
            radius: 4
            color: "transparent"

            SvgIcon {
                anchors.centerIn: parent
                source: "window/close.svg"
                color: "#ffffff"
                size: 16
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: parent.color = "#77c77777"
                onExited: parent.color = "transparent"
                onClicked: window.close()
            }
        }
    }

    DragHandler {
        id: moveWindowHandler
        onActiveChanged: if (active) window.startSystemMove();
        target: null
    }

    function toggleMaximize() {
        if (window.visibility === Window.Maximized) {
            window.showNormal()
        } else {
            window.showMaximized()
        }
    }
}