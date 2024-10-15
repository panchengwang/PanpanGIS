#include "SymArc.h"
#include "jsonutils.h"
#include <math.h>

SymArc::SymArc()
{
    _type = SYM_SHAPE_ARC;
}

bool SymArc::fromJsonObject(json_object* obj)
{
    _type = SYM_SHAPE_ARC;
    if (!SymShapeWithStroke::fromJsonObject(obj))
    {
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
    JSON_GET_DOUBLE(obj, "startangle", _startAngle, _errorMessage);
    JSON_GET_DOUBLE(obj, "endangle", _endAngle, _errorMessage);
    return true;
}

json_object* SymArc::toJsonObject()
{
    json_object* obj = SymShapeWithStroke::toJsonObject();
    JSON_ADD_STRING(obj, "type", "ARC");
    json_object_object_add(obj, "center", _center.toJsonObject());
    JSON_ADD_DOUBLE(obj, "xradius", _xradius);
    JSON_ADD_DOUBLE(obj, "yradius", _yradius);
    JSON_ADD_DOUBLE(obj, "startangle", _startAngle);
    JSON_ADD_DOUBLE(obj, "endangle", _endAngle);
    return obj;
}


size_t SymArc::memorySize() {
    size_t len = SymShapeWithStroke::memorySize();
    len += _center.memorySize();
    len += sizeof(_xradius);
    len += sizeof(_yradius);
    len += sizeof(_startAngle);
    len += sizeof(_endAngle);
    return len;
}

char* SymArc::serialize(const char* buf) {
    char* p = (char*)buf;
    p = SymShapeWithStroke::serialize(p);
    p = _center.serialize(p);
    memcpy(p, (void*)&_xradius, sizeof(_xradius));
    p += sizeof(_xradius);
    memcpy(p, (void*)&_yradius, sizeof(_yradius));
    p += sizeof(_yradius);
    memcpy(p, (void*)&_startAngle, sizeof(_startAngle));
    p += sizeof(_startAngle);
    memcpy(p, (void*)&_endAngle, sizeof(_endAngle));
    p += sizeof(_endAngle);
    return p;
}

char* SymArc::deserialize(const char* buf) {
    char* p = (char*)buf;
    p = SymShapeWithStroke::deserialize(p);

    p = _center.deserialize(p);
    memcpy((void*)&_xradius, p, sizeof(_xradius));
    p += sizeof(_xradius);
    memcpy((void*)&_yradius, p, sizeof(_yradius));
    p += sizeof(_yradius);
    memcpy((void*)&_startAngle, p, sizeof(_startAngle));
    p += sizeof(_startAngle);
    memcpy((void*)&_endAngle, p, sizeof(_endAngle));
    p += sizeof(_endAngle);
    return p;
}

SymRect SymArc::getMBR(double xscale, double yscale) {
    _center.x() + _xradius * cos(M_PI * _startAngle / 180.0);
}