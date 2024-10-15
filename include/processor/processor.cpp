#include "processor.h"
#include "worker.h"

#include "../config/globals.h"

Processor::Processor()
{
    mails = QJsonObject{};
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
        passwdFile.open(QIODevice::ReadOnly);
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
    return object;
}

QJsonObject Processor::getUpTime()
{
    QJsonObject object{
        {"hours", 0},
        {"minutes", 0}
    };

    if (getOs() == OS_LINUX)
    {
        QFile upFile("/proc/uptime");
        upFile.open(QIODevice::ReadOnly);
        QRegularExpression re = QRegularExpression("^(?<uptime>\\d+\\.\\d+).*$", QRegularExpression::DotMatchesEverythingOption);
        QRegularExpressionMatch match = re.match(upFile.readAll());
        if (match.hasMatch())
        {
            int upTime = round(match.captured("uptime").toFloat());
            object["minutes"] = int((upTime / 60)%60);
            object["hours"] = int(upTime / 3600);
        }
    }
    return object;
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
void Processor::setUnseen(QString provider, int unseen)
{
    // qDebug() << "Processor::setUnseen entered. - provider=" << provider << " unseen=" << unseen;
    QJsonObject tmpP = mails[provider].toObject();
    tmpP["unread"] = unseen;
    mails[provider] = tmpP;
    emit mailsChanged();
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