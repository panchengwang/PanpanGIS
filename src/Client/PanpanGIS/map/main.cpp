#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtCore>
#include <QDirIterator>
#include <QIcon>


int main(int argc, char *argv[])
{

    QGuiApplication app(argc, argv);

    app.setWindowIcon(QIcon(":/cn/pc/gis/control/icons/logo.svg"));
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
