#ifndef __SYM_SHAPE_WITH_STROKE_H
#define __SYM_SHAPE_WITH_STROKE_H

#include "SymShape.h"

class SymCanvas;


class DLL_EXPORT SymShapeWithStroke : public SymShape
{
    friend class SymCanvas;
public:
    SymShapeWithStroke();
    virtual ~SymShapeWithStroke();
    virtual bool fromJsonObject(json_object* obj);
    virtual json_object* toJsonObject();
    size_t memorySize();

    char* serialize(const char* buf);
    char* deserialize(const char* buf);

    double getStrokeWidth() const;
    virtual SymRect getMBR() const;
    void draw(SymCanvas* canvas);
protected:
    SymStroke* _stroke;
};

#endif
