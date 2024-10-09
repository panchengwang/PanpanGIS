#ifndef __SYM_SHAPE_WITH_STROKE_AND_FILL_H
#define __SYM_SHAPE_WITH_STROKE_AND_FILL_H

#include "SymShapeWithStroke.h"
#include "SymFill.h"


class DLL_EXPORT SymShapeWithStrokeAndFill : public  SymShapeWithStroke
{
public:
    SymShapeWithStrokeAndFill();
    virtual ~SymShapeWithStrokeAndFill();
    virtual bool from_json_object(json_object* obj);
    virtual json_object* to_json_object();
    size_t memory_size();
    char* serialize(const char* buf);
protected:
    SymFill* _fill;
};

#endif
