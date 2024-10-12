#include "processor.h"

#include "../config/globals.h"

Processor::Processor()
{
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