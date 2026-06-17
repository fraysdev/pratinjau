#ifndef FILEINFO_H
#define FILEINFO_H

#include <QObject>
#include <QFileInfo>
#include <QUrl>
#include <QDateTime>
#include <QQmlEngine>

class FileInfo : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QString path
               READ path
               WRITE setPath
               NOTIFY pathChanged)

    Q_PROPERTY(qint64 fileSize READ fileSize NOTIFY infoChanged)

public:
    explicit FileInfo(QObject *parent = nullptr);

    QString path() const;
    void setPath(const QString &path);

    qint64 fileSize() const;

signals:
    void pathChanged();
    void infoChanged();

private:
    QString m_path;
    QFileInfo m_info;
    void refresh();
};

#endif // FILEINFO_H
