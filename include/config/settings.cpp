#include "settings.h"
Settings::Settings(QString appName)
{
    const QSettings::Format JsonFormat = QSettings::registerFormat("json", &readJsonFile, &writeJsonFile);
    QSettings::setDefaultFormat(JsonFormat);
    QSettings settings = QSettings(JsonFormat, QSettings::UserScope,
            QCoreApplication::instance()->organizationName(), QCoreApplication::instance()->applicationName());
    if (qEnvironmentVariableIsEmpty("QT_QUICK_CONTROLS_STYLE"))
        QQuickStyle::setStyle(settings.value("style").toString());
    const QString styleInSettings = settings.value("style").toString();
    if (styleInSettings.isEmpty())
        settings.setValue(QLatin1String("style"), QQuickStyle::name());
}

void Settings::addValue(const QString &key, const QVariant &value){
    QSettings settings;
    settings.setValue(key, value);
}

QVariant Settings::getValue(const QString &key, const QVariant &defaultValue){
    QSettings settings;
    return settings.value(key, defaultValue);
}

bool Settings::readJsonFile(QIODevice &device, QSettings::SettingsMap &map){
    QJsonDocument jsonDoc = QJsonDocument::fromJson(device.readAll());
    // qDebug() << "mapRead: " << jsonDoc.toJson(QJsonDocument::Compact);
    QJsonObject jsonObject = jsonDoc.object();
    foreach (const QString& key, jsonObject.keys()) {
        QJsonObject obj = jsonObject[key].toObject();
        map.insert(key, QVariant(jsonObject.value(key)));
    }
    // qDebug() << "mapReadOut: " << map;
    return true;
}

bool Settings::writeJsonFile(QIODevice &device, const QSettings::SettingsMap &map){
    QVariantMap vmap;
    QMapIterator<QString, QVariant> i(map);
    while (i.hasNext()) {
        i.next();
        vmap.insert(i.key(), i.value());
    }
    QJsonDocument json = QJsonDocument::fromVariant(vmap);
    device.write(json.toJson());
    return true;
}
