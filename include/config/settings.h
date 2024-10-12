#ifndef SETTINGS_H
#define SETTINGS_H

#include <QtCore>
#include <QSettings>
#include <QCoreApplication>
#include <QQuickStyle>
#include <QIODevice>

#include <QDebug>

class Settings : public QSettings
{
    Q_OBJECT

public:
    Settings(QString appName);
    static bool readJsonFile(QIODevice &device, QSettings::SettingsMap &map);
    static bool writeJsonFile(QIODevice &device, const QSettings::SettingsMap &map);
    Q_INVOKABLE QVariant getValue(const QString &key, const QVariant &defaultValue = QVariant());
    Q_INVOKABLE void addValue(const QString &key, const QVariant &value);
public slots:

private:

};
Q_DECLARE_METATYPE(Settings*)
#endif // SETTINGS_H