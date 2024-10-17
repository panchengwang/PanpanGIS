#ifndef __SYM_REGULAR_POLYGON_H
#define __SYM_REGULAR_POLYGON_H

#include "SymShapeWithStrokeAndFill.h"
#include "SymPoint.h"

class DLL_EXPORT SymRegularPolygon : public SymShapeWithStrokeAndFill
{
public:
    SymRegularPolygon();
    virtual ~SymRegularPolygon();
    virtual bool fromJsonObject(json_object* obj);
    virtual json_object* toJsonObject();
    size_t memorySize();
    char* serialize(const char* buf);
    char* deserialize(const char* buf);

    SymRect getMBR() const;
    virtual void draw(SymCanvas* canvas);
protected:
    SymPoint _center;
    double _radius;
    int32_t _numEdges;
};

#endif
