#include "server.h"

Server::Server(QString serverName)
{
    QLocalServer *localServer = new QLocalServer();
    localServer->setSocketOptions(QLocalServer::WorldAccessOption);

    QObject::connect(localServer, &QLocalServer::newConnection, [localServer, this]() {
        while (localServer->hasPendingConnections()) {
            QLocalSocket* client = localServer->nextPendingConnection();

            QObject::connect(client, &QLocalSocket::readyRead, [client, this]() {
                receiveArgv(client);
            });

            if (client->bytesAvailable()) {
                receiveArgv(client);
            }
        }
    });
    if (!localServer->listen(serverName)) {
        qDebug() << "Unable to start socket server.";
    }else {
        qDebug() << "Socket server started.";
    }
}

void Server::receiveArgv(QLocalSocket* client)
{
    QString cmd = QString(client->readAll());
    if(cmd == "-q" || cmd == "--quit") {
        qDebug() << "Quit received.";
        emit quitReceived();
    }else if(cmd == "-d" || cmd == "--dashboard") {
        qDebug() << "Toggle dashboard received.";
        emit dashReceived();
    }else{
        qDebug() << cmd << " unknow.";
    }
    client->disconnectFromServer();
    client->deleteLater();
}

Server::~Server()
{
}