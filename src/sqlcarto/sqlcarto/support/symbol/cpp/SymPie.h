#ifndef __SYM_PIE_H
#define __SYM_PIE_H

#include "SymShapeWithStrokeAndFill.h"
#include "SymPoint.h"
#include <math.h>

class DLL_EXPORT SymPie : public SymShapeWithStrokeAndFill
{
public:
    SymPie();
    virtual bool fromJsonObject(json_object* obj);
    virtual json_object* toJsonObject();
    size_t memorySize();
    char* serialize(const char* buf);
    char* deserialize(const char* buf);

    SymRect getMBR() const;
    virtual void draw(SymCanvas* canvas);
protected:
    SymPoint _center;
    double _rotate;
    double _xradius, _yradius;
    double _startAngle, _endAngle;

};

#endif
