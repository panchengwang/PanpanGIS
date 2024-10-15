#ifndef __SYM_CIRCLE_H
#define __SYM_CIRCLE_H

#include "SymShapeWithStrokeAndFill.h"
#include "SymPoint.h"

class DLL_EXPORT SymCircle : public SymShapeWithStrokeAndFill
{
public:
    SymCircle();
    virtual ~SymCircle();
    virtual bool fromJsonObject(json_object* obj);
    virtual json_object* toJsonObject();
    size_t memorySize();
    char* serialize(const char* buf);
    char* deserialize(const char* buf);
protected:
    SymPoint _center;
    double _radius;
};

#endif
