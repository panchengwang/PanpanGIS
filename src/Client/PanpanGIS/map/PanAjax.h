#ifndef PANAJAX_H
#define PANAJAX_H

#include <QObject>
#include <QQmlEngine>
#include <QNetworkReply>

class PanAjax : public QObject
{
    Q_OBJECT
    QML_ELEMENT


public:
    explicit PanAjax(QObject *parent = nullptr);
    virtual ~PanAjax();

    Q_INVOKABLE void post(const QString& url, const QString& argname, const QString& argval);
    Q_INVOKABLE void get(const QString& url);

protected slots:
    void onReply(QNetworkReply* reply);

signals:
    void response(const QString& data);


};

#endif // PANAJAX_H
