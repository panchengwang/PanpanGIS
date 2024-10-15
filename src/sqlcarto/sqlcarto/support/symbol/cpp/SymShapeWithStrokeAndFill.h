#ifndef __SYM_SHAPE_WITH_STROKE_AND_FILL_H
#define __SYM_SHAPE_WITH_STROKE_AND_FILL_H

#include "SymShapeWithStroke.h"
#include "SymFill.h"


class DLL_EXPORT SymShapeWithStrokeAndFill : public  SymShapeWithStroke
{
public:
    SymShapeWithStrokeAndFill();
    virtual ~SymShapeWithStrokeAndFill();
    virtual bool fromJsonObject(json_object* obj);
    virtual json_object* toJsonObject();
    size_t memorySize();
    char* serialize(const char* buf);
    char* deserialize(const char* buf);
protected:
    SymFill* _fill;
};

#endif
