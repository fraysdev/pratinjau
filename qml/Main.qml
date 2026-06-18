import QtQuick
import QtQuick.Dialogs

import "viewers"
import "components"

Window {
    id: window
    width: 960
    height: 600
    visible: true
    color: "#1a1a1a"
    title: qsTr("Pratinjau")
    flags: Qt.Window | Qt.FramelessWindowHint

    property string file: ""

    TitleBar {
        id: titleBar
        width: parent.width
        height: 36
        color: "#242424"
        anchors.top: parent.top
    }

    Viewer {
        id: viewer
        anchors.top: titleBar.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
    }

    FileDialog {
        id: fileDialog
        title: "Open Image"
        nameFilters: ["Image files (*.png *.jpg *.webp)"]
        onAccepted: {
            window.file = selectedFile.toString()
            viewer.openFile(window.file)
        }
    }

    Component.onCompleted: {
        const args = Qt.application.arguments
        if (args.length > 1) {
            window.file = "file://" + args[1]
        } else if (window.file.length === 0) {
            fileDialog.open()
        }
    }

    Keys.onPressed: (event) => {
        if (event.key === Qt.Key_O) {
            fileDialog.open()
        }
    }
}
