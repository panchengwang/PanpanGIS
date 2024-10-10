#ifndef __SYM_CIRCLE_H
#define __SYM_CIRCLE_H

#include "SymShapeWithStrokeAndFill.h"
#include "SymPoint.h"

class DLL_EXPORT SymCircle : public SymShapeWithStrokeAndFill
{
public:
    SymCircle();
    virtual ~SymCircle();
    virtual bool from_json_object(json_object* obj);
    virtual json_object* to_json_object();
    size_t memory_size();
    char* serialize(const char* buf);
    char* deserialize(const char* buf);
protected:
    SymPoint _center;
    double _radius;
};

#endif
