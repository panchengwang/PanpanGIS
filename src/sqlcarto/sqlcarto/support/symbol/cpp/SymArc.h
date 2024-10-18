#ifndef __SYM_ARC_H
#define __SYM_ARC_H

#include "SymShapeWithStroke.h"
#include "SymPoint.h"
#include "SymCanvas.h"

class DLL_EXPORT SymArc : public SymShapeWithStroke
{
public:
    SymArc();
    virtual bool fromJsonObject(json_object* obj);
    virtual json_object* toJsonObject();
    size_t memorySize();
    char* serialize(const char* buf);
    char* deserialize(const char* buf);
    virtual SymRect getMBR() const;
    virtual void draw(SymCanvas* canvas);
protected:
    SymPoint _center;
    double _rotate;
    double _xradius, _yradius;
    double _startAngle, _endAngle;
};

#endif
