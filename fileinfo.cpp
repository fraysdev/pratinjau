#include "fileinfo.h"

FileInfo::FileInfo(QObject *parent)
    : QObject{parent}
{}


void FileInfo::refresh() {
    m_info.setFile(m_path);
    m_info.refresh();
    emit infoChanged();
}

QString FileInfo::path() const { return m_path; }

void FileInfo::setPath(const QString &path) {
    QString local = path.startsWith("file://")
        ? QUrl(path).toLocalFile()
        : path;

    if (m_path == local) return;
    m_path = local;
    emit pathChanged();
    refresh();
}

qint64 FileInfo::fileSize() const { return m_info.size(); }
