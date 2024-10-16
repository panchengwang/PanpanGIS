#include "SymCircle.h"
#include "jsonutils.h"

SymCircle::SymCircle()
{
    _type = SYM_SHAPE_CIRCLE;
}


SymCircle::~SymCircle()
{

}

bool SymCircle::fromJsonObject(json_object* obj)
{
    _type = SYM_SHAPE_CIRCLE;
    if (!SymShapeWithStrokeAndFill::fromJsonObject(obj))
    {
        return false;
    }

    json_object* centerobj = NULL;
    JSON_GET_OBJ(obj, "center", centerobj, _errorMessage);
    if (!_center.fromJsonObject(centerobj)) {
        _errorMessage = _center.getErrorMessage();
        return false;
    }
    JSON_GET_DOUBLE(obj, "radius", _radius, _errorMessage);

    return true;
}

json_object* SymCircle::toJsonObject()
{
    json_object* obj = SymShapeWithStrokeAndFill::toJsonObject();
    JSON_ADD_STRING(obj, "type", "CIRCLE");
    json_object_object_add(obj, "center", _center.toJsonObject());
    JSON_ADD_DOUBLE(obj, "radius", _radius);
    return obj;
}


size_t SymCircle::memorySize() {
    size_t len = SymShapeWithStrokeAndFill::memorySize();
    len += _center.memorySize();
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


SymRect SymCircle::getMBR() const {
    double x1 = (_center.x() - _radius);
    double y1 = (_center.y() - _radius);
    double x2 = (_center.x() + _radius);
    double y2 = (_center.y() + _radius);

    return SymRect(x1, y1, x2, y2);
}