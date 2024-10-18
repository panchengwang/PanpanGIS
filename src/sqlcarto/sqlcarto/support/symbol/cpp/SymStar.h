#ifndef __SYM_STAR_H
#define __SYM_STAR_H

#include "SymShapeWithStrokeAndFill.h"
#include "SymPoint.h"
#include "SymRegularPolygon.h"

class DLL_EXPORT SymStar : public  SymRegularPolygon
{
public:
    SymStar();
    virtual ~SymStar();
    virtual bool fromJsonObject(json_object* obj);
    virtual json_object* toJsonObject();
    size_t memorySize();
    char* serialize(const char* buf);
    char* deserialize(const char* buf);


    virtual void draw(SymCanvas* canvas);
protected:
    double _radius2;
};

#endif
