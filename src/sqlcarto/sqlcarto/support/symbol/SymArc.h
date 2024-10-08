#ifndef __SYM_ARC_H
#define __SYM_ARC_H

#include "SymShapeWithStroke.h"
#include "SymPoint.h"

class DLL_EXPORT SymArc : public SymShapeWithStroke
{
public:
    SymArc();
    virtual bool from_json_object(json_object* obj);
    virtual json_object* to_json_object() ;

protected:
    SymPoint _center;
    double _xradius,_yradius;
    double _startAngle,_endAngle;
};

#endif
