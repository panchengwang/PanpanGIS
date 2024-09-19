#ifndef PANAJAX_H
#define PANAJAX_H

#include <QObject>
#include <QQmlEngine>
#include <QNetworkReply>

class PanAjax : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(bool running READ running NOTIFY runningChanged FINAL)

public:
    explicit PanAjax(QObject *parent = nullptr);
    virtual ~PanAjax();

    Q_INVOKABLE void post(const QString& url, const QString& argname, const QString& argval);
    Q_INVOKABLE void get(const QString& url);

    bool running();

protected:
    QString getErrorMessage(QNetworkReply::NetworkError code);
protected slots:
    void onReply(QNetworkReply* reply);
    void onReadyRead();
    void onErrorOccurred(QNetworkReply::NetworkError);
#ifndef Q_OS_WASM
    void onSslErrors(const QList<QSslError>&);
#endif

signals:
    void response(const QString& data);
    void error(const QString& message);
    void runningChanged();

protected:
    bool _running;
};

#endif // PANAJAX_H
