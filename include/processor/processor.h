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
    int getOs();
    Q_INVOKABLE QJsonObject getUpTime();
    Q_INVOKABLE QJsonObject getUserData();

public slots:
    void launch(const QString &command, const QString &args);
    void openUrlExternally(const QString &command);


signals:

private:

};
 
#endif // PROCESSOR_H