#ifndef PROCESSOR_H
#define PROCESSOR_H

#include <QtCore>
#include <QtNetwork>
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
    QElapsedTimer appTimer;
    Q_INVOKABLE QJsonObject getUserData();
    Q_INVOKABLE void checkMails();
    Q_INVOKABLE void checkPerformance();
    Q_INVOKABLE void checkUpTime();
    Q_INVOKABLE void checkDiskSpace();
    Q_INVOKABLE void checkFeeds();
    Q_INVOKABLE QJsonObject getMails();
    Q_INVOKABLE QJsonObject getPerformance();
    Q_INVOKABLE QJsonObject getUpTime();
    Q_INVOKABLE QJsonObject getAppUpTime();
    Q_INVOKABLE QJsonObject getDiskSpace();
    Q_INVOKABLE QJsonObject getFeeds();

public slots:
    void launch(const QString &command, const QString &args);
    void openUrlExternally(const QString &command);
    void setUnseen(QString provider, int unseen);
    void setUpTime(QVariant upTime);
    void setTemp(QVariant temp);
    void setCpu(QVariant cpu);
    void setDisk(QVariant disk);
    void setFeed(QVariant feed);
    void setDiskSpace(QVariant diskSpace);

signals:
    void mailsChanged();
    void performanceChanged();
    void upTimeChanged();
    void diskSpaceChanged();
    void feedsChanged();

private:
    QJsonObject mails;
    QJsonObject feeds;
    QJsonObject performance;
    QJsonObject upTime;
    QJsonObject appUpTime;
    QJsonObject diskSpace;
    QMap<QString, int> curCpu;
    QNetworkRequest request;
};
 
#endif // PROCESSOR_H