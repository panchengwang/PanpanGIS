#include "SymArc.h"
#include "jsonutils.h"

SymArc::SymArc()
{
}

bool SymArc::from_json_object(json_object *obj)
{
    _type = SYM_SHAPE_ARC;
    if (!SymShape::from_json_object(obj))
    {
        return false;
    }
    return true;
}

json_object *SymArc::to_json_object()
{
    json_object *obj = SymShape::to_json_object();
    JSON_ADD_STRING(obj, "type", "ARC");
    return obj;
}
