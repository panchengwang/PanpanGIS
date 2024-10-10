#include "SymCircle.h"
#include "jsonutils.h"

SymCircle::SymCircle()
{
    _type = SYM_SHAPE_CIRCLE;
}


SymCircle::~SymCircle()
{

}

bool SymCircle::from_json_object(json_object* obj)
{
    _type = SYM_SHAPE_CIRCLE;
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

    return true;
}

json_object* SymCircle::to_json_object()
{
    json_object* obj = SymShapeWithStrokeAndFill::to_json_object();
    JSON_ADD_STRING(obj, "type", "CIRCLE");
    json_object_object_add(obj, "center", _center.to_json_object());
    JSON_ADD_DOUBLE(obj, "radius", _radius);
    return obj;
}


size_t SymCircle::memory_size() {
    size_t len = SymShapeWithStrokeAndFill::memory_size();
    len += _center.memory_size();
    len += sizeof(_radius);
    return len;
}

char* SymCircle::serialize(const char* buf) {
    char* p = (char*)buf;
    p = SymShapeWithStrokeAndFill::serialize(p);
    p = _center.serialize(p);
    memcpy(p, (void*)&_radius, sizeof(_radius));
    p += sizeof(_radius);

    return p;
}


char* SymCircle::deserialize(const char* buf) {
    char* p = (char*)buf;
    p = SymShapeWithStrokeAndFill::deserialize(p);
    p = _center.deserialize(p);
    memcpy((void*)&_radius, p, sizeof(_radius));
    p += sizeof(_radius);

    return p;
}
