#ifndef __SYM_POLYGON_H
#define __SYM_POLYGON_H

#include "SymShapeWithStrokeAndFill.h"
#include "SymPoint.h"

class DLL_EXPORT SymPolygon : public SymShapeWithStrokeAndFill
{
public:
    SymPolygon();
    virtual ~SymPolygon();
    virtual bool from_json_object(json_object *obj);
    virtual json_object *to_json_object();

protected:
    std::vector<SymPoint> _points;
};

#endif
