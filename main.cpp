// Copyright (C) 2017 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause
#include <QGuiApplication>
#include <QLocalServer>
#include <QLocalSocket>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include <QIcon>
#include <QWindow>
#include <QCommandLineParser>
#include <QCommandLineOption>

#include <QDebug>

#include <include/config/globals.h>
#include <include/config/settings.h>
#include <include/socket/client.h>
#include <include/socket/server.h>
#include <include/processor/processor.h>

bool isServer = false;
bool isRunning = false;

int main(int argc, char *argv[])
{
    QString appName = "hyprdash";
    QGuiApplication app(argc, argv);
    QGuiApplication::setApplicationName(appName); // ~/.config file
    QGuiApplication::setOrganizationName(appName); // ~/.config folder

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
    parser.process(app);

    isServer = parser.isSet(serverOption);

    // connect to socket server if running:
    Client *localClient = new Client(appName);
    isRunning = localClient->isConnected();

    // send argv to server if running
    if(isRunning && argc > 1 && !isServer){
        localClient->sendArgv(argc, argv);
        qDebug("OK");
        app.quit();
    }

    localClient->disconnect();
    delete localClient;

    if(!isRunning && (isServer || argc < 2)) {
        Server *localServer = new Server(appName);
        Processor *processor = new Processor();

        QObject::connect(localServer, &Server::quitReceived, QCoreApplication::instance(), &QCoreApplication::quit);

        Settings* settings = new Settings(appName);
        if(!settings->getValue("userInfo").isValid()) settings->addValue("userInfo", processor->getUserData());

        QQmlApplicationEngine engine;
   
        QObject::connect(localServer, &Server::dashReceived, QCoreApplication::instance(), [&engine]()->void{
            QObject *root = engine.rootObjects().first();
            if(root->property("visibility") == QVariant(QWindow::Hidden)) {
                // qDebug("showing dashboard.");
                root->setProperty("visibility", QWindow::FullScreen);
            }else {
                // qDebug("hiding dashboard.");
                root->setProperty("visibility", QWindow::Hidden);
            }
        });

        engine.rootContext()->setContextProperty("processor", processor);
        engine.rootContext()->setContextProperty("gSettings", settings);

        engine.load(QUrl("qrc:/hyprdash.qml"));
        if (engine.rootObjects().isEmpty())
            return -1;
        app.exec();
    }
    
    if(isRunning && isServer) {
        qDebug("Server already running.");
        return -1;
    }

    return 0;
}
