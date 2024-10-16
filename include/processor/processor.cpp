#include "processor.h"
#include "worker.h"

#include "../config/globals.h"

Processor::Processor()
{
    mails = QJsonObject{};

    curCpu["user"] = 0;
    curCpu["nice"] = 0;
    curCpu["system"] = 0;
    curCpu["idle"] = 0;
    curCpu["iowait"] = 0;
    curCpu["irq"] = 0;
    curCpu["softirq"] = 0;
    curCpu["steal"] = 0;
    curCpu["guest"] = 0;
    curCpu["guest_nice"] = 0;

    performance = QJsonObject{
        {"cpu", "0"},
        {"ram", "0"},
        {"temp", "0"}
    };

    QJsonObject upTime{
        {"hours", 0},
        {"minutes", 0}
    };
}

int Processor::getOs()
{
    int o;
#ifdef Q_OS_LINUX
        o = OS_LINUX;
#elif Q_OS_WIN
        o = OS_WIN;
#elif Q_OS_DARWIN
        o = OS_MAC;
#elif Q_OS_MACOS
        o = OS_MAC;
#elif Q_OS_IOS
        o = OS_IOS;
#elif Q_OS_ANDROID
        o = OS_DROID;
#else
        o = OS_UNKNOWN;
#endif
    return o;
}

QJsonObject Processor::getUserData()
{
    QJsonObject object{
        {"user", "username"},
        {"uid", "123"},
        {"gid", "123"},
        {"desc", "Fulle Name"},
        {"home", "/home/user"},
        {"shell", "/bin/bash"},
        {"pic", "../resources/profile.jpg"}
    };

    if (getOs() == OS_LINUX)
    {
        QFile passwdFile("/etc/passwd");
        if(passwdFile.open(QIODevice::ReadOnly)){
            QTextStream in(&passwdFile);
            QString line;
            do
            {
                line = in.readLine();
                QRegularExpression re = QRegularExpression("^" + qgetenv("LOGNAME") + ":.*:(?<uid>\\d+):(?<gid>\\d+):(?<desc>.*):(?<home>.*):(?<shell>.*)$", QRegularExpression::DotMatchesEverythingOption);
                QRegularExpressionMatch match = re.match(line);
                if (match.hasMatch())
                {
                    object["user"] = QString(qgetenv("LOGNAME"));
                    object["desc"] = match.captured("desc");
                    object["uid"] = match.captured("uid");
                    object["gid"] = match.captured("gid");
                    object["home"] = match.captured("home");
                    object["shell"] = match.captured("shell");
                    break;
                }
            } while (!line.isNull());
        }
    }
    return object;
}

QJsonObject Processor::getUpTime()
{
    return upTime;
}

void Processor::checkUpTime()
{
    QSettings settings;

    if (getOs() == OS_LINUX)
    {
        QString temp = settings.value("sys").toJsonObject().value("temp").toString();
        QThread* thread1 = new QThread();
        Worker* worker1 = new Worker();
        worker1->moveToThread(thread1);
        connect( worker1, &Worker::error, this, [](QString error){ qDebug() << "worker error:" << error; });
        connect( worker1, &Worker::setResult, this, &Processor::setUpTime);
        connect( thread1, &QThread::started, worker1, [this, temp, worker1]() {
            QFile upFile("/proc/uptime");
            if(upFile.open(QIODevice::ReadOnly)) {
                QJsonObject upTime = QJsonObject{};
                QRegularExpression re = QRegularExpression("^(?<uptime>\\d+\\.\\d+).*$", QRegularExpression::DotMatchesEverythingOption);
                QRegularExpressionMatch match = re.match(upFile.readAll());
                if (match.hasMatch())
                {
                    int upTimeI = round(match.captured("uptime").toFloat());
                    upTime["minutes"] = int((upTimeI / 60)%60);
                    upTime["hours"] = int(upTimeI / 3600);
                }
                upFile.close();
                emit worker1->setResult(QVariant(upTime));
            }
            emit &Worker::finished;
        });
        connect( worker1, &Worker::finished, thread1, &QThread::quit);
        connect( worker1, &Worker::finished, worker1, &Worker::deleteLater);
        connect( thread1, &QThread::finished, thread1, &QThread::deleteLater);
        thread1->start();
    }
}

