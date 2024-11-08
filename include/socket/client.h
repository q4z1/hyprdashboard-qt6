#ifndef CLIENT_H
#define CLIENT_H

#include <QLocalServer>
#include <QLocalSocket>


class Client : public QObject
{
    Q_OBJECT

public:
    Client(QString serverName);
    ~Client();
    bool isConnected();
    void sendArgv(int argc, char *argv[]);
    void disconnect();

private:
    QLocalSocket* localSocket;
};
 
#endif // CLIENT_H