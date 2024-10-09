#ifndef SERVER_H
#define SERVER_H

#include <QLocalServer>
#include <QLocalSocket>

#include <QDebug>

class Server : public QObject
{
    Q_OBJECT

public:
    Server(QString serverName);
    ~Server();

private slots:
    void receiveArgv(QLocalSocket* client);

signals:
    void quitReceived();
    void dashReceived();

private:
    QLocalServer* localServer;

};
 
#endif // SERVER_H