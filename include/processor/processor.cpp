#include "processor.h"

#include "../config/globals.h"

Processor::Processor()
{
    getOs(true);
}

int& Processor::getOs(bool update)
{
    if (update)
    {
#ifdef Q_OS_LINUX
        os = OS_LINUX;
#elif Q_OS_WIN
        os = OS_WIN;
#elif Q_OS_DARWIN
        os = OS_MAC;
#elif Q_OS_MACOS
        os = OS_MAC;
#elif Q_OS_IOS
        os = OS_IOS;
#elif Q_OS_ANDROID
        os = OS_DROID;
#else
        os = OS_UNKNOWN;
#endif
    }
    return os;
}

QJsonObject& Processor::getUserData(bool update)
{
    if (update)
    {
        QJsonObject object{
            {"user", "n/a"},
            {"uid", "n/a"},
            {"gid", "n/a"},
            {"desc", "n/a"},
            {"home", "n/a"},
            {"shell", "n/a"}};

        if (os == OS_LINUX)
        {
            // min:x:1000:100:Kai Philipp:/home/min:/run/current-system/sw/bin/fish
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
                    userData = object;
                    break;
                }
            } while (!line.isNull());
        }

        userData = object;

    }
    return userData;
}

Processor::~Processor()
{
}