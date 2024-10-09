#include "client.h"

Client::Client(QString serverName)
{
    localSocket = new QLocalSocket();

    QObject::connect(localSocket, &QLocalSocket::connected, [this]() {
        // qDebug() << "localSocket connected.";
    });

    QObject::connect(localSocket, &QLocalSocket::disconnected, [this]() {
        // qDebug() << "localSocket disconnected.";
    });

    QMetaObject::invokeMethod(localSocket, [this, &serverName]() {
        localSocket->connectToServer(serverName, QIODevice::ReadWrite); 
    });
}

bool Client::isConnected () {
    return localSocket->isOpen();
}

void Client::sendArgv (int argc, char *argv[]) {
    QString args;
    for (int i=1;i<argc;i++){
        args.append(QString(argv[i]));
        if(i < (argc - 1)) args.append(QString(" "));
    }
    localSocket->write(args.toLatin1());
    localSocket->waitForBytesWritten();
}

void Client::disconnect () {
    localSocket->close();
    localSocket->deleteLater();
}

Client::~Client()
{
}