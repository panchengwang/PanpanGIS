#ifndef __SYM_POLYGON_H
#define __SYM_POLYGON_H

#include "SymShapeWithStrokeAndFill.h"
#include "SymPoint.h"

class DLL_EXPORT SymPolygon : public SymShapeWithStrokeAndFill
{
public:
    SymPolygon();
    virtual ~SymPolygon();
    virtual bool fromJsonObject(json_object* obj);
    virtual json_object* toJsonObject();
    size_t memorySize();
    char* serialize(const char* buf);
    char* deserialize(const char* buf);
protected:
    std::vector<SymPoint> _points;
};

#endif
