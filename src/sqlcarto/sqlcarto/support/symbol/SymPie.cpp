#include "SymPie.h"
#include "jsonutils.h"
#include "SymArc.h"

SymPie::SymPie()
{
}

bool SymPie::from_json_object(json_object *obj)
{
    if(!SymArc::from_json_object(obj)){
        return false;
    }
    _type = SYM_SHAPE_PIE;
    return true;
}

json_object *SymPie::to_json_object()
{
    json_object *obj = SymShape::to_json_object();
    JSON_ADD_STRING(obj, "type", "PIE");
    return obj;
}
