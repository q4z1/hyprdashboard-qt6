#ifndef IMAP_H
#define IMAP_H

#include <QJsonObject>
#include <QOverload>
#include <QSslSocket>
#include <QThread>

#include <QDebug>

class Imap : public QObject
{
    Q_OBJECT

public:
    Imap(QJsonObject p);
    ~Imap();
    void run();
    int unseen;

signals:
    void mailsChecked(QString pr, int unseen);

private:
    QSslSocket* imapSocket;
    QAbstractSocket::SocketError error;
    QByteArray command;
    QString response;
    QJsonObject provider;
    bool Login();
    void checkUnseen();
    void disconnect();

};
 
#endif // IMAP_H