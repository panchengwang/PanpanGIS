#ifndef __SYM_REGULAR_POLYGON_H
#define __SYM_REGULAR_POLYGON_H

#include "SymShapeWithStrokeAndFill.h"
#include "SymPoint.h"

class DLL_EXPORT SymRegularPolygon : public SymShapeWithStrokeAndFill
{
public:
    SymRegularPolygon();
    virtual ~SymRegularPolygon();
    virtual bool from_json_object(json_object* obj);
    virtual json_object* to_json_object();
    size_t memory_size();
    char* serialize(const char* buf);
protected:
    SymPoint _center;
    double _radius;
    int32_t _numEdges;
};

#endif
