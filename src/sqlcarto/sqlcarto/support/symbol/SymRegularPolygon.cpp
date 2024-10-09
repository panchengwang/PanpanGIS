#include "SymRegularPolygon.h"
#include "jsonutils.h"

SymRegularPolygon::SymRegularPolygon()
{
    _type = SYM_SHAPE_REGULAR_POLYGON;
}


SymRegularPolygon::~SymRegularPolygon()
{

}

bool SymRegularPolygon::from_json_object(json_object* obj)
{
    _type = SYM_SHAPE_REGULAR_POLYGON;
    if (!SymShapeWithStrokeAndFill::from_json_object(obj))
    {
        return false;
    }

    json_object* centerobj = NULL;
    JSON_GET_OBJ(obj, "center", centerobj, _errorMessage);
    if (!_center.from_json_object(centerobj)) {
        _errorMessage = _center.getErrorMessage();
        return false;
    }
    JSON_GET_DOUBLE(obj, "radius", _radius, _errorMessage);
    JSON_GET_INT(obj, "numedges", _numEdges, _errorMessage);
    return true;
}

json_object* SymRegularPolygon::to_json_object()
{
    json_object* obj = SymShapeWithStrokeAndFill::to_json_object();
    JSON_ADD_STRING(obj, "type", "CIRCLE");
    json_object_object_add(obj, "center", _center.to_json_object());
    JSON_ADD_DOUBLE(obj, "radius", _radius);
    JSON_ADD_INT(obj, "numedges", _numEdges);
    return obj;
}


size_t SymRegularPolygon::memory_size() {
    size_t len = SymShapeWithStrokeAndFill::memory_size();
    len += _center.memory_size();
    len += sizeof(_radius);
    len += sizeof(_numEdges);
    return len;
}


char* SymRegularPolygon::serialize(const char* buf) {
    char* p = (char*)buf;
    p = SymShapeWithStrokeAndFill::serialize(p);
    p = _center.serialize(p);
    memcpy(p, (void*)&_radius, sizeof(_radius));
    p += sizeof(_radius);
    memcpy(p, (void*)&_numEdges, sizeof(_numEdges));
    p += sizeof(_numEdges);
    return p;
}