QJsonObject Processor::getPerformance()
{
    return performance;
}

void Processor::checkPerformance()
{
    QSettings settings;
    // qDebug() << "checkPerformance()";
    if (getOs() == OS_LINUX)
    {
        QString temp = settings.value("sys").toJsonObject().value("temp").toString();
        QThread* thread1 = new QThread();
        Worker* worker1 = new Worker();
        worker1->moveToThread(thread1);
        connect( worker1, &Worker::error, this, [](QString error){ qDebug() << "worker error:" << error; });
        connect( worker1, &Worker::setResult, this, &Processor::setTemp);
        connect( thread1, &QThread::started, worker1, [this, temp, worker1]() {
                QFile tempFile(temp);
                if(tempFile.open(QIODevice::ReadOnly)) {
                    int temperature = QString(tempFile.readAll()).toInt() / 1000;
                    tempFile.close();
                    emit worker1->setResult(QVariant(temperature));
                }
                emit &Worker::finished;
        });
        connect( worker1, &Worker::finished, thread1, &QThread::quit);
        connect( worker1, &Worker::finished, worker1, &Worker::deleteLater);
        connect( thread1, &QThread::finished, thread1, &QThread::deleteLater);
        thread1->start();

        QThread* thread2 = new QThread();
        Worker* worker2 = new Worker();
        worker2->moveToThread(thread2);
        connect( worker2, &Worker::error, this, [](QString error){ qDebug() << "worker error:" << error; });
        connect( worker2, &Worker::setResult, this, &Processor::setCpu);
        connect( thread2, &QThread::started, worker2, [this, worker2]() {
                QFile statFile("/proc/stat");
                if(statFile.open(QIODevice::ReadOnly)){
                    float cpu;
                    QString statAll = statFile.readAll();
                    QRegularExpression re = QRegularExpression("^cpu[^0-9]+(?<all>.*).cpu0.*$", QRegularExpression::DotMatchesEverythingOption);
                    QRegularExpressionMatch match = re.match(statAll);
                    if (match.hasMatch())
                    {
                        QMap<QString, int> prevCpu = curCpu;
                        QStringList all = match.captured("all").split(" ");
                        curCpu["user"] = all[0].toInt();
                        curCpu["nice"] =all[1].toInt();
                        curCpu["system"] = all[2].toInt();
                        curCpu["idle"] = all[3].toInt();
                        curCpu["iowait"] = all[4].toInt();
                        curCpu["irq"] = all[5].toInt();
                        curCpu["softirq"] = all[6].toInt();
                        curCpu["steal"] = all[7].toInt();
                        curCpu["guest"] = all[8].toInt();
                        curCpu["guest_nice"] = all[9].toInt();

                        int prevNonIdle = prevCpu["user"] + prevCpu["nice"] + prevCpu["system"] + prevCpu["irq"] + prevCpu["softirq"] + prevCpu["steal"];
                        int nonIdle = curCpu["user"] + curCpu["nice"] + curCpu["system"] + curCpu["irq"] + curCpu["softirq"] + curCpu["steal"];

                        int prevTotal = prevCpu["idle"] + prevNonIdle;
                        int total = curCpu["idle"] + nonIdle;

                        int totald = total - prevTotal;
                        int idled = curCpu["idle"] - prevCpu["idle"];

                        cpu = (float)((float)(totald - idled) / (float)totald)*100;

                        // cpu = 100 - (float)(idle * 100) / (float)(user + nice + system + idle + iowait + irq + softirq + steal + guest + guest_nice);
                    }
                    // qDebug() << "cpu" << cpu;
                    statFile.close();
                    emit worker2->setResult(QVariant(cpu));
                }
                emit &Worker::finished;
        });
        connect( worker2, &Worker::finished, thread2, &QThread::quit);
        connect( worker2, &Worker::finished, worker2, &Worker::deleteLater);
        connect( thread2, &QThread::finished, thread2, &QThread::deleteLater);
        thread2->start();

        QThread* thread3 = new QThread();
        Worker* worker3 = new Worker();
        worker3->moveToThread(thread3);
        connect( worker3, &Worker::error, this, [](QString error){ qDebug() << "worker error:" << error; });
        connect( worker3, &Worker::setResult, this, &Processor::setDisk);
        connect( thread3, &QThread::started, worker3, [this, worker3]() {
                QFile memFile("/proc/meminfo");
                if(memFile.open(QIODevice::ReadOnly)){
                    float ram;
                    QString memAll = memFile.readAll();
                    // qDebug() << "memAll:" << memAll;
                    QRegularExpression re = QRegularExpression("^MemTotal[^0-9]+(?<total>\\d+).*MemAvailable[^0-9]+(?<free>\\d+)[^0-9]+.*$", QRegularExpression::DotMatchesEverythingOption);
                    QRegularExpressionMatch match = re.match(memAll);
                    if (match.hasMatch())
                    {
                        int total = match.captured("total").toInt();
                        int free = match.captured("free").toInt();
                        // qDebug() << total << free;
                        ram = (float)((float)(total - free) / (float)total) * 100;

                    }
                    memFile.close();
                    emit worker3->setResult(QVariant(ram));
                }
                emit &Worker::finished;
        });
        connect( worker3, &Worker::finished, thread3, &QThread::quit);
        connect( worker3, &Worker::finished, worker3, &Worker::deleteLater);
        connect( thread3, &QThread::finished, thread3, &QThread::deleteLater);
        thread3->start();
    }
}

