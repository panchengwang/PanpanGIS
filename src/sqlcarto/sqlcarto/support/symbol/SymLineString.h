#ifndef __SYM_LINESTRING_H
#define __SYM_LINESTRING_H

#include "SymShapeWithStroke.h"
#include "SymPoint.h"

class DLL_EXPORT SymLineString : public SymShapeWithStroke
{
public:
    SymLineString();
    virtual bool from_json_object(json_object* obj);
    virtual json_object* to_json_object() ;

protected:
    std::vector<SymPoint> _points;
};

#endif
