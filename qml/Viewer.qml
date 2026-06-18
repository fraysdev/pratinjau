import QtQuick
import pratinjau
import "viewers"

// VIEWER CONTRACT
// Every single viewer QML must have these properties
//
// property string fileSource           Set by default for locating the file
// property bool ready                  Content status if loaded and usable
// signal loadError(string message)     Signal on error

Item {
    id: root

    Loader {
        id: loaderViewer
        anchors.fill: parent
        source: "viewers/NoneViewer.qml"
    }

    FileInfo {
        id: info
    }

    function openFile(filePath) {
        if (!filePath) {
            loaderViewer.source = "viewers/NoneViewer.qml"
        }

        info.path = filePath
        const suffix = info.suffix
        const mime = info.mime
        console.log(filePath, suffix, mime)

        const entry = ViewerRegistry.resolveViewer(mime, suffix)
        console.log(entry?.viewer)
        if (entry) {
            loaderViewer.setSource(entry.viewer, { "fileSource": filePath })
        } else {
            loaderViewer.source = "viewers/UnknownViewer.qml"
        }
    }
}
