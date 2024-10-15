#include "SymChord.h"
#include "jsonutils.h"
#include "SymArc.h"

SymChord::SymChord()
{
    _type = SYM_SHAPE_CHORD;

}

SymChord::~SymChord()
{
}

bool SymChord::fromJsonObject(json_object* obj)
{
    _type = SYM_SHAPE_CHORD;
    if (!SymPie::fromJsonObject(obj)) {
        return false;
    }
    _type = SYM_SHAPE_CHORD;
    return true;
}

json_object* SymChord::toJsonObject()
{
    json_object* obj = SymPie::toJsonObject();
    JSON_ADD_STRING(obj, "type", "CHORD");
    return obj;
}
