#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtCore>
#include <QDirIterator>
#include <QIcon>

void test(){

    QString str = "[abc]08/12/1985[dddd]";
    QRegularExpression re("\\[([a-zA-z0-9]*)\\]");
    QRegularExpressionMatchIterator it = re.globalMatch(str);
    while(it.hasNext()){
        QRegularExpressionMatch match = it.next();
        str.replace("["+match.captured(1)+"]", QString("pcwang%1").arg(rand()));
    }
    qDebug() << str;
}


int main(int argc, char *argv[])
{
    test();
    QGuiApplication app(argc, argv);

    app.setWindowIcon(QIcon(":/cn/pc/gis/control/icons/pcwang_gis2.svg"));
    QQmlApplicationEngine engine;
    engine.addImportPath(":/");
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("cn.pc.gis.map", "Main");

    return app.exec();
}
