#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtCore>
#include <QDirIterator>
#include <QIcon>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    app.setWindowIcon(QIcon(":/cn/pc/gis/control/icons/panpangis.svg"));
    QQmlApplicationEngine engine;
    engine.addImportPath(":/");
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("cn.pc.gis.map", "Main");

    // QDirIterator it(":",QDirIterator::Subdirectories);








    // while(it.hasNext()){
    //     qDebug() << it.next();
    // }
    return app.exec();
}
