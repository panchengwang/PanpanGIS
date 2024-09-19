#ifndef MAPCANVAS_H
#define MAPCANVAS_H

#include <QObject>
#include <QQuickItem>

class MapCanvas : public QQuickItem
{
    Q_OBJECT
    QML_ELEMENT
public:
    MapCanvas();

signals:
};

#endif // MAPCANVAS_H
