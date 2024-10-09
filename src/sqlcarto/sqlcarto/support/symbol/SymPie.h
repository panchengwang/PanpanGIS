#ifndef __SYM_PIE_H
#define __SYM_PIE_H

#include "SymShapeWithStrokeAndFill.h"
#include "SymPoint.h"

class DLL_EXPORT SymPie : public SymShapeWithStrokeAndFill
{
public:
    SymPie();
    virtual bool from_json_object(json_object* obj);
    virtual json_object* to_json_object();
    size_t memory_size();
    char* serialize(const char* buf);
protected:
    SymPoint _center;
    double _xradius, _yradius;
    double _startAngle, _endAngle;

};

#endif
