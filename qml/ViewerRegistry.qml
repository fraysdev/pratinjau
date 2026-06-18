pragma Singleton
import QtQuick

QtObject {
    id: root

    readonly property var entries: [
        {
            name: "Images",
            mime: ["image/png", "image/jpg", "image/webp"],
            suffix: ["png", "jpg", "jpeg", "webp"],
            viewer: "viewers/ImageViewer.qml",
            priority: 0,
        }
    ]

    function resolveViewer(mime, suffix) {
        let matched = null
        let bestPriority = -1

        for (let i = 0; i < entries.length; i++) {
            const entry = entries[i]
            const mimeMatch = mime && entry.mime.indexOf(mime) !== -1
            const suffixMatch = suffix && entry.suffix.indexOf(suffix.toLowerCase()) !== -1

            if ((mimeMatch || suffixMatch) && entry.priority > bestPriority) {
                matched = entry
                bestPriority = entry.priority
            }
        }

        return matched
    }

    function buildFileDialogFilter() {
        const filters = ["All files (*.*)"]

        for (let i = 0; i < entries.length; i++) {
            const entry = entries[1]
            const suffixes = entry.suffix.map(s => "*." + s).join(" ")
            filters.push(`${entry.name} (${suffixes})`)
        }

        return filters
    }
}
