import QtQuick
import QtQuick.VectorImage
import Qt5Compat.GraphicalEffects

Item {
    id: svgIcon
    property string source: ""
    property color color: "#FFFFFF"
    property int size: 20

    width: size
    height: size
    visible: source !== ""

    VectorImage {
        id: icon
        source: `qrc:/qt/qml/pratinjau/assets/icons/${svgIcon.source}`
        anchors.fill: parent
        fillMode: VectorImage.PreserveAspectFit
        preferredRendererType: VectorImage.CurveRenderer
        visible: false
    }

    ColorOverlay {
        anchors.fill: icon
        source: icon
        color: svgIcon.color
    }
}
