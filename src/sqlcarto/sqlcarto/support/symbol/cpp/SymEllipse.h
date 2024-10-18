#ifndef __SYM_ELLIPSE_H
#define __SYM_ELLIPSE_H

#include "SymShapeWithStrokeAndFill.h"
#include "SymPoint.h"
#include "SymCanvas.h"
#include "SymRect.h"

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
    SymRect getMBR() const;
    virtual void draw(SymCanvas* canvas);
protected:
    SymPoint _center;
    double _rotate;
    double _xradius;
    double _yradius;
};

#endif
