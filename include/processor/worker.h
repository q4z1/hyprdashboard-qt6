#include <QtCore>

class Worker : public QObject {
    Q_OBJECT
public:
    Worker();
    ~Worker();
public slots:
    void process();
signals:
    void finished();
    void error(QString err);
    void setResult(QVariant param);
private:
    // add your variables here
};