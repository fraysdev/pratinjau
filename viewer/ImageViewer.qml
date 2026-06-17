import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import pratinjau

Item {
    id: root

    property real _minScale: 0.05
    property real _maxScale: 16.0
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
            smooth: false
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
        height: 36

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

            Text {
                text: "Hello, world!"
                color: "#e0f0ff"
                font.weight: 500
            }

            Text {
                text: `Size: ${info.fileSize}`
                color: "#e0f0ff"
                font.weight: 500
            }

            Text {
                text: `Resolution: ${image.width}x${image.height}`
                color: "#e0f0ff"
                font.weight: 500
            }

            Item { Layout.fillWidth: true }

            Text {
                text: `Zoom: ${image.scale.toFixed(2)}x`
                color: "#e0f0ff"
                font.weight: 500
            }
        }
    }

    function fitToWindow() {
        if (image.implicitWidth <= 0 || image.implicitHeight <= 0) return

        const scaleX = flick.width  / image.implicitWidth
        const scaleY = flick.height / image.implicitHeight
        zoomToScale(Math.min(scaleX, scaleY, 1.0))
    }

    function zoomToScale(scale) {
        image.scale = Math.max(root._minScale, Math.min(root._maxScale, scale))
        Qt.callLater(() => {
            flick.contentX = Math.max(0, (flick.contentWidth  - flick.width)  / 2)
            flick.contentY = Math.max(0, (flick.contentHeight - flick.height) / 2)
        })
    }
}