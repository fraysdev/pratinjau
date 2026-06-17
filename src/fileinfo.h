#ifndef FILEINFO_H
#define FILEINFO_H

#include <QObject>
#include <QFileInfo>
#include <QUrl>
#include <QDateTime>
#include <QMimeType>
#include <QMimeDatabase>
#include <QQmlEngine>

class FileInfo : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QString path
               READ path
               WRITE setPath
               NOTIFY pathChanged)

    Q_PROPERTY(qint64 size READ size NOTIFY infoChanged)
    Q_PROPERTY(QString name READ name NOTIFY infoChanged)

    Q_PROPERTY(QDateTime createdAt READ createdAt NOTIFY infoChanged)
    Q_PROPERTY(QDateTime modifiedAt READ modifiedAt NOTIFY infoChanged)

    Q_PROPERTY(bool isSymlink READ isSymlink NOTIFY infoChanged)    // Unix
    Q_PROPERTY(bool isAlias READ isAlias NOTIFY infoChanged)        // MacOS
    Q_PROPERTY(bool isShortcut READ isShortcut NOTIFY infoChanged)  // Windows

    Q_PROPERTY(bool isFile READ isFile NOTIFY infoChanged)
    Q_PROPERTY(bool isHidden READ isHidden NOTIFY infoChanged)

    Q_PROPERTY(QString permission READ permission NOTIFY infoChanged)
    Q_PROPERTY(bool isReadable READ isReadable NOTIFY infoChanged)
    Q_PROPERTY(bool isWritable READ isWritable NOTIFY infoChanged)
    Q_PROPERTY(bool isExecutable READ isExecutable NOTIFY infoChanged)

    Q_PROPERTY(QString suffix READ suffix NOTIFY infoChanged)
    Q_PROPERTY(QString mimeType READ mimeType NOTIFY infoChanged)
    Q_PROPERTY(QString mimeComment READ mimeComment NOTIFY infoChanged)

public:
    explicit FileInfo(QObject *parent = nullptr);

    QString path() const;
    void setPath(const QString &path);

    qint64 size() const;
    Q_INVOKABLE QString prettifySize() const;

    QString name() const;
    QDateTime createdAt() const;
    QDateTime modifiedAt() const;
    bool isSymlink() const;
    bool isAlias() const;
    bool isShortcut() const;
    bool isFile() const;
    bool isHidden() const;
    QString permission() const;
    bool isReadable() const;
    bool isWritable() const;
    bool isExecutable() const;
    QString suffix() const;
    QString mimeType() const;
    QString mimeComment() const;

signals:
    void pathChanged();
    void infoChanged();

private:
    QString m_path;
    QFileInfo m_info;

    QMimeType m_mime;
    static QMimeDatabase s_mimeDb;

    void refresh();
};

#endif // FILEINFO_H
