#include "PanAjax.h"
#include <QtCore>
#include <QtNetwork>





PanAjax::PanAjax(QObject *parent) : QObject(parent)
{
    _running = false;
    qDebug() << "ajax create";
}

PanAjax::~PanAjax()
{
    qDebug() << "ajax destroy";
}

void PanAjax::post(const QString &url, const QString &argname, const QString &argval)
{
    _running = true;
    emit runningChanged();

    QNetworkAccessManager *manager = new QNetworkAccessManager(this);
    connect(manager, SIGNAL(finished(QNetworkReply*)),this, SLOT(onReply(QNetworkReply*)));

    QNetworkRequest request;
    request.setUrl(QUrl(url));
    request.setHeader(QNetworkRequest::ContentTypeHeader,"application/x-www-form-urlencoded");

    QUrlQuery query;
    query.addQueryItem(argname,argval);

    QNetworkReply *reply = manager->post(request, query.toString(QUrl::FullyEncoded).toUtf8() );
    reply->ignoreSslErrors();
    connect(reply, SIGNAL(readyRead()), this, SLOT(onReadyRead()));
    connect(reply, SIGNAL(errorOccurred(QNetworkReply::NetworkError)),this, SLOT(onErrorOccurred(QNetworkReply::NetworkError)));
#ifndef Q_OS_WASM
    connect(reply, SIGNAL(sslErrors(const QList<QSslError>&)), this, SLOT(onSslErrors(const QList<QSslError>&)));
#endif
}

void PanAjax::get(const QString &url)
{
    QNetworkAccessManager *manager = new QNetworkAccessManager(this);
    connect(manager, SIGNAL(finished(QNetworkReply*)),this, SLOT(onReply(QNetworkReply*)));

    manager->get(QNetworkRequest(QUrl(url)));
}

bool PanAjax::running()
{
    return _running;
}

QString PanAjax::getErrorMessage(QNetworkReply::NetworkError code)
{
    QMap<int, QString> errormsgs;
    errormsgs[QNetworkReply::ConnectionRefusedError] = "the remote server refused the connection (the server is not accepting requests)";
    errormsgs[QNetworkReply::RemoteHostClosedError] = "the remote server closed the connection prematurely, before the entire reply was received and processed";
    errormsgs[QNetworkReply::HostNotFoundError] = "the remote host name was not found (invalid hostname)";
    errormsgs[QNetworkReply::TimeoutError] = "the connection to the remote server timed out";
    errormsgs[QNetworkReply::OperationCanceledError] = "the operation was canceled via calls to聽abort() or聽close() before it was finished.";
    errormsgs[QNetworkReply::SslHandshakeFailedError] = "the SSL/TLS handshake failed and the encrypted channel could not be established. The聽sslErrors() signal should have been emitted.";
    errormsgs[QNetworkReply::TemporaryNetworkFailureError] = "the connection was broken due to disconnection from the network, however the system has initiated roaming to another access point. The request should be resubmitted and will be processed as soon as the connection is re-established.";
    errormsgs[QNetworkReply::NetworkSessionFailedError] = "the connection was broken due to disconnection from the network or failure to start the network.";
    errormsgs[QNetworkReply::BackgroundRequestNotAllowedError] = "the background request is not currently allowed due to platform policy.";
    errormsgs[QNetworkReply::TooManyRedirectsError] = "while following redirects, the maximum limit was reached. The limit is by default set to 50 or as set by QNetworkRequest::setMaxRedirectsAllowed(). (This value was introduced in 5.6.)";
    errormsgs[QNetworkReply::InsecureRedirectError] = "while following redirects, the network access API detected a redirect from a encrypted protocol (https) to an unencrypted one (http). (This value was introduced in 5.6.)";
    errormsgs[QNetworkReply::ProxyConnectionRefusedError] = "the connection to the proxy server was refused (the proxy server is not accepting requests)";
    errormsgs[QNetworkReply::ProxyConnectionClosedError] = "the proxy server closed the connection prematurely, before the entire reply was received and processed";
    errormsgs[QNetworkReply::ProxyNotFoundError] = "the proxy host name was not found (invalid proxy hostname)";
    errormsgs[QNetworkReply::ProxyTimeoutError] = "the connection to the proxy timed out or the proxy did not reply in time to the request sent";
    errormsgs[QNetworkReply::ProxyAuthenticationRequiredError] = "the proxy requires authentication in order to honour the request but did not accept any credentials offered (if any)";
    errormsgs[QNetworkReply::ContentAccessDenied] = "the access to the remote content was denied (similar to HTTP error 403)";
    errormsgs[QNetworkReply::ContentOperationNotPermittedError] = "the operation requested on the remote content is not permitted";
    errormsgs[QNetworkReply::ContentNotFoundError] = "the remote content was not found at the server (similar to HTTP error 404)";
    errormsgs[QNetworkReply::AuthenticationRequiredError] = "the remote server requires authentication to serve the content but the credentials provided were not accepted (if any)";
    errormsgs[QNetworkReply::ContentReSendError] = "the request needed to be sent again, but this failed for example because the upload data could not be read a second time.";
    errormsgs[QNetworkReply::ContentConflictError] = "the request could not be completed due to a conflict with the current state of the resource.";
    errormsgs[QNetworkReply::ContentGoneError] = "the requested resource is no longer available at the server.";
    errormsgs[QNetworkReply::InternalServerError] = "the server encountered an unexpected condition which prevented it from fulfilling the request.";
    errormsgs[QNetworkReply::OperationNotImplementedError] = "the server does not support the functionality required to fulfill the request.";
    errormsgs[QNetworkReply::ServiceUnavailableError] = "the server is unable to handle the request at this time.";
    errormsgs[QNetworkReply::ProtocolUnknownError] = "the Network Access API cannot honor the request because the protocol is not known";
    errormsgs[QNetworkReply::ProtocolInvalidOperationError] = "the requested operation is invalid for this protocol";
    errormsgs[QNetworkReply::UnknownNetworkError] = "an unknown network-related error was detected";
    errormsgs[QNetworkReply::UnknownProxyError] = "an unknown proxy-related error was detected";
    errormsgs[QNetworkReply::UnknownContentError] = "an unknown error related to the remote content was detected";
    errormsgs[QNetworkReply::ProtocolFailure] = "a breakdown in protocol was detected (parsing error, invalid or unexpected responses, etc.)";
    errormsgs[QNetworkReply::UnknownServerError] = "an unknown error related to the server response was detected";

    return errormsgs[code];
}

void PanAjax::onReply(QNetworkReply *reply)
{   QNetworkAccessManager *manager = (QNetworkAccessManager*)sender();
    if(reply->error() == QNetworkReply::NoError){
        QByteArray data = reply->readAll();
        emit response(QString(data));
    }
    manager->deleteLater();

    _running = false;
    emit runningChanged();
}

void PanAjax::onReadyRead()
{

}

void PanAjax::onErrorOccurred(QNetworkReply::NetworkError code)
{
    emit error(getErrorMessage(code));
}

#ifndef Q_OS_WASM
void PanAjax::onSslErrors(const QList<QSslError> & errs)
{
    for(int i=0; i<errs.size(); i++){

    }
}
#endif

