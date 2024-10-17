#ifndef __SYM_LINESTRING_H
#define __SYM_LINESTRING_H

#include "SymShapeWithStroke.h"
#include "SymPoint.h"

class DLL_EXPORT SymLineString : public SymShapeWithStroke
{
public:
    SymLineString();
    virtual bool fromJsonObject(json_object* obj);
    virtual json_object* toJsonObject();
    size_t memorySize();
    char* serialize(const char* buf);
    char* deserialize(const char* buf);
    SymRect getMBR() const;
    virtual void draw(SymCanvas* canvas);
protected:
    std::vector<SymPoint> _points;
};

#endif
