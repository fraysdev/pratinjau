#include "src/fileinfo.h"
#include <magic.h>

QMimeDatabase FileInfo::s_mimeDb;

FileInfo::FileInfo(QObject *parent)
    : QObject{parent}
{}


void FileInfo::refresh() {
    m_info.setFile(m_path);
    m_info.refresh();

    if (m_path.isEmpty()) {
        m_mime = QMimeType();
        emit infoChanged();
        return;
    }

    m_mime = s_mimeDb.mimeTypeForFile(m_path, QMimeDatabase::MatchContent);
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

qint64 FileInfo::size() const {
    return m_info.size();
}

QString FileInfo::prettifySize() const {
    constexpr const char* suffixes[] = {"B", "KB", "MB", "GB", "TB", "PB"};
    qint64 raw_size = m_info.size();

    int suffix = 0;
    double size = static_cast<double>(raw_size);

    while (size >= 1024) {
        size /= 1024;
        suffix++;
    }

    std::string format_size = std::format("{:.2f} {}", size, suffixes[suffix]);
    return QString::fromStdString(format_size);
}

QString FileInfo::name() const {
    return m_info.fileName();
}

QDateTime FileInfo::createdAt() const {
    return m_info.birthTime();
}

QDateTime FileInfo::modifiedAt() const {
    return m_info.lastModified();
}

bool FileInfo::isSymlink() const {
    return m_info.isSymLink();
}

bool FileInfo::isAlias() const {
    return m_info.isAlias();
}

bool FileInfo::isShortcut() const {
    return m_info.isShortcut();
}

bool FileInfo::isFile() const {
    return m_info.isFile();
}

bool FileInfo::isHidden() const {
    return m_info.isHidden();
}

QString FileInfo::permission() const {
    QFileDevice::Permissions permission = m_info.permissions();
    std::string permission_str = "";

    permission_str += permission & QFileDevice::ReadUser   ? "r" : "-";
    permission_str += permission & QFileDevice::WriteUser  ? "w" : "-";
    permission_str += permission & QFileDevice::ExeUser    ? "x" : "-";
    permission_str += permission & QFileDevice::ReadGroup  ? "r" : "-";
    permission_str += permission & QFileDevice::WriteGroup ? "w" : "-";
    permission_str += permission & QFileDevice::ExeGroup   ? "x" : "-";
    permission_str += permission & QFileDevice::ReadOther  ? "r" : "-";
    permission_str += permission & QFileDevice::WriteOther ? "w" : "-";
    permission_str += permission & QFileDevice::ExeOther   ? "x" : "-";

    return QString::fromStdString(permission_str);
}

bool FileInfo::isReadable() const {
    return m_info.isReadable();
}

bool FileInfo::isWritable() const {
    return m_info.isWritable();
}

bool FileInfo::isExecutable() const {
    return m_info.isExecutable();
}

QString FileInfo::suffix() const {
    return m_info.completeSuffix();
}

QString FileInfo::mimeType() const {
    return m_mime.name();
}

QString FileInfo::mimeComment() const {
    return m_mime.comment();
}
