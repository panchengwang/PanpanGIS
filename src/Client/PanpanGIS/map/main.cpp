#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtCore>
#include <QDirIterator>
#include <QIcon>

void test(){

    QJsonDocument doc = QJsonDocument::fromJson("{"
                                                "   \"a\": 1,"
                                                "   \"children\": {"
                                                "       \"c1\": 5 "
                                                "   }"
                                                "}");
    qDebug() << doc.object().toVariantMap();

    QMap<QString, QVariant> data;
    data["z"] = 0;
    data["a"] = 1;
    data["b"] = 2;
    data["c"] = 3;

    QMap<QString, QVariant> children;
    children["z"] = 0;
    children["a"] = 1;
    children["b"] = 2;
    children["c"] = 3;
    children["children"] = children;

    ;
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
