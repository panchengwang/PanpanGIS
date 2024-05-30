#include "PanAjax.h"
#include <QtCore>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>

PanAjax::PanAjax(QObject *parent) : QObject(parent)
{

}

PanAjax::~PanAjax()
{

}

void PanAjax::post(const QString &url, const QString &argname, const QString &argval)
{
    QNetworkAccessManager *manager = new QNetworkAccessManager(this);
    connect(manager, SIGNAL(finished(QNetworkReply*)),this, SLOT(onReply(QNetworkReply*)));

    QNetworkRequest request;
    request.setUrl(QUrl(url));
    request.setHeader(QNetworkRequest::ContentTypeHeader,"application/x-www-form-urlencoded");

    QUrlQuery query;
    query.addQueryItem(argname,argval);

    manager->post(request, query.toString(QUrl::FullyEncoded).toUtf8() );

}

void PanAjax::get(const QString &url)
{
    QNetworkAccessManager *manager = new QNetworkAccessManager(this);
    connect(manager, SIGNAL(finished(QNetworkReply*)),this, SLOT(onReply(QNetworkReply*)));

    manager->get(QNetworkRequest(QUrl(url)));
}

void PanAjax::onReply(QNetworkReply *reply)
{
    QNetworkAccessManager *manager = (QNetworkAccessManager*)sender();
    QByteArray data = reply->readAll();
    emit response(QString(data));
    manager->deleteLater();
}
