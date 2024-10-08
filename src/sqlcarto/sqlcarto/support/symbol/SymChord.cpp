#include "SymChord.h"
#include "jsonutils.h"
#include "SymArc.h"

SymChord::SymChord()
{
}

SymChord::~SymChord()
{
}

bool SymChord::from_json_object(json_object *obj)
{
    if(!SymPie::from_json_object(obj)){
        return false;
    }
    _type = SYM_SHAPE_CHORD;
    return true;
}

json_object *SymChord::to_json_object()
{
    json_object *obj = SymPie::to_json_object();
    JSON_ADD_STRING(obj, "type", "CHORD");
    return obj;
}
