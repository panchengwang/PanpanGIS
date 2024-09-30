#include "SymCircle.h"
#include "jsonutils.h"

SymCircle::SymCircle()
{
}

bool SymCircle::from_json_object(json_object *obj)
{
    _type = SYM_SHAPE_CIRCLE;
    if (!SymShape::from_json_object(obj))
    {
        return false;
    }
    return true;
}

json_object *SymCircle::to_json_object()
{
    json_object *obj = SymShape::to_json_object();
    JSON_ADD_STRING(obj, "type", "CIRCLE");
    return obj;
}
