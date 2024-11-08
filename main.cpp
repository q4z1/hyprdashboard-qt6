// Copyright (C) 2017 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause
#include <QApplication>
#include <QLocalServer>
#include <QLocalSocket>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include <QIcon>
#include <QWindow>
#include <QCommandLineParser>
#include <QCommandLineOption>

#include <stdio.h>
#include <stdlib.h>

#include <include/config/globals.h>
#include <include/config/settings.h>
#include <include/socket/client.h>
#include <include/socket/server.h>
#include <include/processor/processor.h>

bool isServer = false;
bool isNerd = false;
bool isRunning = false;

// QtMessageHandler originalHandler = nullptr;
void logToFile(QtMsgType type, const QMessageLogContext &context, const QString &msg);

int main(int argc, char *argv[])
{
    qInstallMessageHandler(logToFile);
    QString appName = "hyprdash";
    QApplication app(argc, argv);
    QApplication::setApplicationName(appName);  // ~/.config file
    QApplication::setOrganizationName(appName); // ~/.config folder

    QCommandLineParser parser;
    parser.setApplicationDescription("Dashboard / Launcher for hyprland");
    parser.addHelpOption();
    parser.addVersionOption();
    QCommandLineOption serverOption(QStringList() << "s" << "server",
                                    QString("Start as daemon."));
    parser.addOption(serverOption);
    QCommandLineOption quitOption(QStringList() << "q" << "quit",
                                  QString("Quit daemon."));
    parser.addOption(quitOption);
    QCommandLineOption dashOption(QStringList() << "d" << "dashboard",
                                  QString("Toggle Dashboard."));
    parser.addOption(dashOption);
    QCommandLineOption nerdOption(QStringList() << "n" << "nerd",
                                  QString("Display extra `nerd` info and log to file."));
    parser.addOption(nerdOption);
    parser.process(app);

    isServer = parser.isSet(serverOption);
    isNerd = parser.isSet(nerdOption);

    // connect to socket server if running:
    Client *localClient = new Client(appName);
    isRunning = localClient->isConnected();

    // send argv to server if running
    if (isRunning && argc > 1 && !isServer)
    {
        localClient->sendArgv(argc, argv);
        // qDebug("OK");
        app.quit();
    }

    localClient->disconnect();
    delete localClient;

    if (!isRunning && (isServer || argc < 2))
    {
        Server *localServer = new Server(appName);
        Processor *processor = new Processor();

        QObject::connect(localServer, &Server::quitReceived, QCoreApplication::instance(), &QCoreApplication::quit);

        Settings *settings = new Settings(appName);
        if (!settings->getValue("userInfo").isValid())
            settings->addValue("userInfo", processor->getUserData());

        QQmlApplicationEngine engine;

        QObject::connect(localServer, &Server::dashReceived, QCoreApplication::instance(), [&engine]() -> void
                         {
            QObject *root = engine.rootObjects().first();
            if(root->property("visibility") == QVariant(QWindow::Hidden)) {
                // qDebug("showing dashboard.");
                root->setProperty("visibility", QWindow::FullScreen);
            }else {
                // qDebug("hiding dashboard.");
                root->setProperty("visibility", QWindow::Hidden);
            } });

        engine.rootContext()->setContextProperty("processor", processor);
        engine.rootContext()->setContextProperty("gSettings", settings);
        engine.rootContext()->setContextProperty("isNerd", isNerd);
        if(isNerd){
            QElapsedTimer timer;
            timer.start();
            processor->appTimer = timer;
        }

        engine.load(QUrl("qrc:/hyprdash.qml"));
        if (engine.rootObjects().isEmpty())
            return -1;
        app.exec();
    }

    if (isRunning && isServer)
    {
        // qDebug("Server already running.");
        return -1;
    }

    return 0;
}

void logToFile(QtMsgType type, const QMessageLogContext &context, const QString &msg)
{
    if (isNerd)
    {
        QString message = qFormatLogMessage(type, context, msg);
        static FILE *f = fopen("/home/min/.config/hyprdash/hyprdash.log", "a");
        switch (type)
        {
        case QtDebugMsg:
            fprintf(f, "%s Debug: %s\n", qPrintable(QDateTime::currentDateTime().toString()), qPrintable(message));
            break;
        case QtInfoMsg:
            fprintf(f, "%s Info: %s\n", qPrintable(QDateTime::currentDateTime().toString()), qPrintable(message));
            break;
        case QtWarningMsg:
            fprintf(f, "%s Warning: %s\n", qPrintable(QDateTime::currentDateTime().toString()), qPrintable(message));
            break;
        case QtCriticalMsg:
            fprintf(f, "%s Critical: %s\n", qPrintable(QDateTime::currentDateTime().toString()), qPrintable(message));
            break;
        case QtFatalMsg:
            fprintf(f, "%s Fatal: %s\n", qPrintable(QDateTime::currentDateTime().toString()), qPrintable(message));
            break;
        }
        fflush(f);
    }
}