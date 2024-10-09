#ifndef PROCESSOR_H
#define PROCESSOR_H

#include <QtCore>
#include <QtSystemDetection>
#include <QDebug>


class Processor : public QObject
{
    Q_OBJECT

public:
    Processor();
    ~Processor();
    int& getOs(bool update = false);
    QJsonObject& getUserData(bool update = false);

private slots:


signals:

private:
    int os;
    QJsonObject userData;
};
 
#endif // PROCESSOR_H