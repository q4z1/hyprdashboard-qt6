#ifndef PROCESSOR_H
#define PROCESSOR_H

#include <QtCore>
#include <QtSystemDetection>
#include <QDebug>
#include "../socket/imap.h"

class Processor : public QObject
{
    Q_OBJECT

public:
    Processor();
    ~Processor();
    int getOs();
    Q_INVOKABLE QJsonObject getUpTime();
    Q_INVOKABLE QJsonObject getUserData();
    Q_INVOKABLE void checkMails();
    Q_INVOKABLE QJsonObject getMails();

public slots:
    void launch(const QString &command, const QString &args);
    void openUrlExternally(const QString &command);
    void setUnseen(QString provider, int unseen);

signals:
    void mailsChanged();

private:
    QJsonObject mails;
};
 
#endif // PROCESSOR_H