#include "SymEllipse.h"
#include "jsonutils.h"

SymEllipse::SymEllipse()
{
    _type = SYM_SHAPE_ELLIPSE;
}


SymEllipse::~SymEllipse()
{

}

bool SymEllipse::fromJsonObject(json_object* obj)
{
    _type = SYM_SHAPE_ELLIPSE;
    if (!SymShapeWithStrokeAndFill::fromJsonObject(obj)) {
        return false;
    }

    json_object* centerobj = NULL;
    JSON_GET_OBJ(obj, "center", centerobj, _errorMessage);
    if (!_center.fromJsonObject(centerobj)) {
        _errorMessage = _center.getErrorMessage();
        return false;
    }
    JSON_GET_DOUBLE(obj, "xradius", _xradius, _errorMessage);
    JSON_GET_DOUBLE(obj, "yradius", _yradius, _errorMessage);
    return true;
}

json_object* SymEllipse::toJsonObject()
{
    json_object* obj = SymShapeWithStrokeAndFill::toJsonObject();
    JSON_ADD_STRING(obj, "type", "ELLIPSE");
    json_object_object_add(obj, "center", _center.toJsonObject());
    JSON_ADD_DOUBLE(obj, "xradius", _xradius);
    JSON_ADD_DOUBLE(obj, "yradius", _yradius);
    return obj;
}


size_t SymEllipse::memorySize() {
    size_t len = SymShapeWithStrokeAndFill::memorySize();
    len += _center.memorySize();
    len += sizeof(_xradius);
    len += sizeof(_yradius);
    return len;
}


char* SymEllipse::serialize(const char* buf) {
    char* p = (char*)buf;
    p = SymShapeWithStrokeAndFill::serialize(p);
    p = _center.serialize(p);
    memcpy(p, (void*)&_xradius, sizeof(_xradius));
    p += sizeof(_xradius);
    memcpy(p, (void*)&_yradius, sizeof(_yradius));
    p += sizeof(_yradius);
    return p;
}


char* SymEllipse::deserialize(const char* buf) {
    char* p = (char*)buf;
    p = SymShapeWithStrokeAndFill::deserialize(p);
    p = _center.deserialize(p);
    memcpy((void*)&_xradius, p, sizeof(_xradius));
    p += sizeof(_xradius);
    memcpy((void*)&_yradius, p, sizeof(_yradius));
    p += sizeof(_yradius);
    return p;
}

SymRect SymEllipse::getMBR() const {
    double x1 = (_center.x() - _xradius);
    double y1 = (_center.y() - _yradius);
    double x2 = (_center.x() + _xradius);
    double y2 = (_center.y() + _yradius);

    return SymRect(x1, y1, x2, y2);
}
