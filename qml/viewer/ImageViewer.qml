import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import pratinjau
import "../commons"

Item {
    id: root

    property real _minScale: 0.01
    property real _maxScale: 32.0
    property bool _infoVisible: false
    property string imageSource: ""

    Rectangle {
        anchors.fill: parent
        color: "#1a1a1a"

        Canvas {
            visible: false
            anchors.fill: parent
            opacity: 0.03
            onPaint: {
                var ctx = getContext("2d")
                var size = 16
                for (var x = 0; x < width; x += size) {
                    for (var y = 0; y < height; y += size) {
                        ctx.fillStyle = ((x / size + y / size) % 2 === 0)
                            ? "#ffffff" : "#000000"
                        ctx.fillRect(x, y, size, size)
                    }
                }
            }
        }
    }

    Flickable {
        id: flick
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: statusBar.top
        }
        clip: true

        contentWidth:  Math.max(image.width  * image.scale, flick.width)
        contentHeight: Math.max(image.height * image.scale, flick.height)

        boundsBehavior: Flickable.DragOverBounds
        boundsMovement: Flickable.FollowBoundsBehavior

        Image {
            id: image
            source: root.imageSource
            asynchronous: true
            cache: false
            smooth: true
            antialiasing: true

            transformOrigin: Item.TopLeft
            fillMode: Image.Pad
            width:  implicitWidth  || 1
            height: implicitHeight || 1
            x: Math.max(0, (flick.contentWidth  - image.width  * image.scale) / 2)
            y: Math.max(0, (flick.contentHeight - image.height * image.scale) / 2)

            onStatusChanged: {
                if (status === Image.Ready) {
                    fitToWindow();
                }
            }
        }

        WheelHandler {
            id: zoomHandler
            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
            onWheel: (event) => {
                const factor = event.angleDelta.y > 0 ? 1.18 : 1 / 1.18
                const newScale = Math.max(root._minScale, Math.min(root._maxScale, image.scale * factor))
                if (newScale === image.scale) return

                // Get pure mouse position
                // event.x and event.y is calculated based on the position relative to flickable content, as such:
                // pos = <cursor position relative from window> + <flickable content position>
                const absoluteX = event.x - flick.contentX
                const absoluteY = event.y - flick.contentY

                // Calculate fraction of pivot
                const pivotX = event.x / flick.contentWidth
                const pivotY = event.y / flick.contentHeight

                // Scale and shift
                image.scale = newScale
                flick.contentX = (flick.contentWidth * pivotX)  - absoluteX
                flick.contentY = (flick.contentHeight * pivotY) - absoluteY
            }
        }

        focus: true
    }

    Rectangle {
        id: statusBar
        color: "#1d1d1d"
        height: 24

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        FileInfo {
            id: info
            path: root.imageSource
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 8
            anchors.rightMargin: 8

            CTextIcon {
                source: "folder.svg"
                text: info.name
                color: "#b0c0cf"
                font.weight: 500
            }

            CTextIcon {
                source: "image/image.svg"
                text: `${image.width}x${image.height}`
                color: "#b0c0cf"
                font.weight: 500
            }

            CTextIcon {
                source: "file.svg"
                text: formatSize(info.size)
                color: "#b0c0cf"
                font.weight: 500
            }

            Item { Layout.fillWidth: true }

            CButton {
                source: image.smooth
                        ? "image/smooth.svg"
                        : "image/pixelated.svg"
                text: image.smooth ? "Smooth" : "Pixelated"
                color: "#b0c0cf"
                onClicked: image.smooth = !image.smooth
            }

            CTextIcon {
                source: "image/zoom.svg"
                text: `${image.scale.toFixed(2)}x`
                color: "#b0c0cf"
                font.weight: 500
            }
        }
    }

    function fitToWindow() {
        if (image.implicitWidth <= 0 || image.implicitHeight <= 0) return

        const scaleX = flick.width  / image.implicitWidth
        const scaleY = flick.height / image.implicitHeight
        zoomToScale(Math.min(scaleX, scaleY, 16))
    }

    function zoomToScale(scale) {
        image.scale = Math.max(root._minScale, Math.min(root._maxScale, scale))
        Qt.callLater(() => {
            flick.contentX = Math.max(0, (flick.contentWidth  - flick.width)  / 2)
            flick.contentY = Math.max(0, (flick.contentHeight - flick.height) / 2)
        })
    }

    function formatSize(size) {
        if (size === 0) return '0 B';
        const units = ['B', 'KB', 'MB', 'GB', 'TB', 'PB'];
        const i = Math.floor(Math.log(size) / Math.log(1024));
        return parseFloat((size / Math.pow(1024, i)).toFixed(2)) + ' ' + units[i];
    }
}