QJsonObject Processor::getMails()
{
    return mails;
}

void Processor::checkMails()
{
    QSettings settings;

    // qDebug() << "checkMails()";

    if(settings.contains("mailbox")) {
        QJsonArray providerA = QJsonValue::fromVariant(settings.value("mailbox")).toArray();
        // qDebug() << "providerA: " << providerA;
        QJsonArray::iterator i;
        for (i = providerA.begin(); i != providerA.end(); ++i)
        {
            QJsonObject provider = (*i).toObject();
            // qDebug() << provider;
            if(mails.value(provider.value("provider").toString()).isUndefined()) mails[provider["provider"].toString()] = 
                            QJsonObject{ {"unread", 0}, {"icon", provider.value("icon").toString()}, {"webmail", provider.value("webmail").toString()} };
            QThread* thread = new QThread();
            Worker* worker = new Worker();
            worker->moveToThread(thread);
            connect( worker, &Worker::error, this, [](QString error){ qDebug() << "worker error:" << error; });
            connect( thread, &QThread::started, worker, [this, provider]() {
                    Imap* imap = new Imap(provider);
                    connect( imap, &Imap::mailsChecked, this, &Processor::setUnseen);
                    imap->run();
                    emit &Worker::finished;
            });
            connect( worker, &Worker::finished, thread, &QThread::quit);
            connect( worker, &Worker::finished, worker, &Worker::deleteLater);
            connect( thread, &QThread::finished, thread, &QThread::deleteLater);
            thread->start();
        }
    }
}

void Processor::setUpTime(QVariant upT)
{
    QMapIterator <QString, QVariant> i(upT.toMap());
    while (i.hasNext()) {
        i.next();
        upTime[i.key()] = QJsonValue::fromVariant(i.value());
    }
    emit upTimeChanged();
}

void Processor::setUnseen(QString provider, int unseen)
{
    // qDebug() << "Processor::setUnseen entered. - provider=" << provider << " unseen=" << unseen;
    QJsonObject tmpP = mails[provider].toObject();
    tmpP["unread"] = unseen;
    mails[provider] = tmpP;
    emit mailsChanged();
}
void Processor::setTemp(QVariant temp)
{
    performance["temp"] = temp.toString();
    emit performanceChanged();
}

void Processor::setCpu(QVariant cpu)
{
    performance["cpu"] = QString::number(cpu.toFloat(), 'f', 2);
    emit performanceChanged();
}

void Processor::setDisk(QVariant disk)
{
    performance["ram"] = QString::number(disk.toFloat(), 'f', 2);
    emit performanceChanged();
}

void Processor::launch(const QString &command, const QString &arguments)
{
    QProcess process;
    QStringList args = arguments.split(u' ', Qt::SkipEmptyParts);
    process.startDetached(command, args);
}

void Processor::openUrlExternally(const QString &url)
{
    QProcess process;
    QStringList args = url.split(u' ', Qt::SkipEmptyParts);
    process.startDetached("xdg-open", args);
}

Processor::~Processor()
{
}