import QtQuick
import QtQuick.Dialogs

import "viewer"
import "components"

Window {
    id: window
    width: 960
    height: 612
    visible: true
    color: "#1a1a1a"
    title: qsTr("Pratinjau")
    flags: Qt.Window | Qt.FramelessWindowHint

    property string file: "file:///home/frankyrayms/Pictures/wallpapers/StarRail_Image_1751467995.png"

    TitleBar {
        id: titleBar
        width: parent.width
        height: 36
        color: "#242424"
        anchors.top: parent.top
    }

    Rectangle {
        anchors.top: titleBar.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        color: "transparent"

        ImageViewer {
            id: viewer
            anchors.fill: parent
            imageSource: window.file
        }
    }

    FileDialog {
        id: fileDialog
        title: "Open Image"
        nameFilters: ["Image files (*.png *.jpg)"]
        onAccepted: window.file = selectedFile.toString()
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
