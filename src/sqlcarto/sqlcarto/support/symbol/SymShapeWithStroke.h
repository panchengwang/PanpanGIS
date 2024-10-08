#ifndef __SYM_SHAPE_WITH_STROKE_H
#define __SYM_SHAPE_WITH_STROKE_H

#include "SymShape.h"



class DLL_EXPORT SymShapeWithStroke : public SymShape
{
public:
    SymShapeWithStroke();
    virtual ~SymShapeWithStroke();
    virtual bool from_json_object(json_object* obj);
    virtual json_object* to_json_object()  ;

protected:
    SymStroke *_stroke;
};

#endif
