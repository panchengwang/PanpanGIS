#ifndef __SYM_ELLIPSE_H
#define __SYM_ELLIPSE_H

#include "SymShapeWithStrokeAndFill.h"
#include "SymPoint.h"

class DLL_EXPORT SymEllipse : public SymShapeWithStrokeAndFill
{
public:
    SymEllipse();
    virtual ~SymEllipse();
    virtual bool fromJsonObject(json_object* obj);
    virtual json_object* toJsonObject();
    size_t memorySize();
    char* serialize(const char* buf);
    char* deserialize(const char* buf);
protected:
    SymPoint _center;
    double _xradius;
    double _yradius;
};

#endif
