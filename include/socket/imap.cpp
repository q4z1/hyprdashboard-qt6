#include "imap.h"

Imap::Imap(QJsonObject p)
{
  unseen = 0;
  imapSocket = new QSslSocket();
  provider = p;

  QObject::connect(imapSocket, &QTcpSocket::connected, [this]()
                   {
        // qDebug() << "imapSocket connected.";
        imapSocket->waitForReadyRead(); });

  QObject::connect(imapSocket, &QTcpSocket::disconnected, [this]() { // qDebug() << "imapSocket disconnected.";
  });

  QObject::connect(imapSocket, &QTcpSocket::readyRead, [this]()
                   { response = imapSocket->readAll(); });

  QObject::connect(imapSocket, &QTcpSocket::errorOccurred, [this]()
                   { 
                    qDebug() << "imapSocket error" << "with" << provider["server"].toString() << ":" << error; });
}

void Imap::run()
{
  // qDebug() << "IMap::run() entered.";
  imapSocket->connectToHostEncrypted(provider["server"].toString(), provider["port"].toString().toInt());
  imapSocket->waitForConnected();
  // qDebug() << provider["server"].toString() << "response:" << response;
  if (!response.contains("* OK"))
  {
    if(imapSocket->state() == QAbstractSocket::ConnectedState) disconnect();
    return;
  }
  if (!Login())
  {
    qDebug() << "Imap login to" << provider["server"].toString() << provider["port"].toString() << " failed:";
    qDebug() << response;
    imapSocket->close();
    imapSocket->deleteLater();
  }
  else
  {
    checkUnseen();
    disconnect();
  }
  emit mailsChecked(provider["provider"].toString(), unseen);
}

bool Imap::Login()
{
  // qDebug() << ("Logging in.");
  command = ("A0001 LOGIN " + provider["user"].toString() + " \"" + provider["password"].toString() + "\"").toUtf8();
  imapSocket->write(command);
  imapSocket->write("\r\n");
  imapSocket->waitForBytesWritten();
  imapSocket->waitForReadyRead();
  // qDebug() << "response:" << response;
  if (!response.contains("CAPABILITY"))
  {
    disconnect();
    return false;
  }
  return true;
}

void Imap::checkUnseen()
{
  // qDebug() << "Check for unseen mails.";
  command = "A0002 SELECT \"INBOX\"";
  imapSocket->write(command);
  imapSocket->write("\r\n");
  imapSocket->waitForBytesWritten();
  imapSocket->waitForReadyRead();
  // qDebug() << "response:" << response;
  if (!response.contains("* OK"))
  {
    disconnect();
    return;
  }
  command = "A0003 SEARCH UNSEEN";
  imapSocket->write(command);
  imapSocket->write("\r\n");
  imapSocket->waitForBytesWritten();
  imapSocket->waitForReadyRead();
  // qDebug() << "response:" << response;
  if (response.contains("* SEARCH"))
  {
    QRegularExpression re = QRegularExpression("^.*SEARCH (?<unseen>[0-9 ]+).*$", QRegularExpression::DotMatchesEverythingOption);
    QRegularExpressionMatch match = re.match(response);
    if (match.hasMatch())
    {
      unseen = match.captured("unseen").split(" ").length();
    }
  }
}

void Imap::disconnect()
{
  // qDebug() << "imapSocket disconnecting...";
  imapSocket->disconnectFromHost();
  imapSocket->waitForDisconnected();
  imapSocket->close();
  imapSocket->deleteLater();
}

Imap::~Imap()
{
}