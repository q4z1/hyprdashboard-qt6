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
    QElapsedTimer appTimer;
    Q_INVOKABLE QJsonObject getUserData();
    Q_INVOKABLE void checkMails();
    Q_INVOKABLE void checkPerformance();
    Q_INVOKABLE void checkUpTime();
    Q_INVOKABLE QJsonObject getMails();
    Q_INVOKABLE QJsonObject getPerformance();
    Q_INVOKABLE QJsonObject getUpTime();
    Q_INVOKABLE QJsonObject getAppUpTime();

public slots:
    void launch(const QString &command, const QString &args);
    void openUrlExternally(const QString &command);
    void setUnseen(QString provider, int unseen);
    void setUpTime(QVariant upTime);
    void setTemp(QVariant temp);
    void setCpu(QVariant cpu);
    void setDisk(QVariant disk);

signals:
    void mailsChanged();
    void performanceChanged();
    void upTimeChanged();

private:
    QJsonObject mails;
    QJsonObject performance;
    QJsonObject upTime;
    QJsonObject appUpTime;
    QMap<QString, int> curCpu;
};
 
#endif // PROCESSOR_H